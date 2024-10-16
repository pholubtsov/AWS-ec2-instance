resource "aws_key_pair" "my_ssh_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

output "key_name" {
  value = aws_key_pair.my_ssh_key.key_name
}
