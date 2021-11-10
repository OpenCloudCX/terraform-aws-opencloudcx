resource "helm_release" "spinnaker" {
  name       = "spinnaker"
  chart      = "spinnaker"
  namespace  = "spinnaker"
  repository = var.helm_repo
  timeout    = var.helm_timeout
  version    = var.helm_chart_version
  # values           = var.helm_chart_values
  create_namespace = false
  reset_values     = false

  set {
    name  = "halyard.additionalScripts.enabled"
    value = "true"
  }

  set {
    name  = "halyard.additionalScripts.configMapName"
    value = "jenkins-setup-script"
  }

  set {
    name  = "halyard.additionalScripts.configMapKey"
    value = "get-token.sh"
  }

  set {
    name  = "halyard.spinnakerVersion"
    value = "1.19.12"
  }

  set {
    name  = "global.spinDeck.protocol"
    value = "https"
  }

  set {
    name  = "installOpenLdap"
    value = "true"
  }

  set {
    name  = "ldap.enabled"
    value = "true"
  }

  set {
    name  = "ldap.url"
    value = "ldap://-openldap:389"
  }

  set {
    name  = "sapor.config.spinnaker.authnEnabled"
    value = "true"
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
    kubernetes_config_map.jenkins_config,
    kubernetes_namespace.spinnaker,
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

resource "helm_release" "code_server" {
  name             = "code-server"
  chart            = "code-server"
  namespace        = "develop"
  repository       = var.helm_repo_code_server
  timeout          = var.helm_timeout
  version          = var.helm_code_server_version
  create_namespace = true
  reset_values     = false

  set {
    name  = "image.tag"
    value = "3.9.3-r1-alpine"
  }

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "app.env.PASSWORD"
    value = var.code_server_secret
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
  ]
}

resource "helm_release" "k8s_dashboard" {
  name             = "k8s-dashboard"
  chart            = "kubernetes-dashboard"
  namespace        = "dashboard"
  repository       = var.helm_repo_k8s_dashboard
  timeout          = var.helm_timeout
  version          = var.helm_k8s_dashboard_version
  create_namespace = true
  reset_values     = false

  set {
    name  = "settings.itemsPerPage"
    value = 30
  }

  set {
    name  = "ingress.enabled"
    value = true
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "settings.clusterName"
    value = "OpenCloudCX [stack:${var.stack}]"
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
    name  = "controller.numExecutors"
    value = "1"
  }

  /*set {
    name  = "controller.installLatestSpecifiedPlugins"
    value = "true"
  }*/

  /*set {
    name  = "serviceAccount.name"
    value = "jenkins-robot"
  }*/

  /*set {
    name  = "serviceAccount.create"
    value = true
  }*/

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
    value = "pipeline-model-extensions:1.9.2"
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
    value = "configuration-as-code:1.54"
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

  set {
    name  = "controller.ingressClassResource.name"
    value = "insecure"
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
  ]
}

resource "helm_release" "ingress-controller-secure" {
  name             = "ingress-nginx-secure"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx-secure"
  repository       = var.ingress_controller
  timeout          = var.helm_timeout
  create_namespace = true
  reset_values     = false

  set {
    name  = "controller.ingressClassResource.name"
    value = "secure"
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
  ]
}

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  repository       = var.helm_cert_manager
  timeout          = var.helm_timeout
  create_namespace = true
  reset_values     = false

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
  ]
}

resource "helm_release" "selenium3_grid" {
  name             = "selenium3"
  chart            = "selenium3"
  namespace        = "jenkins"
  repository       = var.helm_selenium
  timeout          = var.helm_timeout
  version          = var.helm_selenium_version
  create_namespace = true
  reset_values     = false

  set {
    name  = "firefox.enabled"
    value = "true"
  }

  set {
    name  = "chrome.enabled"
    value = "true"
  }

  set {
    name  = "hub.serviceType"
    value = "ClusterIP"
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
  ]
}

resource "helm_release" "keycloak" {
  name             = "keycloak"
  chart            = "keycloak"
  namespace        = "spinnaker"
  repository       = var.helm_keycloak
  timeout          = var.helm_timeout
  version          = var.helm_keycloak_version
  create_namespace = false
  reset_values     = false

  set {
    name  = "auth.adminPassword"
    value = var.keycloak_admin_secret
  }

  set {
    name  = "auth.managementPassword"
    value = var.keycloak_user_secret
  }

  # set {
  #   name  = "service.type"
  #   value = "ClusterIP"
  # }

  # set {
  #   name  = "ingress.hostname"
  #   value = data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname
  # }

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.ng,
    kubernetes_namespace.spinnaker,
  ]
}

