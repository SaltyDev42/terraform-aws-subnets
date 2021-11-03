variable "region" {
  default = "eu-west-3"
  type = string
}

variable "vpcs" {
  type = map(object({
    cidr_block = string
    zones = list(string)
  }))
}

variable "private_domain" {
  type = string
}

variable "user" {
  type = string
}
