# Hetzner Firewall Terraform module

Manage a firewall, inbound and outbound rules, and attachments to servers or label selectors.

## Usage

Copy this configuration into `main.tf` and add the
[provider configuration](#provider-configuration) below in `versions.tf`.

```hcl
module "firewall" {
  source = "terraform-hetzner-modules/firewall/hetzner"

  name = "web"
  rules = {
    https = {
      direction  = "in"
      protocol   = "tcp"
      port       = "443"
      source_ips = ["0.0.0.0/0", "::/0"]
    }
  }
  label_selectors = ["role=web"]
}
```

This attaches the firewall to servers labeled `role=web` and permits inbound HTTPS. Add any other
inbound rules you need before attaching it, including restricted administrative access.

## Provider configuration

Export your Hetzner API token as `HCLOUD_TOKEN`. Put the following in your calling root's `versions.tf`:

```hcl
terraform {
  required_version = ">= 1.7"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.70"
    }
  }
}

provider "hcloud" {}
```

With both files in place, run `terraform init`, `terraform plan`, and `terraform apply`.
Credentials and provider configuration belong in the calling root.
Terraform >= 1.7 and OpenTofu >= 1.8 are supported.

## Examples

- [Basic](examples/basic): a firewall with inbound rules.
- [Full](examples/full): every input and rule field, with inline and separate attachment alternatives.
- [Attachment](examples/attachment): a separate attachment with computed server IDs.

## Separate attachment management

The optional `hcloud_firewall_attachment` resource manages all `server_ids` and `label_selectors`
for this firewall in one place. Non-empty targets enable it automatically; set `attach = true`
when server IDs are computed, or `attach = false` to disable it explicitly.
See the [attachment example](examples/attachment). The `attachment` output contains the resource
attributes, or null when disabled.

Keep `apply = {}` when using the separate attachment. Existing inline `apply` callers remain supported;
the module rejects enabling both ownership mechanisms. Coordinate server-side `firewall_ids` ownership
as described in the [provider documentation](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall_attachment).
Separate attachments are applied after server creation and do not guarantee protection on first boot.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.7 |
| hcloud | ~> 1.70 |

## Providers

| Name | Version |
| ---- | ------- |
| hcloud | ~> 1.70 |

## Resources

| Name | Type |
| ---- | ---- |
| [hcloud_firewall.current](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall) | resource |
| [hcloud_firewall_attachment.current](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| apply | Inline attachment targets, each with exactly one server\_id or label\_selector. Mutually exclusive with an enabled separate attachment. | ```map(object({ server_id = optional(number) label_selector = optional(string) }))``` | `{}` | no |
| attach | Whether to create the single separate attachment resource. Null enables it when server\_ids or label\_selectors are non-empty. Set true explicitly when IDs are unknown until apply. | `bool` | `null` | no |
| label\_selectors | Label selectors managed by the separate attachment resource. Leave apply empty when using this interface. | `set(string)` | `[]` | no |
| labels | Labels attached to the firewall. | `map(string)` | `{}` | no |
| name | Name of the firewall. | `string` | n/a | yes |
| rules | Named rules. Inbound rules use source\_ips; outbound rules use destination\_ips. Ports are required only for TCP/UDP. | ```map(object({ direction = string protocol = string port = optional(string) description = optional(string) source_ips = optional(list(string), []) destination_ips = optional(list(string), []) }))``` | `{}` | no |
| server\_ids | Server IDs managed by the separate attachment resource. Leave apply empty when using this interface. | `set(number)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| apply\_to | The 'apply\_to' configuration for the new Hetzner Cloud firewall. |
| attachment | Complete separate attachment attributes, or null when disabled. |
| attachment\_id | ID of the separate attachment, or null when disabled. |
| id | The unique ID for the new Hetzner Cloud firewall. |
| labels | The labels for the new Hetzner Cloud firewall. |
| name | The name for the new Hetzner Cloud firewall. |
| rules | The rules for the new Hetzner Cloud firewall. |
<!-- END_TF_DOCS -->

## Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for local checks and contribution guidelines, and
[UPGRADING.md](docs/UPGRADING.md) for compatibility and live acceptance checks. The generated
[schema report](docs/SCHEMA.md) documents provider coverage and intentional omissions.

## Authors

Maintained by [Terraform Hetzner Modules](https://github.com/terraform-hetzner-modules).
See [AUTHORS](.github/AUTHORS) and [CODEOWNERS](.github/CODEOWNERS).

## License

MIT. See [LICENSE](LICENSE).
