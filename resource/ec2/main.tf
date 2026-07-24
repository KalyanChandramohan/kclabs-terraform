# Key pair NAME sourced from Vault. Only the (non-sensitive) key_name field
# lives here; the private key is stored under a separate path so it never
# enters Terraform state. See secret/ssh/<name> for the private key.
data "vault_kv_secret_v2" "ec2_key" {
  mount = "secret"
  name  = var.vault_key_secret_path
}

module "ec2_instance" {
  source = "../../modules/ec2"

  vpc_state_bucket = var.vpc_state_bucket
  vpc_state_key    = var.vpc_state_key
  vpc_state_region = var.vpc_state_region
  instance_type    = var.instance_type
  key_name         = data.vault_kv_secret_v2.ec2_key.data["key_name"]
  env_name         = var.env_name

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<html><body><h1>Hello from ${var.env_name}!</h1></body></html>" > /var/www/html/index.html
              EOF

}
