output "aws_account_id" {
  description = "使用しているAWSアカウントID"
  value       = data.aws_caller_identity.current.account_id
}

output "redshift_workgroup_name" {
  description = "Redshift Serverless Workgroup名"
  value       = aws_redshiftserverless_workgroup.main.workgroup_name
}

output "redshift_namespace_name" {
  description = "Redshift Serverless Namespace名"
  value       = aws_redshiftserverless_namespace.main.namespace_name
}

output "redshift_endpoint" {
  description = "Redshift Serverlessエンドポイント"
  value       = aws_redshiftserverless_workgroup.main.endpoint[0].address
}

output "redshift_database_name" {
  description = "Redshiftデータベース名"
  value       = aws_redshiftserverless_namespace.main.db_name
}

output "redshift_admin_secret_arn" {
  description = "AWS管理のRedshift管理者Secret ARN"
  value       = aws_redshiftserverless_namespace.main.admin_password_secret_arn
}

output "redshift_s3_role_arn" {
  description = "RedshiftからS3を読み取るIAMロールARN"
  value       = aws_iam_role.redshift_s3.arn
}

output "landing_bucket_name" {
  description = "CSV配置用S3バケット名"
  value       = aws_s3_bucket.landing.bucket
}