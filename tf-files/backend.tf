terraform {
  backend "s3" {
    bucket         = "placeholder"
    key            = "placeholder"
    region         = "eu-north-1"
    dynamodb_table = "terraform-state-lock-dynamo"
    encrypt        = true
  }
}
