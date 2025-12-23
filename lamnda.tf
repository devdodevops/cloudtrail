module "lambda" {
  source  = "app.terraform.io/dev-lab-devops/lambda/aws"
  version = "0.0.2"
  create_lambda_function = false
  schedule_expression = "cron(20 0 * * ? *)"
  environment = "dev"
}
