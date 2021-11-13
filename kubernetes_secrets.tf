######################################################
## Grafana secret

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
