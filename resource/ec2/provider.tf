provider "aws" {
  region = var.region

}

provider "vault" {
  address = var.vault_address
  # Auth via the VAULT_TOKEN environment variable — do not hardcode the token.
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}
