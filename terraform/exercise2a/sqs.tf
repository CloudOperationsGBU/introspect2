resource "aws_sqs_queue" "batch8_chinmayabiswal_queue" {
  name = "batch8_chinmayabiswal_queue"
}

resource "aws_lambda_event_source_mapping" "batch8_chinmayabiswal_sqs_trigger" {
  event_source_arn  = aws_sqs_queue.batch8_chinmayabiswal_queue.arn
  function_name     = aws_lambda_function.batch8_chinmayabiswal_lambda_2a.function_name
  batch_size        = 1
  enabled           = true
}