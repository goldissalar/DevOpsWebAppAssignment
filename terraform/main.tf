provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region (e.g., "us-east-1")
}

resource "aws_iam_role" "myroles" {
  name = "ecsTaskExecutionRole_salarmaaf"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "build.apprunner.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "myrolespolicy" {
  role       = aws_iam_role.myroles.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "time_sleep" "waitrolecreate" {
  depends_on       = [aws_iam_role.myroles]
  create_duration  = "60s"
}


resource "aws_ecr_repository" "my_app" {
  name         = "salarmaaf-devops-terraform-app"
  force_delete = true
}


resource "aws_apprunner_service" "my-app-runner" {
  depends_on   = [time_sleep.waitrolecreate]
  service_name = "my-app-runner" # Replace with your desired service name
  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.myroles.arn
    }
    image_repository {
      image_identifier      = "245154219216.dkr.ecr.us-east-1.amazonaws.com/salarmaaf-devops-terraform-app:latest" # Replace with your ECR repository URL and image tag
      image_repository_type = "ECR"
      image_configuration {
        port = 80 # Replace with the desired port
      }
    }
  }
}

# Output the URL of the AWS App Runner service
output "app_runner_url" {
  value = aws_apprunner_service.my-app-runner.service_url
}