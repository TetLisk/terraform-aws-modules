terraform {
  required_version = "~> 1.3.9"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.18.0"
      configuration_aliases = [aws.us-east-1]
    }
  }
}
