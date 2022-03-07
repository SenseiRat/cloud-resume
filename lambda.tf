data "aws_iam_policy_document" "resume-api-lambda-policy" {
  statement {
    sid    = "ResumeApiLambdaUpdate"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:PutItem"
    ]
    resources = [aws_dynamodb_table.resume-visit-counter.arn]
  }
  statement {
    sid    = "ResumeApiLambdaList"
    effect = "Allow"
    actions = [
      "dynamodb:ListTables"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "resume-api-lambda-policy" {
  name        = "resume-api-lambda"
  path        = "/"
  description = "IAM Policy for resume lambda"

  policy = data.aws_iam_policy_document.resume-api-lambda-policy.json
}

data "aws_iam_policy_document" "resume-api-lambda-assume" {
  statement {
    sid    = "ResumeApiLambdaAssumeRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      # TODO: Change this to be the terraform resource
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "resume-api-lambda-iam" {
  name = "resume-api-lambda"

  assume_role_policy  = data.aws_iam_policy_document.resume-api-lambda-assume.json
  managed_policy_arns = [aws_iam_policy.resume-api-lambda-policy.arn]
}

data "archive_file" "resume-api-lambda-zip" {
  type        = "zip"
  source_file = "${path.cwd}/resume-api.py"
  output_path = "${path.cwd}/resume-api.zip"
}

resource "aws_lambda_function" "resume-api-lambda" {
  filename         = data.archive_file.resume-api-lambda-zip.output_path
  function_name    = "resume-api"
  role             = aws_iam_role.resume-api-lambda-iam.arn
  source_code_hash = data.archive_file.resume-api-lambda-zip.output_base64sha256
  runtime          = "python3.9"
  handler          = "lambda_function.lambda_handler"
  timeout          = 60

}