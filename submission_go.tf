resource "aws_ecr_repository" "submission_go" {
  name                 = "submission_go_${terraform.workspace}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_cloudwatch_log_group" "submission_go" {
  name              = "/ecs/submission_go_${terraform.workspace}"
  retention_in_days = "7"

}


resource "aws_ecs_task_definition" "submission_go" {
  family                = "submission_go_${terraform.workspace}"
  container_definitions = <<EOF
[
    {
        "name": "submission_go_container_${terraform.workspace}",
        "image": "${aws_ecr_repository.submission_go.repository_url}:${terraform.workspace == "default" ? "latest" : var.submission_version}",
        "portMappings": [
            {
                "containerPort": 8080
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${aws_cloudwatch_log_group.submission_go.name}",
                "awslogs-region": "us-east-1",
                "awslogs-stream-prefix": "ecs"
            }
        },
        "environment": [
            {
                "name": "MINIO_ENDPOINT",
                "value": "${var.aws_endpoint}"
            },
            {
                "name": "MINIO_ACCESS_KEY",
                "value": "${var.aws_access_key}"
            },
            {
                "name": "MINIO_SECRET_KEY",
                "value": "${var.aws_secret_access_key}"
            },
            {
                "name": "APP_USE_SSL",
                "value": "true"
            },
            {
                "name": "MINIO_SUBMISSIONS_BUCKET",
                "value": "${aws_s3_bucket.submissions.bucket}"
            },
            {
                "name": "MINIO_PROJECTS_BUCKET",
                "value": "${aws_s3_bucket.projects.bucket}"
            },
            {
                "name": "MINIO_PERMISSIONS_BUCKET",
                "value": "${aws_s3_bucket.submissions_permissions.bucket}"
            },
            {
                "name": "OFFLINE_DEVELOPMENT",
                "value": "true"
            },
            {
                "name": "SUBMISSION_VALIDATION_URL",
                "value": ""
            },
            {
                "name": "SUBMISSION_VALIDATION_REQUEST_API_KEY",
                "value": "${var.api_request_key}"
            },
            {
                "name": "SUBMISSION_VALIDATION_RESPONSE_API_KEY",
                "value": "${var.api_response_key}"
            },
            {
                "name": "ID_GENERATOR_URL",
                "value": "${var.id_generator_url}"
            },
            {
                "name": "ID_GENERATOR_API_KEY",
                "value": "${var.id_generator_api_key}"
            },
            {
                "name": "AUTH_FORCE_LOGOUT_URL",
                "value": "${var.auth_force_logout_url}"
            },
            {
                "name": "AUTH_URL",
                "value": "${var.auth_url}"
            },
            {
                "name": "AUTH_TOKEN_URL",
                "value": "${var.auth_token_url}"
            },
            {
                "name": "AUTH_CLIENT_ID",
                "value": "${var.auth_client_id}"
            },
            {
                "name": "AUTH_CLIENT_SECRET",
                "value": "${var.auth_client_secret}"
            },
            {
                "name": "ORCID_API_URL",
                "value": "${var.orcid_api_url}"
            },
            {
                "name": "PORT",
                "value": "8080"
            }
        ]
    }
]

EOF

  task_role_arn      = aws_iam_role.ecs_role.arn
  execution_role_arn = aws_iam_role.ecs_role.arn

  cpu    = "512"
  memory = "1024"

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  tags = {
    name = terraform.workspace == "default" ? "latest" : var.submission_version
  }

}

resource "aws_ecs_service" "submission_go" {
  name                 = "submission_go_${terraform.workspace}"
  launch_type          = "FARGATE"
  force_new_deployment = "true"
  cluster              = aws_ecs_cluster.submission.id
  task_definition      = aws_ecs_task_definition.submission_go.arn
  desired_count        = 1
  depends_on           = [aws_iam_role_policy.s3_access_policy, aws_iam_role_policy.ecs_access_policy, aws_alb.submission_go]

  network_configuration {
    subnets          = [aws_default_subnet.default_1a.id, aws_default_subnet.default_1b.id]
    security_groups  = [aws_security_group.submission.id]
    assign_public_ip = "true"
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.web.id
    container_name   = "submission_go_container_${terraform.workspace}"
    container_port   = 8080
  }



  lifecycle {
    ignore_changes = [desired_count]
  }


}
