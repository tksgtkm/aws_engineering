resource "aws_redshiftserverless_namespace" "main" {
  namespace_name = "${var.project_name}-ns"
  db_name        = "dev"

  # 管理者パスワードをAWS Secrets Managerに管理させる
  manage_admin_password = true

  iam_roles = [
    aws_iam_role.redshift_s3.arn
  ]

  default_iam_role_arn = aws_iam_role.redshift_s3.arn

  tags = {
    Name = "${var.project_name}-ns"
  }
}

resource "aws_redshiftserverless_workgroup" "main" {
  workgroup_name = "${var.project_name}-wg"
  namespace_name = aws_redshiftserverless_namespace.main.namespace_name

  base_capacity = 4
  max_capacity  = 4

  subnet_ids = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  security_group_ids = [
    aws_security_group.redshift.id
  ]

  publicly_accessible = true

  tags = {
    Name = "${var.project_name}-wg"
  }
}