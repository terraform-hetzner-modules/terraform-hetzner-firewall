resource "hcloud_server" "example" {
  name        = "firewall-example"
  image       = "debian-13"
  server_type = "cx23"
  location    = "fsn1"
  labels      = { environment = "example" }
}
module "firewall_example" {
  source = "../.."
  name   = "example-firewall"
  labels = { environment = "example" }
  rules = {
    ssh = {
      direction       = "in"
      protocol        = "tcp"
      port            = "22"
      destination_ips = []
      source_ips      = ["0.0.0.0/0", "::/0"]
      description     = "Replace with your administrator CIDRs."
    }
    web_out = {
      direction       = "out"
      protocol        = "tcp"
      port            = "443"
      source_ips      = []
      description     = "Allow outbound HTTPS."
      destination_ips = ["0.0.0.0/0", "::/0"]
    }
  }
  attach          = false
  server_ids      = []
  label_selectors = []
  apply = {
    server   = { server_id = hcloud_server.example.id }
    selector = { label_selector = "environment=example" }
  }
}

# A separate firewall demonstrates the alternative attachment ownership model.
module "attached_firewall" {
  source = "../.."
  name   = "example-attached-firewall"
  labels = { environment = "example" }
  rules = {
    https = {
      direction       = "in"
      protocol        = "tcp"
      port            = "443"
      source_ips      = ["0.0.0.0/0", "::/0"]
      destination_ips = []
      description     = "Allow inbound HTTPS."
    }
  }
  apply           = {}
  attach          = true
  server_ids      = [hcloud_server.example.id]
  label_selectors = ["role=web"]
}
