variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string


}


variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string


}

variable "vpc_name" {
  description = "Name tag for the VPC."
  type        = string

}

variable "env_name" {
  description = "Environment name used in resource tags."
  type        = string


}

variable "public_subnet_cidr" {
  description = "Base CIDR block for public subnets (split per AZ via cidrsubnet)."
  type        = list(string)

}

variable "private_subnet_cidr" {
  description = "Base CIDR block for private subnets (split per AZ via cidrsubnet)."
  type        = list(string)

}

variable "availability_zones" {
  description = "Availability zones to spread subnets across, one per count.index."
  type        = list(string)
}
