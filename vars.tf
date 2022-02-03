variable "region" {
  default = "eu-west-3"
  type = string
}

variable "vpcs" {
  type = map(object({
    cidr_block = string
    zones = list(string)
    newbits = number
  }))
}

variable "peers" {
  type = map(object({
    requester = object({
      env = string
      region = string
    })
    accepter = object({
      env = string
      region = string
    })
  }))
  default = {}
}

variable "private_domain" {
  type = string
}

variable "user" {
  type = string
}
