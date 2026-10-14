locals {
  attach = var.attach != null ? var.attach : length(var.server_ids) + length(var.label_selectors) > 0
}

# ###############################################
#  Hetzner Cloud Firewall
# ###############################################
resource "hcloud_firewall" "current" {
  name   = var.name
  labels = var.labels

  lifecycle {
    precondition {
      condition     = local.attach ? length(var.apply) == 0 : true
      error_message = "Use either inline apply targets or the separate attachment, not both."
    }
  }

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

# One resource owns the complete attachment set for this firewall.
resource "hcloud_firewall_attachment" "current" {
  count           = local.attach ? 1 : 0
  firewall_id     = hcloud_firewall.current.id
  server_ids      = var.server_ids
  label_selectors = var.label_selectors

  lifecycle {
    precondition {
      condition     = length(var.server_ids) + length(var.label_selectors) > 0
      error_message = "An enabled firewall attachment requires server_ids or label_selectors."
    }
  }
}
