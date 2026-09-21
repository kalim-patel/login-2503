# AWS Access Key ID
variable aws_access_key {
  description = "Please Input AWS Access Key ID"
}

# AWS Secret Key ID
variable aws_secret_key {
  description = "Please Input AWS Secret Key ID"
}

provider "aws" {
  region     = "eu-north-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
