variable "name" {
  description = "Bucket name"
  type        = string
}

variable "force_destroy" {
  description = "Allow force destroy of bucket (dev only)"
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "KMS key for SSE-KMS; null = AES256"
  type        = string
  default     = null
}
