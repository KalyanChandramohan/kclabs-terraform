module "aws_vpc" {
  source = "../../modules/vpc"

  cidr_block          = var.cidr_block
  vpc_name            = var.vpc_name
  env_name            = var.env_name
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zones  = var.availability_zones

  flow_log_retention_in_days = var.flow_log_retention_in_days
  flow_log_traffic_type      = var.flow_log_traffic_type
}
