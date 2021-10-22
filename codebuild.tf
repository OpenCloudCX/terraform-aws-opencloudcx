resource "aws_codebuild_project" "ocx_build_bootstrap" {

  count = 1

  name          = "ocxbootstrap-${random_string.suffix.result}"
  build_timeout = 180
  service_role  = aws_iam_role.codebuild.arn

  source {
    type     = "GITHUB"
    location = "https://github.com/OpenCloudCX/opencloudcx-config" # var.aws_codebuild_repository

    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = false
    }
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "RANDOM_SEED"
      value = random_string.suffix.result
    }

    environment_variable {
      name  = "TERRAFORM_VERSION"
      value = "0.14.2"
    }

    environment_variable {
      name  = "INGRESS_ENDPOINT"
      value = "jenkins-insecure.${var.dns_zone}" #data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname
    }

    environment_variable {
      name  = "EKS_ENDPOINT"
      value = aws_eks_cluster.eks.endpoint
    }

    environment_variable {
      name  = "GITHUB_ACCESS_TOKEN"
      value = var.github_access_token
    }

    environment_variable {
      name  = "JENKINS_SECRET"
      value = var.jenkins_secret
    }

    environment_variable {
      name  = "EKS_NAME"
      value = aws_eks_cluster.eks.name
    }

    environment_variable {
      name  = "JENKINS_API_TOKEN"
      value = "CHANGE-ME"
    }

  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  depends_on = [
    helm_release.ingress-controller,
    kubernetes_ingress.jenkins_ingress_alb,
  ]

}

resource "aws_iam_role_policy" "codebuild-eks-kubectl-policy" {
  name   = "${random_string.suffix.result}-ocxbootstrap-codebuild-eks-kubectl-policy"
  role   = aws_iam_role.codebuild_kubectl_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "eks:Describe*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "codebuild_kubectl_role" {
  name               = "${random_string.suffix.result}-ocxbootstrap-codebuild-kubectl-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.aws_account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild-eks-assume-policy" {
  name   = "${random_string.suffix.result}-ocxbootstrap-codebuild-eks-assume-policy"
  role   = aws_iam_role.codebuild.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "${aws_iam_role.codebuild_kubectl_role.arn}"
        }
    ]  
}
EOF
}

resource "aws_iam_role" "codebuild" {
  name               = "${random_string.suffix.result}-ocxbootstrap-codebuild-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}  
EOF
}

resource "aws_iam_role_policy" "code_build_cloudwatch_logs" {
  name = "${random_string.suffix.result}-ocxbootstrap-codebuild-cloudwatch-logs-policy"
  role = aws_iam_role.codebuild.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:us-east-1:${var.aws_account_id}:log-group:ocxbootstrap-${random_string.suffix.result}",
                "arn:aws:logs:us-east-1:${var.aws_account_id}:log-group:ocxbootstrap-${random_string.suffix.result}:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "code_build_base" {
  name = "${random_string.suffix.result}-ocxbootstrap-codebuild-base-policy"
  role = aws_iam_role.codebuild.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Resource": [
              "arn:aws:logs:us-east-1:${var.aws_account_id}:log-group:/aws/codebuild/ocxbootstrap-${random_string.suffix.result}",
              "arn:aws:logs:us-east-1:${var.aws_account_id}:log-group:/aws/codebuild/ocxbootstrap-${random_string.suffix.result}:*"
          ],
          "Action": [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
          ]
      },
      {
          "Effect": "Allow",
          "Action": [
              "codebuild:CreateReportGroup",
              "codebuild:CreateReport",
              "codebuild:UpdateReport",
              "codebuild:BatchPutTestCases",
              "codebuild:BatchPutCodeCoverages"
          ],
          "Resource": [
              "arn:aws:codebuild:us-east-1:${var.aws_account_id}:report-group/${random_string.suffix.result}-ocxbootstrap-*"
          ]
      }
   ]
}  
EOF
}

resource "aws_iam_role" "usaspending_ocxbootstrap_ghost" {
  name               = "${random_string.suffix.result}-ocxbootstrap-ghost"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}  
EOF
}

resource "aws_iam_role_policy" "ocxbootstrap_policy" {
  name = "${random_string.suffix.result}-ocxbootstrap-execute-policy"
  role = aws_iam_role.usaspending_ocxbootstrap_ghost.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:StartBuild"
            ],
            "Resource": [
                "arn:aws:codebuild:us-east-1:${var.aws_account_id}:project/${random_string.suffix.result}-ocxbootstrap"
            ]
        }
    ]
}
EOF  
}