#Creating the Lambda Function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code"  # Path to your local directory with lambda_function.py and custom_encoder.py
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "serverless_lambda" {
  function_name = "serverless-lambda"  # Change if using a different name; keep consistent

  role          = aws_iam_role.serverlessapi_role.arn  # References the IAM role from previous config

  handler       = "lambda_function.lambda_handler"  # Standard handler; verify in lambda_function.py if different

  runtime       = "python3.13"  # Latest Python runtime as of now

  memory_size   = 500
  timeout       = 60  # 1 minute

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256  # Ensures updates on code changes
}
