resource "aws_instance" "public_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
  key_name               = var.key_name
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.bastion_sg]

  tags = {
    Name = "${var.env_name}-public-instance"
    Env  = var.env_name
  }

}
