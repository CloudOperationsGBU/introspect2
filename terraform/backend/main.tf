resource "aws_s3_bucket" "example" {
  bucket = "batch8_chinmayabiswal_exercise_s3"

  tags = {
    Name        = "batch8_chinmayabiswal_exercise"
    Environment = "Dev"
  }
}