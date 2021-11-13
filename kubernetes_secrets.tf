resource "kubernetes_secret" "grafana_secret" {
  metadata {
    name      = "grafana-admin"
    namespace = "opencloudcx"
  }

    data = {
      username = "admin"
      password = var.grafana_secret
    }

  type = "kubernetes.io/basic-auth"

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
    kubernetes_namespace.opencloudcx,
  ]
}

resource "kubernetes_secret" "codeserver_secret" {
  metadata {
    name      = "codeserver-password"
    namespace = "develop"
  }

    data = {
      password = var.code_server_secret
    }

  type = "kubernetes.io/basic-auth"

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
    kubernetes_namespace.develop,
  ]
}
