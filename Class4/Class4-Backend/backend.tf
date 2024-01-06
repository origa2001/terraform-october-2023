terraform {
  backend "s3" {
    dynamodb_table = "lock-state"
    bucket = "origa2001"
    key    = "ohio/terraform.tfstate"
    region = "us-east-2"
  }
}
