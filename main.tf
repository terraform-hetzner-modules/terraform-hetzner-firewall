# ###############################################
#  Hetzner Cloud Firewall
# ###############################################
resource "hcloud_firewall" "current" {
  name   = var.name
  labels = var.labels

  dynamic "rule" {
    for_each = var.rules

    content {
      direction       = rule.value["direction"]
      protocol        = rule.value["protocol"]
      port            = rule.value["port"]
      description     = rule.value["description"]
      source_ips      = rule.value.source_ips
      destination_ips = rule.value.destination_ips
    }
  }

  dynamic "apply_to" {
    for_each = var.apply

    content {
      server         = try(apply_to.value["server_id"], null)
      label_selector = try(apply_to.value["label_selector"], null)
    }
  }
}
