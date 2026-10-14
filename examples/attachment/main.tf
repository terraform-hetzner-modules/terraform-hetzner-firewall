module "firewall" {
  source          = "../.."
  name            = "attached-firewall"
  attach          = true
  server_ids      = var.server_ids
  label_selectors = var.label_selectors
  rules = {
    https = { direction = "in", protocol = "tcp", port = "443", source_ips = ["0.0.0.0/0", "::/0"] }
  }
}
