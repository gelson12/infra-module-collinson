
############################################
# AMI (NOTE: LocalStack Community can't DescribeImages)
# For REAL AWS -> keep this data source.
# For LOCALSTACK -> comment it out and use local.web_ami_id instead.
############################################
# data "aws_ami" "web_ami" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "architecture"
#     values = ["arm64"]
#   }
#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023*"]
#   }
# }
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

locals {
  # LocalStack-safe dummy AMI (any string). For real AWS, use the data source above.
  web_ami_id = var.web_ami_id
}

resource "aws_instance" "web_ec2" {
  ami = local.web_ami_id
  instance_market_options {
    market_type = var.market_type
    spot_options {
      max_price = var.max_price
    }
  }
  instance_type = var.instance_type
  tags = {
    Name = var.name
  }
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.securitygroup.id]
  associate_public_ip_address = true
}


resource "aws_security_group" "securitygroup" {
  name   = "sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH from anywhere #however what would happen if i added this instead - >prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #however what would happen if i added this instead - >prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
  }
}
