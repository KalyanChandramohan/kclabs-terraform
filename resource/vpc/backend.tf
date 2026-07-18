terraform {

  required_version = ">= 1.10.0"

  backend "s3" {
    bucket       = "terraform-associate-tfstate-kalyanchandramohan"
    key          = "vpc/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true

  }
}
