resource "aws_iam_role" "redshift_s3" {
  name = "${var.project_name}-redshift-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = "sts.AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-redshift-s3-role"
  }
}

resource "aws_iam_role_policy" "redshift_s3_read" {
  name = "ReadFromLandingBucket"
  role = aws_iam_role.redshift_s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListLandingBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.landing.arn
      },
      {
        Sid    = "ReadLandingObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.landing.arn}/*"
      }
    ]
  })
}