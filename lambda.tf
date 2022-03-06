data "aws_iam_policy_document" "resume-api-lambda-policy" {
    statement {
        sid = "resume-api-lambda-update"
        effect = "Allow"
        actions = [
            "dynamodb:GetItem",
            "dynamodb:UpdateItem",
            "dynamodb:PutItem"
        ]
        resources = [aws_dynamodb_table.resume-visit-counter.arn]
    }
    statement {
        sid = "resume-api-lambda-list"
        effect = "Allow"
        actions = [
            "dynamodb:ListTables"
        ]
        resources = ["*"]
    }
}

data "aws_iam_policy_document" "resume-api-lambda-assume" {
    statement {
        sid = "resume-api-lambda-assume-role"
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

    assume_role_policy = data.aws_iam_policy_document.resume-api-lambda-assume.json
    #managed_policy_arns = [ data.aws_iam_policy_document.resume-api-lambda-policy.arn ]
}

resource "aws_lambda_function" "resume-api-lambda" {
    filename = "resume-api.py"
    function_name = "resume-api"
    role = aws_iam_role.resume-api-lambda-iam.arn
    runtime = "python3.9"
    handler = "lambda_function.lambda_handler"

}