locals {
  databases = {
    appdb = {
      username="postgres"
      dbname = "app"
    }
  }
}

resource "random_password" "pw" {
  for_each = local.databases
  length = 15
  special = true
  override_special = "_%@"
}

resource "aws_kms_key" "secrets-key" {
  description = "Key for managing secrets"
  enable_key_rotation = true
  deletion_window_in_days = 30
}

resource "aws_secretsmanager_secret" "initial-password" {
  for_each = random_password.pw
  kms_key_id = aws_kms_key.secrets-key.key_id
  description = "Initial password for ${each.key}"
  name = "initial-password-${each.key}"
}

resource "aws_secretsmanager_secret_version" "initial-passwords" {
  for_each = random_password.pw
  secret_id = aws_secretsmanager_secret.initial-password[each.key].id
  secret_string = each.value.result
}
