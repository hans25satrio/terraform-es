variable "aws_access_key" {
  default = "AKIARYVWZUH5SVPASF5F"
}

variable "aws_secret_key" {
  default = "kPK0mZ5SMiX4bmWVUh6C1jeZM8Qyw0HcF8qnaeSf"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "ips" {
  default = {
    "1" = "172.28.0.6" 
  }
}

variable "vpcs" {
  default     = "172.28.0.0/16"
  description = "vpc hans"
}

variable "Subnet-Publics" {
  default     = "172.28.0.0/24"
  description = "subnet hans"
}

variable "key_name" {
  default = "hans-key"
}