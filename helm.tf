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
  version          = var.helm_portainer_version
  create_namespace = true
  reset_values     = false

  set {
    name  = "image.tag"
    value = "2.6.3-alpine"
  }

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

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
    name  = "database"
    value = "prometheus"
  }

  set {
    name  = "adminUser.name"
    value = "admin"
  }

  set {
    name  = "adminUser.pwd"
    value = "admin"
  }

  set {
    name  = "user.name"
    value = "prometheus"
  }

  set {
    name  = "user.pwd"
    value = "prometheus"
  }


  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
  ]
}

resource "helm_release" "jenkins" {
  name             = "jenkins"
  chart            = "jenkins"
  namespace        = "jenkins"
  repository       = var.helm_jenkins
  timeout          = var.helm_timeout
  version          = var.helm_jenkins_version
  create_namespace = true
  reset_values     = false

  set {
    name  = "controller.adminUser"
    value = "admin"
  }

  set {
    name  = "controller.adminPassword"
    value = var.jenkins_secret
  }

  set {
    name  = "controller.tag"
    value = "2.309-jdk11"
  }

  set {
    name  = "controller.installPlugins[0]"
    value = "kubernetes:1.29.4"
  }

  set {
    name  = "controller.installPlugins[1]"
    value = "workflow-aggregator:2.6"
  }

  set {
    name  = "controller.installPlugins[2]"
    value = "docker-build-step:2.8"
  }

  set {
    name  = "controller.installPlugins[3]"
    value = "workflow-cps-global-lib:2.21"
  }

  set {
    name  = "controller.installPlugins[4]"
    value = "pipeline-model-extensions:1.9.1"
  }

  set {
    name  = "controller.installPlugins[5]"
    value = "junit:1.52"
  }

  set {
    name  = "controller.installPlugins[6]"
    value = "matrix-project:1.19"
  }

  set {
    name  = "controller.installPlugins[7]"
    value = "lockable-resources:2.11"
  }

  set {
    name  = "controller.installPlugins[8]"
    value = "pipeline-rest-api:2.19"
  }

  set {
    name  = "controller.installPlugins[9]"
    value = "workflow-cps:2.93"
  }

  set {
    name  = "controller.installPlugins[10]"
    value = "ws-cleanup:0.39"
  }

  set {
    name  = "controller.installPlugins[11]"
    value = "docker-workflow:1.26"
  }

  set {
    name  = "controller.installPlugins[12]"
    value = "docker-commons:1.17"
  }

  set {
    name  = "controller.installPlugins[13]"
    value = "configuration-as-code:1.51"
  }

  set {
    name  = "controller.installPlugins[14]"
    value = "git:4.7.1"
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
  ]
}

resource "helm_release" "sonarqube" {
  name             = "sonarqube"
  chart            = "sonarqube"
  namespace        = "sonarqube"
  repository       = var.helm_sonarqube
  timeout          = var.helm_timeout
  create_namespace = true
  reset_values     = false


  set {
    name  = "account.currentAdminPassword"
    value = var.sonarqube_secret
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
  ]
}

resource "helm_release" "anchore" {
  name             = "anchore-engine"
  chart            = "anchore-engine"
  namespace        = "anchore-engine"
  repository       = var.helm_anchore_engine
  timeout          = var.helm_timeout
  create_namespace = true
  reset_values     = false

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
  ]
}

resource "helm_release" "ingress-controller" {
  name             = "ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  repository       = var.ingress_controller
  timeout          = var.helm_timeout
  create_namespace = true
  reset_values     = false

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
  ]

}

# resource "helm_release" "kubernetes-dashboard" {

#   name = "kubernetes-dashboard"

#   repository = "https://kubernetes.github.io/dashboard/"
#   chart      = "kubernetes-dashboard"
#   namespace  = "default"

#   set {
#     name  = "service.type"
#     value = "LoadBalancer"
#   }

#   set {
#     name  = "protocolHttp"
#     value = "true"
#   }

#   set {
#     name  = "service.externalPort"
#     value = 80
#   }

#   set {
#     name  = "replicaCount"
#     value = 2
#   }

#   set {
#     name  = "rbac.clusterReadOnlyRole"
#     value = "true"
#   }

#   depends_on = [
#     aws_eks_cluster.eks,
#     aws_eks_node_group.ng,
#   ]
# }