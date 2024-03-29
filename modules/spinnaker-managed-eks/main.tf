## managed kubernetes cluster

## control plane (cp)
# security/policy
resource "aws_iam_role" "cp" {
  name = format("%s-eks", local.name)
  tags = merge(local.default-tags, var.tags)
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = format("eks.%s", data.aws_partition.current.dns_suffix)
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-cluster" {
  policy_arn = format("arn:%s:iam::aws:policy/AmazonEKSClusterPolicy", data.aws_partition.current.partition)
  role       = aws_iam_role.cp.id
}

resource "aws_iam_role_policy_attachment" "eks-service" {
  policy_arn = format("arn:%s:iam::aws:policy/AmazonEKSServicePolicy", data.aws_partition.current.partition)
  role       = aws_iam_role.cp.id
}

resource "aws_eks_cluster" "cp" {
  name     = format("%s", local.name)
  role_arn = aws_iam_role.cp.arn
  version  = var.kubernetes_version
  tags     = merge(local.default-tags, var.tags)

  enabled_cluster_log_types = var.enabled_cluster_log_types

  vpc_config {
    subnet_ids = local.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster,
    aws_iam_role_policy_attachment.eks-service,
  ]
}

data "aws_eks_cluster_auth" "cp" {
  name = aws_eks_cluster.cp.name
}

## node groups (ng)
# security/policy
resource "aws_iam_role" "ng" {
  name = format("%s-ng", local.name)
  tags = merge(local.default-tags, var.tags)
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = [format("ec2.%s", data.aws_partition.current.dns_suffix)]
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_instance_profile" "ng" {
  name = format("%s-ng", local.name)
  role = aws_iam_role.ng.name
}

resource "aws_iam_role_policy_attachment" "eks-ng" {
  policy_arn = format("arn:%s:iam::aws:policy/AmazonEKSWorkerNodePolicy", data.aws_partition.current.partition)
  role       = aws_iam_role.ng.name
}

resource "aws_iam_role_policy_attachment" "eks-cni" {
  policy_arn = format("arn:%s:iam::aws:policy/AmazonEKS_CNI_Policy", data.aws_partition.current.partition)
  role       = aws_iam_role.ng.name
}

resource "aws_iam_role_policy_attachment" "ecr-read" {
  policy_arn = format("arn:%s:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", data.aws_partition.current.partition)
  role       = aws_iam_role.ng.name
}

# eks-optimized linux
data "aws_ami" "eks" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = [format("amazon-eks-node-%s-*", var.kubernetes_version)]
  }
}

data "template_file" "boot" {
  template = <<EOT
#!/bin/bash
set -ex
/etc/eks/bootstrap.sh ${aws_eks_cluster.cp.name} --kubelet-extra-args '--node-labels=eks.amazonaws.com/nodegroup-image=${data.aws_ami.eks.id},eks.amazonaws.com/nodegroup=${aws_eks_cluster.cp.name}' --b64-cluster-ca ${aws_eks_cluster.cp.certificate_authority.0.data} --apiserver-endpoint ${aws_eks_cluster.cp.endpoint}
EOT
}

resource "aws_launch_template" "ng" {
  for_each      = (var.node_groups != null ? var.node_groups : {})
  name          = format("eks-%s", uuid())
  tags          = merge(local.default-tags, local.eks-tag, var.tags)
  image_id      = data.aws_ami.eks.id
  user_data     = base64encode(data.template_file.boot.rendered)
  instance_type = lookup(each.value, "instance_type", "t3.medium")

  iam_instance_profile {
    arn = aws_iam_instance_profile.ng.arn
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = lookup(each.value, "disk_size", "20")
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  network_interfaces {
    security_groups       = [aws_eks_cluster.cp.vpc_config.0.cluster_security_group_id]
    delete_on_termination = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(local.eks-owned-tag, var.tags)
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_autoscaling_group" "ng" {
  for_each              = (var.node_groups != null ? var.node_groups : {})
  name                  = format("eks-%s", uuid())
  vpc_zone_identifier   = local.subnet_ids
  max_size              = lookup(each.value, "max_size", 3)
  min_size              = lookup(each.value, "min_size", 1)
  desired_capacity      = lookup(each.value, "desired_size", 1)
  force_delete          = true
  protect_from_scale_in = false
  termination_policies  = ["Default"]
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.ng[each.key].id
        version            = aws_launch_template.ng[each.key].latest_version
      }

      dynamic "override" {
        for_each = lookup(each.value, "launch_override", [])
        content {
          instance_type     = lookup(override.value, "instance_type", null)
          weighted_capacity = lookup(override.value, "weighted_capacity", null)
        }
      }
    }

    dynamic "instances_distribution" {
      for_each = { for key, val in each.value : key => val if key == "instances_distribution" }
      content {
        on_demand_allocation_strategy            = lookup(instances_distribution.value, "on_demand_allocation_strategy", null)
        on_demand_base_capacity                  = lookup(instances_distribution.value, "on_demand_base_capacity", null)
        on_demand_percentage_above_base_capacity = lookup(instances_distribution.value, "on_demand_percentage_above_base_capacity", null)
        spot_allocation_strategy                 = lookup(instances_distribution.value, "spot_allocation_strategy", null)
        spot_instance_pools                      = lookup(instances_distribution.value, "spot_instance_pools", null)
        spot_max_price                           = lookup(instances_distribution.value, "spot_max_price", null)
      }
    }
  }

  dynamic "tag" {
    for_each = local.eks-tag
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity, name]
  }

  depends_on = [
    aws_iam_role.ng,
    aws_iam_role_policy_attachment.eks-ng,
    aws_iam_role_policy_attachment.eks-cni,
    aws_iam_role_policy_attachment.ecr-read,
    aws_launch_template.ng,
    kubernetes_config_map.aws-auth,
  ]
}

resource "aws_iam_openid_connect_provider" "oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  url             = aws_eks_cluster.cp.identity.0.oidc.0.issuer
}

locals {
  oidc = {
    arn = aws_iam_openid_connect_provider.oidc.arn
    url = replace(aws_iam_openid_connect_provider.oidc.url, "https://", "")
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.cp.endpoint
  token                  = data.aws_eks_cluster_auth.cp.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.cp.certificate_authority.0.data)
  load_config_file       = false
}

data "aws_iam_role" "organizational_account_access_role" {
  name = "OrganizationAccountAccessRole"
}

resource "kubernetes_config_map" "aws-auth" {
  count = (var.node_groups != null ? ((length(var.node_groups) > 0) ? 1 : 0) : 0)
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(
      [{
        rolearn  = element(compact(aws_iam_role.ng.*.arn), 0)
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }],
    )
  }
}
