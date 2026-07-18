variable "region" {
  description = "The AWS region to create resources in."
  type        = string

}

variable "instance_type" {
  description = "The type of instance to create."
  type        = string

}

variable "key_name" {
  description = "The name of the key pair to use for the instance."
  type        = string

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
