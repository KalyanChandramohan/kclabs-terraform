variable "region" {
  description = "The AWS region to create resources in."
  type        = string

}

variable "instance_type" {
  description = "The type of instance to create."
  type        = string

}

variable "vault_address" {
  description = "Address of the Vault server holding the EC2 key pair metadata."
  type        = string
}

variable "vault_key_secret_path" {
  description = "KV v2 secret path (relative to the mount) holding the key_name field."
  type        = string
  default     = "ec2_key"
}
variable "env_name" {
  description = "The name of the environment."
  type        = string
}

variable "vpc_state_bucket" {
  description = "The S3 bucket where the VPC module's remote state is stored."
  type        = string

}

variable "vpc_state_key" {
  description = "The key for the VPC module's remote state file in the S3 bucket."
  type        = string

}

variable "vpc_state_region" {
  description = "The AWS region where the S3 bucket for the VPC module's remote state is located."
  type        = string

}
