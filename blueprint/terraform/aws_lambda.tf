//Builds the lambda
//resource "null_resource" "compile_lambda" {
//  provisioner "local-exec" {
//    command = " pwd && cd ../lambdas/eventbridge_eventgrid_adapter && npm run clean && npm install && npm run build"
//  }
//}

//resource "null_resource" "build_layer" {
//  provisioner "local-exec" {
//    command = "cd ../lambdas/eventbridge_eventgrid_adapter && npm run clean && npm install && npm run build"
//  }
//}

//Builds the zip file
data "archive_file" "lambda_zip" {
//  depends_on  = [null_resource.compile_lambda]
  type        = "zip"
  source_dir = "../lambdas/eventbridge_eventgrid_adapter/build"
  output_path = "../lambdas/eventbridge_eventgrid_adapter/dist/adapter.zip"
}

data "archive_file" "lambda_layer_zip" {
//  depends_on  = [null_resource.compile_lambda]
  type        = "zip"
  source_dir = "../lambdas/eventbridge_eventgrid_adapter/layers"
  output_path = "../lambdas/eventbridge_eventgrid_adapter/dist/node_modules.zip"
}

//Defines the Lambda execution role
data "aws_iam_policy_document" "lambda_execution_role_document" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    sid = "LambdaExecutionRole"
  }
}


//Create the Lambda execution role
resource "aws_iam_role" "lambda_execution_role" {
  name               = "eventgrid-lambda-LambdaExecutionRole"
  assume_role_policy= data.aws_iam_policy_document.lambda_execution_role_document.json
}


resource "aws_lambda_permission" "allow_from_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.eventbridge_eventgrid_adapter.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.audit_events_rule.arn
}


//Deploys and creates the Lambda
resource "aws_lambda_function" "eventbridge_eventgrid_adapter" {
  function_name    = "eventbridge-eventgrid-lambda"
  description      = "Adapter and proxy to Azure event grid"
  filename         = data.archive_file.lambda_zip.output_path
  handler          = "main.adapt"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = aws_iam_role.lambda_execution_role.arn
  layers = [aws_lambda_layer_version.lambda_layer.arn]
  runtime          = "nodejs14.x"
  timeout          = 30

  environment {
    variables = {
      EVENT_GRID_EVENT_GRID_SCHEMA_API_KEY = data.azurerm_eventgrid_topic.created_eventgrid.primary_access_key
      EVENT_GRID_EVENT_GRID_SCHEMA_ENDPOINT = data.azurerm_eventgrid_topic.created_eventgrid.endpoint
    }
  } 
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = data.archive_file.lambda_layer_zip.output_path
  layer_name = "lambdaLayer"
  source_code_hash = data.archive_file.lambda_layer_zip.output_base64sha256
  compatible_runtimes = ["nodejs14.x"]
}

resource "aws_cloudwatch_log_group" "eventbridge_eventgrid_lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.eventbridge_eventgrid_adapter.function_name}"
  retention_in_days = 14
}
