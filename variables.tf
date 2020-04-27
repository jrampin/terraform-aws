variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "public_route_table" {
  default = "0.0.0.0/0"
}

variable "public_subnet" {
  default = "10.0.1.0/24"
}

variable "private_subnet1" {
  default = "10.0.2.0/24"
}

variable "private_subnet2" {
  default = "10.0.3.0/24"
}
