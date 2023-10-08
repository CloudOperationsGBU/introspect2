data "aws_iam_policy_document" "batch8_chinmayabiswal_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "batch8_chinmayabiswal_iam_for_lambda" {
  name               = "batch8_chinmayabiswal_iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.batch8_chinmayabiswal_assume_role.json
}

data "archive_file" "batch8_chinmayabiswal_lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

data "aws_iam_policy_document" "batch8_chinmayabiswal_cloudwatch_policy" {
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

resource "aws_iam_policy" "batch8_chinmayabiswal_cloudwatch_policy" {
  name        = "batch8_chinmayabiswal_cloudwatch_policy"
  description = "Policy for CloudWatch Logs"
  policy      = data.aws_iam_policy_document.batch8_chinmayabiswal_cloudwatch_policy.json
}

resource "aws_iam_role_policy_attachment" "batch8_chinmayabiswal_cloudwatch_policy_attachment" {
  role       = aws_iam_role.batch8_chinmayabiswal_iam_for_lambda.name
  policy_arn = aws_iam_policy.batch8_chinmayabiswal_cloudwatch_policy.arn
}

resource "aws_lambda_function" "batch8_chinmayabiswal_lambda" {
  filename      = "lambda_function_payload.zip"
  handler       = "lambda_function.awsum"
  function_name = "batch8_chinmayabiswal_exercise_1"
  role          = aws_iam_role.batch8_chinmayabiswal_iam_for_lambda.arn

  source_code_hash = data.archive_file.batch8_chinmayabiswal_lambda.output_base64sha256

  runtime = "python3.10"

  environment {
    variables = {
      name = "chinmaya_biswal"
    }
  }
  tags = {
    Name        = "batch8_chinmayabiswal_exercise"
    Environment = "Dev"
  }
}

