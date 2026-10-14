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
      direction   = "in"
      protocol    = "tcp"
      port        = "22"
      source_ips  = ["0.0.0.0/0", "::/0"]
      description = "Replace with your administrator CIDRs."
    }
    web_out = {
      direction       = "out"
      protocol        = "tcp"
      port            = "443"
      destination_ips = ["0.0.0.0/0", "::/0"]
    }
  }
  apply = {
    server   = { server_id = hcloud_server.example.id }
    selector = { label_selector = "environment=example" }
  }
}
