resource "kubernetes_ingress" "jenkins_ingress" {

  wait_for_load_balancer = true

  metadata {
    name = "jenkins"
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
    name = "spinnaker"
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
            service_name = "spinnaker"
            service_port = 9000
          }
        }
      }
    }
  }
}
