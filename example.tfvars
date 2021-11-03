region = "us-east-1"

vpcs = {
  sre = {
    cidr_block = "192.168.0.0/16"
    zones = [
      "public",
    ]
  }
  okd = {
    cidr_block = "10.0.0.0/16"
    zones = [
      "public",
      "private"
    ]
  }
}

user = "foobar"
private_domain = "foobar.local"
