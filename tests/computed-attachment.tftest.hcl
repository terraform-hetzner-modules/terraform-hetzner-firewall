mock_provider "hcloud" {
  mock_resource "hcloud_firewall" { defaults = { id = "42" } }
}

run "computed_server_id_is_plannable" {
  command = plan
  module { source = "./tests/setup" }
  assert {
    condition     = output.name == "computed-attachment"
    error_message = "Explicit attach must keep the resource count known with a computed server ID."
  }
}
