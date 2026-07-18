module "aws_vpc" {
  source = "../../modules/vpc"

  region              = var.region
  cidr_block          = var.cidr_block
  vpc_name            = var.vpc_name
  env_name            = var.env_name
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zones  = var.availability_zones
}
