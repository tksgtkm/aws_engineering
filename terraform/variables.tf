variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "AWS CLIプロファイル"
  type        = string
  default     = "dbt-pipeline"
}

variable "project_name" {
  description = "AWSリソース名のプレフィックス"
  type        = string
  default     = "dbt-pipeline"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,30}[a-z0-9]$", var.project_name))
    error_message = "英小文字で始まり、英数字とハイフンからなる4～32文字にしてください。"
  }
}

variable "allowed_cidr_ip" {
  description = "Redshiftへの接続を許可するグローバルIPv4アドレス(/32)"
  type        = string

  validation {
    condition = (
      can(cidrhost(var.allowed_cidr_ip, 0)) && endswith(var.allowed_cidr_ip, "/32")
    )
    error_message = "有効なIPv4 CIDRを/32で指定してください 例：203.0.113.10/32"
  }
}