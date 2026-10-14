module "firewall_example" {
  source = "../.."
  name   = "example-firewall"
  rules = {
    https = {
      direction  = "in"
      protocol   = "tcp"
      port       = "443"
      source_ips = ["0.0.0.0/0", "::/0"]
    }
    ping = {
      direction  = "in"
      protocol   = "icmp"
      source_ips = ["0.0.0.0/0", "::/0"]
    }
  }
}
