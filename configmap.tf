locals {
  jenkins_config_script = templatefile("${path.module}/script/jenkins-config.tpl", {
    jenkinsPassword = var.jenkins_secret
    dns_zone        = var.dns_zone
    }
  )
}

resource "kubernetes_namespace" "spinnaker" {
  metadata {
    name = "spinnaker"
  }
}


resource "kubernetes_config_map" "jenkins_config" {
  metadata {
      namespace = "spinnaker"
      name      = "jenkins-setup-script"
  }
  data = {
     "get-token.sh" = local.jenkins_config_script
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
    kubernetes_namespace.spinnaker
  ]
}