output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}


output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}
output "eks_kubeconfig_command" {
  description = "Command to update kubeconfig for EKS cluster access"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

output "ecr_staging_url" {
  value = module.ecr_staging.repository_url
}

output "ecr_staging_arn" {
  value = module.ecr_staging.repository_arn
}

output "ecr_prod_url" {
  value = module.ecr_prod.repository_url
}

output "ecr_prod_arn" {
  value = module.ecr_prod.repository_arn
}

