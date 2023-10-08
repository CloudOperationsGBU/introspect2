data "aws_iam_policy_document" "batch8_chinmayabiswal_assume_role_2b" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "batch8_chinmayabiswal_iam_for_lambda_2b" {
  name               = "batch8_chinmayabiswal_iam_for_lambda_2b"
  assume_role_policy = data.aws_iam_policy_document.batch8_chinmayabiswal_assume_role_2b.json
}

data "archive_file" "batch8_chinmayabiswal_lambda_2b" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

data "aws_iam_policy_document" "batch8_chinmayabiswal_cloudwatch_policy_2b" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "batch8_chinmayabiswal_cloudwatch_policy_2b" {
  name        = "batch8_chinmayabiswal_cloudwatch_policy_2b"
  description = "Policy for CloudWatch Logs"
  policy      = data.aws_iam_policy_document.batch8_chinmayabiswal_cloudwatch_policy_2b.json
}

resource "aws_iam_role_policy_attachment" "batch8_chinmayabiswal_cloudwatch_policy_attachment_2b" {
  role       = aws_iam_role.batch8_chinmayabiswal_iam_for_lambda_2b.name
  policy_arn = aws_iam_policy.batch8_chinmayabiswal_cloudwatch_policy_2b.arn
}


data "aws_iam_policy_document" "batch8_chinmayabiswal_ddb_policy_2b" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:UpdateItem"
    ]
    resources = ["arn:aws:dynamodb:eu-west-1:569445711959:table/*"]
  }
}

resource "aws_iam_policy" "batch8_chinmayabiswal_ddb_policy_2b" {
  name        = "batch8_chinmayabiswal_ddb_policy_2b"
  description = "Policy for DynamoDB"
  policy      = data.aws_iam_policy_document.batch8_chinmayabiswal_ddb_policy_2b.json
}



resource "aws_iam_role_policy_attachment" "batch8_chinmayabiswal_ddb_policy_attachment_2b" {
  role       = aws_iam_role.batch8_chinmayabiswal_iam_for_lambda_2b.name
  policy_arn = aws_iam_policy.batch8_chinmayabiswal_ddb_policy_2b.arn
}

data "aws_iam_policy_document" "batch8_chinmayabiswal_ddb_policy_2b_2" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:UpdateItem"
    ]
    resources = ["arn:aws:dynamodb:us-east-2:569445711959:table/*"]
  }
}

resource "aws_iam_policy" "batch8_chinmayabiswal_ddb_policy_2b_2" {
  name        = "batch8_chinmayabiswal_ddb_policy_2b_2"
  description = "Policy for DynamoDB"
  policy      = data.aws_iam_policy_document.batch8_chinmayabiswal_ddb_policy_2b_2.json
}

resource "aws_iam_role_policy_attachment" "batch8_chinmayabiswal_ddb_policy_attachment_2b_2" {
  role       = aws_iam_role.batch8_chinmayabiswal_iam_for_lambda_2b.name
  policy_arn = aws_iam_policy.batch8_chinmayabiswal_ddb_policy_2b_2.arn
}

resource "aws_lambda_function" "batch8_chinmayabiswal_lambda_2b" {
  filename      = "lambda_function_payload.zip"
  handler       = "lambda_function.lambda_handler"
  function_name = "batch8_chinmayabiswal_exercise_2b"
  role          = aws_iam_role.batch8_chinmayabiswal_iam_for_lambda_2b.arn

  source_code_hash = data.archive_file.batch8_chinmayabiswal_lambda_2b.output_base64sha256

  runtime = "python3.10"

  environment {
    variables = {
      name = "chinmaya_biswal"
    }
  }
  tags = {
    Name        = "batch8_chinmayabiswal_exercise_2b"
    Environment = "Dev"
  }
}
