terraform {
  required_version = ">= 1.7"
  required_providers {
    hcloud = { source = "hetznercloud/hcloud", version = "~> 1.70" }
  }
}

resource "terraform_data" "server_id" { input = 123 }

module "subject" {
  source     = "../.."
  name       = "computed-attachment"
  attach     = true
  server_ids = [terraform_data.server_id.output]
}

output "name" {
  description = "An attachment can be planned before its server ID is known."
  value       = module.subject.name
}
