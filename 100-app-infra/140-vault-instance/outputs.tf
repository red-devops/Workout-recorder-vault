output "vault_private_ip" {
  value = aws_instance.vault_server.private_ip
}