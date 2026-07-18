# Reads the vpc module's outputs (vpc_id, public_subnet_ids, private_subnet_ids)
# straight from its S3 state file instead of re-deriving them via tag lookups.
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.vpc_state_bucket
    key    = var.vpc_state_key
    region = var.vpc_state_region
  }
}

# Latest Amazon Linux 2023 AMI (x86_64) owned by Amazon.
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
