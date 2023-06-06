resource "aws_kms_key" "wordpress" {
  description             = "KMS Key used to encrypt Wordpress related resources"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms.json
}

resource "aws_kms_alias" "wordpress" {
  name          = "alias/wordpress"
  target_key_id = aws_kms_key.wordpress.id
}

resource "aws_secretsmanager_secret" "wordpress" {
  name_prefix = "wordpress"
  description = "Secrets for ECS Wordpress"
  kms_key_id  = aws_kms_key.wordpress.id
}