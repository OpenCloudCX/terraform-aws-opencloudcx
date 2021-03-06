### helming!!!

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks.endpoint
    token                  = data.aws_eks_cluster_auth.eks.token
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority.0.data)   
  }
}

resource "helm_release" "spinnaker" {
  name             = "spinnaker"
  chart            = "spinnaker"
  namespace        = "spinnaker"
  repository       = var.helm_repo
  timeout          = var.helm_timeout
  version          = var.helm_chart_version
  values           = var.helm_chart_values
  create_namespace = true
  reset_values     = false

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
  ]
}

resource "helm_release" "opencloudcx" {
  name             = "opencloudcx"
  chart            = "opencloudcx"
  namespace        = "opencloudcx"
  repository       = var.helm_repo_opencloudcx
  timeout          = var.helm_timeout
  create_namespace = true
  reset_values     = false

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
  ]
}

resource "helm_release" "portainer" {
  name             = "portainer"
  chart            = "portainer"
  namespace        = "portainer"
  repository       = var.helm_repo_portainer
  timeout          = var.helm_timeout
  create_namespace = true
  reset_values     = false

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
  ]
}

resource "helm_release" "influxdb" {
  name             = "bitnami"
  chart            = "influxdb"
  namespace        = "opencloudcx"
  repository       = var.helm_repo_influxdb
  timeout          = var.helm_timeout
  create_namespace = true
  reset_values     = false


  set {
    name="database"
    value = "prometheus"
  }

  set {
    name="adminUser.name"
    value="admin"
  }

set {
    name="adminUser.pwd"
    value="admin"
  }

set {
    name="user.name"
    value="prometheus"
  }

set {
    name="user.pwd"
    value="prometheus"
  }


  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
  ]
}
