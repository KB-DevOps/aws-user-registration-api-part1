#Create a DynamoDB table
resource "aws_dynamodb_table" "userserverless" {
  name           = "userserverless"  # Change if needed, but update any referencing Lambda functions accordingly
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"  # String type for the partition key
  }
}



