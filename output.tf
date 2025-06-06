output "instance_ip_addr" {
  value = aws_instance.my_server[*].private_ip
}

# add a public ip address output for the EC2 instance
output "public_ip" {
  value = aws_instance.my_server[*].public_ip
}