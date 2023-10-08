resource "aws_api_gateway_rest_api" "batch8_chinmayabiswal_apigw" {
  name        = "batch8_chinmayabiswal_apigw"
  description = "batch8_chinmayabiswal API Gateway for triggering Lambda"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Provide access to any resouce path, any stage, any method
resource "aws_lambda_permission" "batch8_chinmayabiswal_apigw" {
  statement_id  = "batch8_chinmayabiswal_AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.batch8_chinmayabiswal_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw.execution_arn}/*/*"
}

# Activate proxy, and match any request path
resource "aws_api_gateway_resource" "batch8_chinmayabiswal_proxy" {
  rest_api_id = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw.id
  parent_id   = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw.root_resource_id
  path_part   = "{proxy+}"
}

# Any http request method is accepted
resource "aws_api_gateway_method" "batch8_chinmayabiswal_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw.id
  resource_id   = aws_api_gateway_resource.batch8_chinmayabiswal_proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Bring together API GW and Lambda
resource "aws_api_gateway_integration" "batch8_chinmayabiswal_lambda" {
  rest_api_id = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw.id
  resource_id = aws_api_gateway_method.batch8_chinmayabiswal_proxy.resource_id
  http_method = aws_api_gateway_method.batch8_chinmayabiswal_proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.batch8_chinmayabiswal_lambda.invoke_arn
}

# Root resource management because roots not handled
resource "aws_api_gateway_method" "batch8_chinmayabiswal_proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw.id
  resource_id   = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "batch8_chinmayabiswal_lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw.id
  resource_id = aws_api_gateway_method.batch8_chinmayabiswal_proxy_root.resource_id
  http_method = aws_api_gateway_method.batch8_chinmayabiswal_proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.batch8_chinmayabiswal_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "batch8_chinmayabiswal_apigw_deployment" {
  depends_on = [
    "aws_api_gateway_integration.batch8_chinmayabiswal_lambda",
    "aws_api_gateway_integration.batch8_chinmayabiswal_lambda_root",
  ]

  rest_api_id = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw.id
  stage_name  = "dev"
}
