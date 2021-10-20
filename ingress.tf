resource "kubernetes_ingress" "jenkins_ingress" {

  wait_for_load_balancer = true

  metadata {
    name      = "jenkins-reverse-proxy"
    namespace = "jenkins"
    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = "cert-manager"
    }
  }
  spec {
    rule {

      host = "jenkins.${var.dns_zone}"

      http {
        path {
          path = "/"
          backend {
            service_name = "jenkins"
            service_port = 8080
          }
        }
      }
    }

    tls {
      secret_name = "jenkins-tls-secret"
    }
  }

  depends_on = [
    helm_release.jenkins,
    helm_release.ingress-controller,
  ]
}

resource "kubernetes_ingress" "jenkins_ingress_alb" {

  wait_for_load_balancer = true

  metadata {
    name      = "jenkins"
    namespace = "jenkins"
    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = "cert-manager"
    }
  }
  spec {
    rule {

      host = data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname

      http {
        path {
          path = "/"
          backend {
            service_name = "jenkins"
            service_port = 8080
          }
        }
      }
    }

    tls {
      secret_name = "jenkins-tls-alb-secret"
    }
  }

  depends_on = [
    helm_release.jenkins,
    helm_release.ingress-controller,
  ]
}

resource "kubernetes_ingress" "spinnaker_ingress" {

  wait_for_load_balancer = true

  metadata {
    name      = "spinnaker"
    namespace = "spinnaker"

    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = "cert-manager"
    }
  }
  spec {
    rule {

      host = "spinnaker.${var.dns_zone}"

      http {
        path {
          path = "/"
          backend {
            service_name = "spin-deck"
            service_port = 9000
          }
        }
      }
    }

    tls {
      secret_name = "spinnaker-tls-secret"
    }
  }

  depends_on = [
    helm_release.spinnaker,
    helm_release.ingress-controller,
  ]
}

resource "kubernetes_ingress" "sonarqube_ingress" {

  wait_for_load_balancer = true

  metadata {
    name      = "sonarqube"
    namespace = "sonarqube"

    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = "cert-manager"
    }
  }
  spec {
    rule {

      host = "sonarqube.${var.dns_zone}"

      http {
        path {
          path = "/"
          backend {
            service_name = "sonarqube-sonarqube"
            service_port = 9000
          }
        }
      }
    }

    tls {
      secret_name = "sonarqube-tls-secret"
    }
  }

  depends_on = [
    helm_release.sonarqube,
    helm_release.ingress-controller,
  ]
}

resource "kubernetes_ingress" "grafana_ingress" {

  wait_for_load_balancer = true

  metadata {
    name      = "grafana"
    namespace = "opencloudcx"

    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = "cert-manager"
    }
  }
  spec {
    rule {

      host = "grafana.${var.dns_zone}"

      http {
        path {
          path = "/"
          backend {
            service_name = "grafana"
            service_port = 3000
          }
        }
      }
    }

    tls {
      secret_name = "grafana-tls-secret"
    }
  }

  depends_on = [
    helm_release.ingress-controller,
  ]
}

resource "kubernetes_ingress" "anchore_ingress" {

  wait_for_load_balancer = true

  metadata {
    name      = "anchore"
    namespace = "anchore-engine"

    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = "cert-manager"
    }
  }
  spec {
    rule {

      host = "anchore.${var.dns_zone}"

      http {
        path {
          path = "/"
          backend {
            service_name = "anchore-engine-anchore-engine-api"
            service_port = 8228
          }
        }
      }
    }

    tls {
      secret_name = "anchore-tls-secret"
    }
  }

  depends_on = [
    helm_release.anchore,
    helm_release.ingress-controller,
  ]
}

resource "kubernetes_ingress" "portainer_ingress" {

  wait_for_load_balancer = true

  metadata {
    name      = "portainer"
    namespace = "portainer"

    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = "cert-manager"
    }
  }
  spec {
    rule {

      host = "portainer.${var.dns_zone}"

      http {
        path {
          path = "/"
          backend {
            service_name = "portainer"
            service_port = 9000
          }
        }
      }
    }

    tls {
      secret_name = "portainer-tls-secret"
    }
  }

  depends_on = [
    helm_release.portainer,
    helm_release.ingress-controller,
  ]
}

resource "kubernetes_ingress" "spinnaker_gate__ingress" {

  wait_for_load_balancer = true

  metadata {
    name      = "spinnaker-gate"
    namespace = "spinnaker"

    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = "cert-manager"
    }
  }
  spec {
    rule {

      host = "spinnaker-gate.${var.dns_zone}"

      http {
        path {
          path = "/"
          backend {
            service_name = "spin-gate"
            service_port = 8084
          }
        }
      }
    }

    tls {
      secret_name = "spinnaker-tls-secret"
    }
  }

  depends_on = [
    helm_release.spinnaker,
    helm_release.ingress-controller,
  ]
}

resource "kubernetes_ingress" "selenium3__ingress" {

  wait_for_load_balancer = true

  metadata {
    name      = "selenium3-grid"
    namespace = "jenkins"

    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = "cert-manager"
    }
  }
  spec {
    rule {

      host = "selenium.${var.dns_zone}"

      http {
        path {
          path = "/"
          backend {
            service_name = "selenium3-selenium-hub"
            service_port = 4444
          }
        }
      }
    }

    tls {
      secret_name = "selenium3-tls-secret"
    }
  }

  depends_on = [
    helm_release.selenium3_grid,
    helm_release.ingress-controller,
  ]
}

# resource "kubernetes_ingress" "keycloak__ingress" {

#   wait_for_load_balancer = true

#   metadata {
#     name      = "keycloak"
#     namespace = "spinnaker"

#     annotations = {
#       "kubernetes.io/ingress.class" = "nginx"
#       "cert-manager.io/cluster-issuer" = "cert-manager"
#     }
#   }
#   spec {
#     rule {

#       host = "keycloak.${var.dns_zone}"

#       http {
#         path {
#           path = "/"
#           backend {
#             service_name = "keycloak"
#             service_port = 80
#           }
#         }
#       }
#     }

#     tls {
#       secret_name = "keycloak-tls-secret"
#     }
#   }

#   depends_on = [
#     helm_release.keycloak,
#     helm_release.ingress-controller,
#   ]
# }

