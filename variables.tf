### network
variable "region" {
  description = "The aws region to deploy the service into"
  type        = string
  default     = "us-east-1"
}

variable "azs" {
  description = "A list of availability zones for the vpc"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "cidr" {
  description = "The vpc CIDR (e.g. 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
}

### kubernetes cluster
variable "kubernetes_version" {
  description = "The target version of kubernetes"
  type        = string
  default     = "1.21"
}

variable "kubernetes_node_groups" {
  description = "Node group definitions"
  type        = map(any)
  default = {
    "default" = {
      "disk_size"     = "20"
      "instance_type" = "m5.xlarge"
      "max_size"      = "3"
      "min_size"      = "1"
      "desired_size"  = "1"
    }
  }
}

#  [CAUTION] Changing the snapshot ID. will force a new resource.

### rdb cluster (aurora-mysql)
variable "aurora_cluster" {
  description = "RDS Aurora for mysql cluster definition"
  type        = map(any)
  default = {
    "node_size"         = "1"
    "node_type"         = "db.t3.medium"
    "version"           = "5.7.12"
    "port"              = "3306"
    "master_user"       = "yourid"
    "database"          = "yourdb"
    "snapshot_id"       = ""
    "backup_retention"  = "5"
    "apply_immediately" = "false"
  }
}

### security
variable "assume_role_arn" {
  description = "The list of ARNs of target AWS role that you want to manage with spinnaker. e.g.,) arn:aws:iam::12345678987:role/spinnakerManaged"
  type        = list(string)
  default     = []
}

### dns
variable "dns_zone" {
  description = "The hosted zone name for internal dns, e.g., app.internal"
  type        = string
  default     = "spinnaker.internal"
}

### helm
variable "helm_repo" {
  description = "A repository url of helm chart to deploy a spinnaker"
  type        = string
  default     = "https://opencloudcx.github.io/spinnaker-helm"
}

variable "helm_repo_grafana" {
  description = "A repository url of helm chart to deploy grafana"
  type        = string
  default     = "https://grafana.github.io/helm-charts"
}

variable "helm_repo_grafana_version" {
  description = "Version of grafana helm chart to deploy"
  type        = string
  default     = "6.17.5"
}

###################################
## Code server helm variables

variable "helm_repo_code_server" {
  description = "A repository url of helm chart to deploy code server"
  type        = string
  default     = "https://helm.kodelib.com"
}

variable "helm_code_server_version" {
  description = "Helm chart version for code server"
  type        = string
  default     = "0.3.11"
}

## 
###################################

###################################
## k8s Dashboard variables

variable "helm_repo_k8s_dashboard" {
  description = "A repository url of helm chart to deploy k8s dashboard"
  type        = string
  default     = "https://kubernetes.github.io/dashboard/"
}

variable "helm_k8s_dashboard_version" {
  description = "Helm chart version for k8s_dashboard"
  type        = string
  default     = "5.0.3"
}

## 
###################################

###################################
## Portainer variables

variable "helm_repo_portainer" {
  description = "A repository url of helm chart to deploy Portainer"
  type        = string
  default     = "https://portainer.github.io/k8s/"
  # default     = "https://opencloudcx.github.io/portainer-helm"
}

variable "helm_portainer_version" {
  description = "Helm chart version for portainer"
  type        = string
  default     = "1.0.16"
}

## 
###################################


variable "helm_repo_influxdb" {
  description = "A repository url of helm chart to deploy InfluxDB"
  type        = string
  default     = "https://charts.bitnami.com/bitnami"
}

###################################
## Jenkins variables

variable "helm_jenkins" {
  description = "A repository url of the helm chart to deploy jenkins."
  type        = string
  default     = "https://charts.jenkins.io"
  # default     = "https://charts.bitnami.com/bitnami"
  # default     = "https://opencloudcx.github.io/jenkins-helm/"
}

variable "helm_jenkins_version" {
  description = "Helm chart version for jenkins"
  type        = string
  default     = "3.5.14"
}

variable "jenkins_secret" {
  description = "Jenkins admin password"
  type        = string
}

## 
###################################

variable "helm_sonarqube" {
  description = "A repository url of the helm chart to deploy sonarqube."
  type        = string
  # default     = "https://oteemo.github.io/charts"
  default = "https://opencloudcx.github.io/sonarqube-helm/"
}

variable "helm_anchore_engine" {
  description = "A repository url of the helm chart to deploy anchore."
  type        = string
  # default     = "https://oteemo.github.io/charts"
  default = "https://opencloudcx.github.io/anchore-helm/"
}

variable "helm_timeout" {
  description = "Timeout value to wailt for helm chat deployment"
  type        = number
  default     = 600
}

variable "helm_chart_version" {
  description = "The version of helm chart to deploy spinnaker"
  type        = string
  default     = "2.2.3"
}

variable "helm_chart_values" {
  description = "A list of variables of helm chart to configure the spinnaker deployment"
  type        = list(any)
  default     = []
}

### description
variable "name" {
  description = "The logical name of the module instance"
  type        = string
  default     = "spinnaker"
}

variable "stack" {
  description = "Text used to identify stack of infrastructure components"
  type        = string
  default     = ""
}

variable "detail" {
  description = "The extra description of module instance"
  type        = string
  default     = ""
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}

variable "sonarqube_secret" {
  description = "Sonarqube admin password"
  type        = string
}

variable "ingress_controller" {
  description = "URL for Ingress Controller helm chart"
  type        = string
  default     = "https://kubernetes.github.io/ingress-nginx"
}

variable "helm_cert_manager" {
  description = "URL for cert-manager helm chart repository"
  type        = string
  default     = "https://charts.jetstack.io"
}

variable "helm_selenium" {
  description = "URL for cert-manager helm chart repository"
  type        = string
  default     = "https://chart.testarchitect.com"
}

variable "helm_selenium_version" {
  description = "Version for selenium helm chart"
  type        = string
  default     = "1.2.4"
}

variable "helm_keycloak" {
  description = "URL for keycloak helm chart repository"
  type        = string
  default     = "https://charts.bitnami.com/bitnami"
}

variable "helm_keycloak_version" {
  description = "Version for keycloak helm chart"
  type        = string
  default     = "5.1.2"
}

variable "kubectl_version" {
  type    = string
  default = "1.22.1"
}

variable "dockerhub_url" {
  type    = string
  default = "https://index.docker.io/v1/"
}

### aws credential
variable "aws_account_id" {
  description = "The aws account id for the tf backend creation (e.g. 857026751867)"
}

# variable "kubernetes_secrets" {
#   description = "Kubernetes secrets to plant into ecosystem"
#   type        = map(any)
#   default     = {}
# }

variable "keycloak_admin_secret" {
  type = string
}

variable "keycloak_user_secret" {
  type = string
}

variable "code_server_secret" {
  type = string
}

variable "grafana_secret" {
  type = string
}