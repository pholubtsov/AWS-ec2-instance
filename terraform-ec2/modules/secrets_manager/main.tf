resource "random_password" "secret_password" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "my_secret" {
  name = var.secret_name
}

resource "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id     = aws_secretsmanager_secret.my_secret.id
  secret_string = random_password.secret_password.result
}

output "secret_arn" {
  value = aws_secretsmanager_secret.my_secret.arn
}
