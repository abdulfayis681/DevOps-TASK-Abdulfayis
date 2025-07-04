output "endpoint" {
  value = aws_eks_cluster.DevOps-Task.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.DevOps-Task.certificate_authority[0].data
}
output "cluster_id" {
  value = aws_eks_cluster.DevOps-Task.id
}
output "cluster_endpoint" {
  value = aws_eks_cluster.DevOps-Task.endpoint
}
output "cluster_name" {
  value = aws_eks_cluster.DevOps-Task.name
}