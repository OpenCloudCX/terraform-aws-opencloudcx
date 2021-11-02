###############################################
## Kubernetes Dashboard service account things

resource "kubernetes_service_account" "dashboard_service_account" {
  metadata {
    name      = "k8s-dashboard-admin"
    namespace = "dashboard"
  }

  depends_on = [ helm_release.k8s_dashboard ]
}

resource "kubernetes_cluster_role_binding" "dashboard_cluster_role_binding" {
  metadata {
    name = "k8s-dashboard-admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "k8s-dashboard-admin"
    namespace = "dashboard"
  }
}

##
###############################################


###############################################
## Jenkins service account things

resource "kubernetes_role" "jenkins_admin_role" {
  metadata {
    name      = "admin"
    namespace = "jenkins"
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch"]
  }

  depends_on = [
    helm_release.jenkins,
  ]
}

resource "kubernetes_service_account" "jenkins_service_account" {
  metadata {
    name      = "jenkins-robot"
    namespace = "jenkins"
  }

  depends_on = [
    helm_release.jenkins,
  ]
}

resource "kubernetes_role_binding" "jenkins_service_rolebinding" {
  metadata {
    name      = "jenkins-robot-binding"
    namespace = "jenkins"
  }

  role_ref {
    kind      = "Role"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "Group"
    name      = "admin"
    namespace = "jenkins"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "jenkins-robot"
    namespace = "jenkins"
  }

  depends_on = [
    helm_release.jenkins,
  ]
}

##
###############################################




# resource "kubernetes_secret" "dockerhub_secret" {
#   metadata {
#     name      = var.dockerhub_secret_name
#     namespace = "jenkins"
#   }

#   data = {
#     ".dockerconfigjson" = <<DOCKER
# {
#   "auths": {
#     "https://index.docker.io/v1/" : {
#       "auth": "${base64encode("${var.dockerhub_username}:${var.dockerhub_secret}")}"
#     }
#   }
# }
# DOCKER
#   }

#   type = "kubernetes.io/dockerconfigjson"

#   depends_on = [
#     helm_release.ingress-controller,
#   ]
# }

