output "rds_endpoint" {

  value = aws_db_instance.postgres.endpoint

}


output "efs_id" {

  value = aws_efs_file_system.data.id

}

output "loadbalancer" {

  value = aws_eks_pod_identity_association.aws_lbc.role_arn
  
}