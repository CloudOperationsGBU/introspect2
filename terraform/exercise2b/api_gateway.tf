resource "aws_api_gateway_rest_api" "batch8_chinmayabiswal_apigw_2b" {
  name        = "batch8_chinmayabiswal_apigw_2b"
  description = "batch8_chinmayabiswal API Gateway for triggering Lambda"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Provide access to any resouce path, any stage, any method
resource "aws_lambda_permission" "batch8_chinmayabiswal_apigw_2b" {
  statement_id  = "batch8_chinmayabiswal_AllowAPIGatewayInvoke_2b"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.batch8_chinmayabiswal_lambda_2b.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw_2b.execution_arn}/*/*"
}

# Activate proxy, and match any request path
resource "aws_api_gateway_resource" "batch8_chinmayabiswal_proxy_2b" {
  rest_api_id = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw_2b.id
  parent_id   = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw_2b.root_resource_id
  path_part   = "{proxy+}"
}

# Any http request method is accepted
resource "aws_api_gateway_method" "batch8_chinmayabiswal_proxy_2b" {
  rest_api_id   = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw_2b.id
  resource_id   = aws_api_gateway_resource.batch8_chinmayabiswal_proxy_2b.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Bring together API GW and Lambda
resource "aws_api_gateway_integration" "batch8_chinmayabiswal_lambda_2b" {
  rest_api_id = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw_2b.id
  resource_id = aws_api_gateway_method.batch8_chinmayabiswal_proxy_2b.resource_id
  http_method = aws_api_gateway_method.batch8_chinmayabiswal_proxy_2b.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.batch8_chinmayabiswal_lambda_2b.invoke_arn
}

# Root resource management because roots not handled
resource "aws_api_gateway_method" "batch8_chinmayabiswal_proxy_root_2b" {
  rest_api_id   = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw_2b.id
  resource_id   = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw_2b.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "batch8_chinmayabiswal_lambda_root_2b" {
  rest_api_id = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw_2b.id
  resource_id = aws_api_gateway_method.batch8_chinmayabiswal_proxy_root_2b.resource_id
  http_method = aws_api_gateway_method.batch8_chinmayabiswal_proxy_root_2b.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.batch8_chinmayabiswal_lambda_2b.invoke_arn
}

resource "aws_api_gateway_deployment" "batch8_chinmayabiswal_apigw_deployment_2b" {
  depends_on = [
    aws_api_gateway_integration.batch8_chinmayabiswal_lambda_2b,
    aws_api_gateway_integration.batch8_chinmayabiswal_lambda_root_2b,
  ]

  rest_api_id = aws_api_gateway_rest_api.batch8_chinmayabiswal_apigw_2b.id
  stage_name  = "dev"
}
