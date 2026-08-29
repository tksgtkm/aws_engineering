resource "aws_s3_bucket" "landing" {
  bucket = "${var.project_name}-landing-${data.aws_caller_identity.current.account_id}"

  # 学習終了時、オブジェクトが残っていれば削除を失敗させる
  force_destroy = false

  tags = {
    Name = "${var.project_name}-landing"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "landing" {
  bucket = aws_s3_bucket.landing.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }

    blocked_encryption_types = ["SSE-C"]
  }
}

resource "aws_s3_bucket_public_access_block" "landing" {
  bucket = aws_s3_bucket.landing.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}