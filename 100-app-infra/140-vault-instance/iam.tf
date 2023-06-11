resource "aws_iam_policy" "vault_server_policy" {
  name        = "${local.name}-server-policy"
  description = "Vault server policy to access DynamoDB, KMS and Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:DescribeLimits",
          "dynamodb:DescribeTimeToLive",
          "dynamodb:ListTagsOfResource",
          "dynamodb:DescribeReservedCapacityOfferings",
          "dynamodb:DescribeReservedCapacity",
          "dynamodb:ListTables",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:CreateTable",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:GetRecords",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:Scan",
          "dynamodb:DescribeTable"
        ],
        Effect   = "Allow"
        Resource = [aws_dynamodb_table.vault_storage_table.arn]
      },
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey"
        ],
        Effect   = "Allow"
        Resource = [data.aws_kms_key.kms_key.arn]
      },
      {
        Action = [
          "secretsmanager:ListSecrets",
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:CreateSecret",
          "secretsmanager:UpdateSecret"
        ],
        Effect = "Allow"
        Resource = [
          "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:cicd-vault-${terraform.workspace}-token*",
          "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:vault-secret-init-*"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "vault_server_role" {
  name = "${local.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "vault_server_attach" {
  name       = "${local.name}-attachment"
  roles      = [aws_iam_role.vault_server_role.name]
  policy_arn = aws_iam_policy.vault_server_policy.arn
}

resource "aws_iam_instance_profile" "vault_server_profile" {
  name = "${local.name}-profile"
  role = aws_iam_role.vault_server_role.name
}
