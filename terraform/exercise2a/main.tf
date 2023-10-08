data "aws_iam_policy_document" "batch8_chinmayabiswal_assume_role_2a" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "batch8_chinmayabiswal_iam_for_lambda_2a" {
  name               = "batch8_chinmayabiswal_iam_for_lambda_2a"
  assume_role_policy = data.aws_iam_policy_document.batch8_chinmayabiswal_assume_role_2a.json
}

data "archive_file" "batch8_chinmayabiswal_lambda_2a" {
  type        = "zip"
  source_file = "index.mjs"
  output_path = "index_payload.zip"
}

data "aws_iam_policy_document" "batch8_chinmayabiswal_cloudwatch_policy_2a" {
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

resource "aws_iam_policy" "batch8_chinmayabiswal_cloudwatch_policy_2a" {
  name        = "batch8_chinmayabiswal_cloudwatch_policy_2a"
  description = "Policy for CloudWatch Logs"
  policy      = data.aws_iam_policy_document.batch8_chinmayabiswal_cloudwatch_policy_2a.json
}

data "aws_iam_policy_document" "batch8_chinmayabiswal_sqs_policy_2a" {
  statement {
    effect = "Allow"
    actions = [
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:ReceiveMessage"
    ]
    resources = ["arn:aws:sqs:*"]
  }
}

resource "aws_iam_policy" "batch8_chinmayabiswal_sqs_policy_2a" {
  name        = "batch8_chinmayabiswal_sqs_policy_2a"
  description = "Policy for SQS"
  policy      = data.aws_iam_policy_document.batch8_chinmayabiswal_sqs_policy_2a.json
}

resource "aws_iam_role_policy_attachment" "batch8_chinmayabiswal_cloudwatch_policy_attachment_2a" {
  role       = aws_iam_role.batch8_chinmayabiswal_iam_for_lambda_2a.name
  policy_arn = aws_iam_policy.batch8_chinmayabiswal_cloudwatch_policy_2a.arn
}

resource "aws_iam_role_policy_attachment" "batch8_chinmayabiswal_sqs_policy_attachment_2a" {
  role       = aws_iam_role.batch8_chinmayabiswal_iam_for_lambda_2a.name
  policy_arn = aws_iam_policy.batch8_chinmayabiswal_sqs_policy_2a.arn
}

resource "aws_lambda_function" "batch8_chinmayabiswal_lambda_2a" {
  filename      = "index_payload.zip"
  function_name = "batch8_chinmayabiswal_exercise_2a"
  handler       = "index.handler"
  role          = aws_iam_role.batch8_chinmayabiswal_iam_for_lambda_2a.arn

  source_code_hash = data.archive_file.batch8_chinmayabiswal_lambda_2a.output_base64sha256

  runtime = "nodejs18.x"

  environment {
    variables = {
      name = "chinmaya_biswal"
    }
  }
  tags = {
    Name        = "batch8_chinmayabiswal_exercise_2a"
    Environment = "Dev"
  }
}

