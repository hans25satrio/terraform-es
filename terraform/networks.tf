provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}
resource "aws_vpc" "vpchans" {
  cidr_block           = var.vpcs
  enable_dns_support   = true
  enable_dns_hostnames = true
}