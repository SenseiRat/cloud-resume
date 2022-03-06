resource "aws_apigatewayv2_api" "resume-api" {
    name = "resume-api"
    protocol_type = "HTTP"

    cors_configuration {
      allow_methods = ["GET"]
      # TODO: change this to properly using a variable
      allow_origins = ["https://starnes.cloud"]
    }
}

resource "aws_apigatewayv2_integration" "resume-api-integration" {
    api_id = aws_apigatewayv2_api.resume-api.id
    integration_type = "AWS"

    connection_type = "INTERNET"
    content_handling_strategy = "CONVERT_TO_TEXT"
    integration_uri = aws_lambda_function.resume-api-lambda.invoke_arn
    passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "resume-api-route" {
    api_id = aws_apigatewayv2_api.resume-api.id
    route_key = "GET /resume-api"
    authorization_type = "AWS_IAM"
}
