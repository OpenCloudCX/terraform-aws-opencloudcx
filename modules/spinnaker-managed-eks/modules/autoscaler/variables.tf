variable "enabled" {
  description = "A conditional indicator to enable cluster-autoscale"
  type        = bool
  default     = false
}

### helm
variable "helm" {
  description = "The helm release configuration"
  type        = map(any)
  default = {
    name            = "eks-as"
    repository      = "https://kubernetes.github.io/autoscaler"
    chart           = "cluster-autoscaler-chart"
    namespace       = "kube-system"
    serviceaccount  = "cluster-autoscaler"
    cleanup_on_fail = true
  }
}

### security/policy
variable "oidc" {
  description = "The Open ID Connect properties"
  type        = map(any)
}

### description
variable "cluster_name" {
  description = "The kubernetes cluster name"
  type        = string
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
