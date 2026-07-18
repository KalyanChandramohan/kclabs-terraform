variable "vpc_state_bucket" {
  description = "S3 bucket holding the vpc module's remote state."
  type        = string
}

variable "vpc_state_key" {
  description = "State file key for the vpc module."
  type        = string
}

variable "vpc_state_region" {
  description = "Region of the S3 bucket holding the vpc module's remote state."
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
  description = "Environment name used in resource tags."
  type        = string

}
