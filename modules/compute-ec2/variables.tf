# module variables.tf



variable "subnet_id" { type = string }   # <-- ID, not CIDR
variable "vpc_id"    { type = string }   # to create the SG in the right VPC

variable "web_ami_id"         { type = string }
variable "market_type"        { type = string }
variable "max_price"          { type = string }


variable "instance_type"      { type = string }
variable "name"               { type = string }