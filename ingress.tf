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

      host = "jenkins.riva-cicd-0044.local"

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

      host = "spinnaker.riva-cicd-0044.local"

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

      host = "sonarqube.riva-cicd-0044.local"

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

      host = "grafana.riva-cicd-0044.local"

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

      host = "anchore.riva-cicd-0044.local"

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

