terraform {
  backend "s3" {
    bucket         = "placeholder"
    key            = "placeholder"
    region         = "eu-north-1"
    dynamodb_table = "terraform-state-lock-dynamo"
    encrypt        = true
  }
}

resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name           = var.aws_dynamo_table_name
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}