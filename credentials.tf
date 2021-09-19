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

resource "kubernetes_secret" "dockerhub_secret" {
  metadata {
    name      = var.dockerhub_secret_name
    namespace = "jenkins"
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "https://index.docker.io/v1/" : {
      "auth": "${base64encode("${var.dockerhub_username}:${var.dockerhub_secret}")}"
    }
  }
}
DOCKER
  }

  type = "kubernetes.io/dockerconfigjson"

  depends_on = [
    helm_release.ingress-controller,
  ]
}

/*

  resource "kubernetes_secret" "example" {
    metadata {
      name = "basic-auth"
    }

    data = {
      username = "admin"
      password = "P4ssw0rd"
    }

    type = "kubernetes.io/basic-auth"
  }

*/

/*
    # Create a ServiceAccount named `jenkins-robot` in a given namespace.
    $ kubectl -n <namespace> create serviceaccount jenkins-robot

    # The next line gives `jenkins-robot` administator permissions for this namespace.
    # * You can make it an admin over all namespaces by creating a `ClusterRoleBinding` instead of a `RoleBinding`.
    # * You can also give it different permissions by binding it to a different `(Cluster)Role`.
    $ kubectl -n <namespace> create rolebinding jenkins-robot-binding --clusterrole=cluster-admin --serviceaccount=<namespace>:jenkins-robot

    # Get the name of the token that was automatically generated for the ServiceAccount `jenkins-robot`.
    $ kubectl -n <namespace> get serviceaccount jenkins-robot -o go-template --template='{{range .secrets}}{{.name}}{{"\n"}}{{end}}'
    jenkins-robot-token-d6d8z

    # Retrieve the token and decode it using base64.
    $ kubectl -n <namespace> get secrets jenkins-robot-token-d6d8z -o go-template --template '{{index .data "token"}}' | base64 -d
    eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2V[...]
*/
