# You first have to create a s3 bucket and a DynamoDB table (in this case, "s3-state-lock" and make sure to add "LockID" in the partition key) in your AWS account. 

terraform {
  backend "s3" {
    bucket = "jrampin-terraform-aws"
    key    = "remote-terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "s3-state-lock"
  }
}
