resource "kubernetes_ingress" "jenkins_ingress" {

  wait_for_load_balancer = true

  metadata {
    name      = "jenkins"
    namespace = "jenkins"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
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
  }
}

resource "kubernetes_ingress" "spinnaker_ingress" {

  wait_for_load_balancer = true

  metadata {
    name      = "spinnaker"
    namespace = "spinnaker"

    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
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
  }
}

resource "kubernetes_ingress" "sonarqube_ingress" {

  wait_for_load_balancer = true

  metadata {
    name      = "sonarqube"
    namespace = "sonarqube"

    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
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
  }
}

resource "kubernetes_ingress" "grafana_ingress" {

  wait_for_load_balancer = true

  metadata {
    name      = "grafana"
    namespace = "opencloudcx"

    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
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
  }
}

resource "kubernetes_ingress" "anchore_ingress" {

  wait_for_load_balancer = true

  metadata {
    name      = "anchore"
    namespace = "anchore-engine"

    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
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
  }
}

resource "kubernetes_ingress" "portainer_ingress" {

  wait_for_load_balancer = true

  metadata {
    name      = "portainer"
    namespace = "portainer"

    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
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
  }
}

