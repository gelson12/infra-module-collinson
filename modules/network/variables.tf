variable "name"                { type = string }
variable "vpc_cidr"            { type = string }
variable "public_subnet_cidr"  { type = string }
variable "private_subnet_cidr" { type = string }
variable "enable_nat"          { type = bool }
variable "az"                  { type = string }
variable "tags"                { type = map(string) }
