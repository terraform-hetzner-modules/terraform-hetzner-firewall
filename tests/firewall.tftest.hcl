mock_provider "hcloud" {
  mock_resource "hcloud_firewall" { defaults = { id = "42" } }
}
variables { name = "test-firewall" }
run "empty_firewall" {
  command = apply
  assert {
    condition     = length(output.rules) == 0 && output.attachment == null
    error_message = "Empty rules should be supported."
  }
}
run "all_protocols_and_targets" {
  command = apply
  variables {
    rules = {
      ping  = { direction = "in", protocol = "icmp", source_ips = ["::/0"] }
      gre   = { direction = "in", protocol = "gre", source_ips = ["10.0.0.0/8"] }
      esp   = { direction = "out", protocol = "esp", destination_ips = ["0.0.0.0/0"] }
      dns   = { direction = "out", protocol = "udp", port = "53", destination_ips = ["0.0.0.0/0"] }
      https = { direction = "in", protocol = "tcp", port = "443", source_ips = ["0.0.0.0/0"], description = "HTTPS" }
    }
    apply = {
      server   = { server_id = 123 }
      selector = { label_selector = "environment=test" }
    }
  }
  assert {
    condition     = length(output.rules) == 5 && length(output.apply_to) == 2
    error_message = "All protocols and both target forms must reach the provider."
  }
}
run "reject_missing_port" {
  command = plan
  variables { rules = { bad = { direction = "in", protocol = "tcp", source_ips = ["0.0.0.0/0"] } } }
  expect_failures = [var.rules]
}
run "reject_wrong_ips" {
  command = plan
  variables { rules = { bad = { direction = "out", protocol = "icmp", source_ips = ["0.0.0.0/0"] } } }
  expect_failures = [var.rules]
}
run "reject_ambiguous_target" {
  command = plan
  variables { apply = { bad = { server_id = 123, label_selector = "env=test" } } }
  expect_failures = [var.apply]
}
run "reject_invalid_cidr" {
  command = plan
  variables { rules = { bad = { direction = "in", protocol = "icmp", source_ips = ["not-a-cidr"] } } }
  expect_failures = [var.rules]
}

run "separate_attachment" {
  command = apply
  variables {
    server_ids      = [123, 456, 123]
    label_selectors = ["environment=test", "role=web"]
  }
  assert {
    condition     = output.attachment.firewall_id == tonumber(output.id) && output.attachment.server_ids == toset([123, 456]) && output.attachment.label_selectors == toset(["environment=test", "role=web"])
    error_message = "One attachment must own all distinct servers and selectors for the current firewall."
  }
}

run "selector_only_attachment" {
  command = apply
  variables { label_selectors = ["role=web"] }
  assert {
    condition     = output.attachment != null && length(output.attachment.server_ids) == 0
    error_message = "Selectors alone must enable the attachment."
  }
}

run "explicitly_disabled_attachment" {
  command = apply
  variables {
    attach     = false
    server_ids = [123]
  }
  assert {
    condition     = output.attachment == null && output.attachment_id == null
    error_message = "Explicitly disabling attachment must override configured targets."
  }
}

run "reject_mixed_attachment_ownership" {
  command = plan
  variables {
    apply      = { inline = { server_id = 123 } }
    server_ids = [456]
  }
  expect_failures = [hcloud_firewall.current]
}

run "reject_empty_enabled_attachment" {
  command = plan
  variables { attach = true }
  expect_failures = [hcloud_firewall_attachment.current]
}
