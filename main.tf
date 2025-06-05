provider "aws" {
  region = "us-east-1"
}

locals {
    # update aws key
    aws_key = "aws-key-us-east-1"
  }

# add secrutiy group resource to allow HTTP traffic
resource "aws_security_group" "http" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_server" {
   ami           = data.aws_ami.amazonlinux.id
   instance_type = var.instance_type
   key_name      = "${local.aws_key}"

   # force a public IP on launch
   associate_public_ip_address = true
  
   # attach the HTTP security group so port 80 is open
   vpc_security_group_ids = [aws_security_group.http.id]

   # install wordpress with wp_install.sh script
   user_data = file("${path.module}/wp_install.sh")

   tags = {
     Name = "my ec2"
   }
 }