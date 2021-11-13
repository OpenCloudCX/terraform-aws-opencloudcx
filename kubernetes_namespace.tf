resource "kubernetes_namespace" "spinnaker" {
  metadata {
    name = "spinnaker"
  }

  depends_on = [ 
    aws_eks_cluster.eks,
    aws_eks_node_group.ng
  ]
}

resource "kubernetes_namespace" "opencloudcx" {
  metadata {
    name = "opencloudcx"
  }

  depends_on = [ 
    aws_eks_cluster.eks,
    aws_eks_node_group.ng
  ]
}
