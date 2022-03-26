data "aws_iam_policy_document" "resume-lambda-policy" {
  statement {
    sid    = "ResumeLambdaUpdate"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:PutItem"
    ]
    resources = [aws_dynamodb_table.resume-visit-counter.arn]
  }
  
  statement {
    sid    = "ResumeLambdaList"
    effect = "Allow"
    actions = [
      "dynamodb:ListTables"
    ]
    resources = ["*"]
  }

  statement {
    sid = "ResumeLambdaS3"
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resource = [
      aws_s3_bucket.resume-log-bucket.arn
    ]
  }
}

resource "aws_iam_policy" "resume-lambda-policy" {
  name        = "resume-lambda"
  path        = "/"
  description = "IAM Policy for resume lambda"

  policy = data.aws_iam_policy_document.resume-lambda-policy.json
}

data "aws_iam_policy_document" "resume-lambda-assume" {
  statement {
    sid    = "ResumeLambdaAssumeRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "resume-lambda-iam" {
  name = "resume-lambda"

  assume_role_policy  = data.aws_iam_policy_document.resume-lambda-assume.json
  managed_policy_arns = [aws_iam_policy.resume-lambda-policy.arn]

  tags = var.common_tags
}

data "archive_file" "resume-lambda-zip" {
  type        = "zip"
  source_file = "${path.cwd}/resume-lambda.py"
  output_path = "${path.cwd}/resume-lambda.zip"
}

resource "aws_lambda_function" "resume-lambda" {
  filename         = data.archive_file.resume-lambda-zip.output_path
  function_name    = "resume-lambda"
  role             = aws_iam_role.resume-lambda-iam.arn
  source_code_hash = data.archive_file.resume-lambda-zip.output_base64sha256
  runtime          = "python3.9"
  handler          = "lambda_function.lambda_handler"
  timeout          = 60

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = "${aws_dynamodb_table.resume-visit-counter.name}"
      RESUME_LOG_BUCKET = "${aws_s3_bucket.resume-log-bucket.name}"
    }
  }

  tags = var.common_tags
}

resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = aws_s3_bucket.resume-logs-bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.resume-lambda.arn
    events = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_permission" "resume-s3-lambda-permission" {
  statement_id = "AllowS3Invoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.resume-lambda.function_name
  principal = "s3.amazonaws.com"
  source_arn = aws_s3_bucket.resume-log-bucket.arn
}