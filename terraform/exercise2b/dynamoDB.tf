resource "aws_dynamodb_table" "batch8_chinmayabiswal_table_2b" {
  name           = "batch8_chinmayabiswal_table_2b"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  attribute {
    name = "UserId"
    type = "S"
  }
  tags = {
    Name        = "batch8_chinmayabiswal_table_2b"
    Environment = "dev"
  }
}