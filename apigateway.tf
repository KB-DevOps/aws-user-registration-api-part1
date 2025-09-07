#Configuring the API GATEWAY
resource "aws_api_gateway_rest_api" "application_api" {
  name        = "application-api"
  description = "API for serverless application"
}

# Resources
resource "aws_api_gateway_resource" "health" {
  rest_api_id = aws_api_gateway_rest_api.application_api.id
  parent_id   = aws_api_gateway_rest_api.application_api.root_resource_id
  path_part   = "health"
}

resource "aws_api_gateway_resource" "user" {
  rest_api_id = aws_api_gateway_rest_api.application_api.id
  parent_id   = aws_api_gateway_rest_api.application_api.root_resource_id
  path_part   = "user"
}

resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.application_api.id
  parent_id   = aws_api_gateway_rest_api.application_api.root_resource_id
  path_part   = "users"
}

# Methods and Integrations for /health
resource "aws_api_gateway_method" "health_get" {
  rest_api_id   = aws_api_gateway_rest_api.application_api.id
  resource_id   = aws_api_gateway_resource.health.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "health_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.application_api.id
  resource_id             = aws_api_gateway_resource.health.id
  http_method             = aws_api_gateway_method.health_get.http_method
  integration_http_method = "POST"  # Required for Lambda proxy
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_lambda.invoke_arn
}

# Methods and Integrations for /user (GET, PUT, POST, DELETE)
resource "aws_api_gateway_method" "user_get" {
  rest_api_id   = aws_api_gateway_rest_api.application_api.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "user_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.application_api.id
  resource_id             = aws_api_gateway_resource.user.id
  http_method             = aws_api_gateway_method.user_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_lambda.invoke_arn
}

resource "aws_api_gateway_method" "user_put" {
  rest_api_id   = aws_api_gateway_rest_api.application_api.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "user_put_integration" {
  rest_api_id             = aws_api_gateway_rest_api.application_api.id
  resource_id             = aws_api_gateway_resource.user.id
  http_method             = aws_api_gateway_method.user_put.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_lambda.invoke_arn
}

resource "aws_api_gateway_method" "user_post" {
  rest_api_id   = aws_api_gateway_rest_api.application_api.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "user_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.application_api.id
  resource_id             = aws_api_gateway_resource.user.id
  http_method             = aws_api_gateway_method.user_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_lambda.invoke_arn
}

resource "aws_api_gateway_method" "user_delete" {
  rest_api_id   = aws_api_gateway_rest_api.application_api.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "user_delete_integration" {
  rest_api_id             = aws_api_gateway_rest_api.application_api.id
  resource_id             = aws_api_gateway_resource.user.id
  http_method             = aws_api_gateway_method.user_delete.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_lambda.invoke_arn
}

# Methods and Integrations for /users (GET)
resource "aws_api_gateway_method" "users_get" {
  rest_api_id   = aws_api_gateway_rest_api.application_api.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "users_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.application_api.id
  resource_id             = aws_api_gateway_resource.users.id
  http_method             = aws_api_gateway_method.users_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_lambda.invoke_arn
}

# CORS for /user (OPTIONS method)
resource "aws_api_gateway_method" "user_options" {
  rest_api_id   = aws_api_gateway_rest_api.application_api.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "user_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.application_api.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.user_options.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "user_options_response" {
  rest_api_id = aws_api_gateway_rest_api.application_api.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.user_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "user_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.application_api.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.user_options.http_method
  status_code = aws_api_gateway_method_response.user_options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,POST,PUT,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [aws_api_gateway_method_response.user_options_response]
}

# CORS for /users (OPTIONS method) - Similar to /user
resource "aws_api_gateway_method" "users_options" {
  rest_api_id   = aws_api_gateway_rest_api.application_api.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "users_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.application_api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.users_options.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "users_options_response" {
  rest_api_id = aws_api_gateway_rest_api.application_api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.users_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "users_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.application_api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.users_options.http_method
  status_code = aws_api_gateway_method_response.users_options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [aws_api_gateway_method_response.users_options_response]
}

# Optional: CORS for /health (for completeness, though not specified)
# Repeat the pattern above if needed, adjusting methods to "'GET,OPTIONS'"

# Gateway Response for DEFAULT 5XX (to include CORS headers)
resource "aws_api_gateway_gateway_response" "default_5xx" {
  rest_api_id   = aws_api_gateway_rest_api.application_api.id
  response_type = "DEFAULT_5XX"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin" = "'*'"
  }
}

# Lambda Permission (allows API Gateway to invoke Lambda)
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.serverless_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.application_api.execution_arn}/*/*/*"
}

# Deployment (depends on all methods/integrations)
resource "aws_api_gateway_deployment" "register_deployment" {
  rest_api_id = aws_api_gateway_rest_api.application_api.id

  depends_on = [
    aws_api_gateway_integration.health_get_integration,
    aws_api_gateway_integration.user_get_integration,
    aws_api_gateway_integration.user_put_integration,
    aws_api_gateway_integration.user_post_integration,
    aws_api_gateway_integration.user_delete_integration,
    aws_api_gateway_integration.users_get_integration,
    aws_api_gateway_integration.user_options_integration,
    aws_api_gateway_integration.users_options_integration,
    # Add health_options if enabled
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Stage
resource "aws_api_gateway_stage" "register_stage" {
  deployment_id = aws_api_gateway_deployment.register_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.application_api.id
  stage_name    = "register"
}

# Output the Invoke URL
output "api_invoke_url" {
  value = "${aws_api_gateway_stage.register_stage.invoke_url}"
  description = "The root URL for the API (e.g., https://<api-id>.execute-api.<region>.amazonaws.com/register)"
}