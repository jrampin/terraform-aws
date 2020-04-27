output "server_ip" {
  value = aws_instance.ec2_instance.public_dns
}