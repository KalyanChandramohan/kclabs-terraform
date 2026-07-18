module "ec2_instance" {
  source = "../../modules/ec2"

  vpc_state_bucket = var.vpc_state_bucket
  vpc_state_key    = var.vpc_state_key
  vpc_state_region = var.vpc_state_region
  instance_type    = var.instance_type
  key_name         = var.key_name
  env_name         = var.env_name

}
