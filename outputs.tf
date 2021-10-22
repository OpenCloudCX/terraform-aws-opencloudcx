# output variables 

output "name" {
  value       = local.name
  description = "The name of eks cluster to run spinnaker pods"
}

output "endpoint" {
  value       = aws_eks_cluster.eks.endpoint
  description = "The endpoint of eks cluster"
}

output "role_arn" {
  value       = aws_iam_role.ng.arn
  description = "The generated role ARN of eks node group"
}

output "bucket_name" {
  value       = aws_s3_bucket.storage.id
  description = "The name of s3 bucket to store pipelines and applications of spinnaker"
}

output "artifact_repository" {
  value       = aws_s3_bucket.artifact.id
  description = "The S3 path for artifact repository/storage"
}

output "artifact_write_policy_arn" {
  value       = aws_iam_policy.artifact-write.arn
  description = "The policy ARN to allow access to artifact bucket"
}

output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The ID of new VPC"
}

output "public_subnets" {
  value       = aws_subnet.public.*.id
  description = "The ID list of generated public subnets"
}

output "private_subnets" {
  value       = aws_subnet.private.*.id
  description = "The ID list of generated private subnets"
}

output "hosted_zone_id" {
  value       = data.aws_route53_zone.vpc.zone_id
  description = "The hosted zone ID of internal domain in Route 53"
}

output "db_endpoint" {
  value       = aws_route53_record.db.*.name
  description = "The endpoint of aurora mysql cluster"
}

data "template_file" "kubeconfig" {
  template = <<EOT
bash -e ${path.module}/script/update-kubeconfig.sh -r ${data.aws_region.current.name} -n ${aws_eks_cluster.eks.name}
EOT
}

output "kubeconfig" {
  value       = data.template_file.kubeconfig.rendered
  description = "Bash script to update kubeconfig file"
}

output "ingress_status" {
  value = data.kubernetes_service.ingress_nginx.status
}

output "ingress_hostname" {
  value = data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname

  depends_on = [
    helm_release.ingress-controller,
  ]
}

output "ingress_hostname_secure" {
  value = data.kubernetes_service.ingress_nginx_secure.status.0.load_balancer.0.ingress.0.hostname

  depends_on = [
    helm_release.ingress-controller,
  ]
}
