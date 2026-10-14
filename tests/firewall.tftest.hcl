mock_provider "hcloud" {}
variables { name = "test-firewall" }
run "empty_firewall" {
  command = apply
  assert {
    condition     = length(output.rules) == 0
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
