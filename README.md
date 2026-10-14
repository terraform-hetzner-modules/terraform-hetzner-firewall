<p align="center">
    <!-- terraform-hetzner-firewall -->
<img src="https://cdn.simpleicons.org/terraform/844FBA" alt="Terraform Logo" align="center" width="128">
<img src="https://avatars.githubusercontent.com/u/30047064?s=200&v=4" alt="Hetzner Logo" align="center" width="128">
    <h1 align="center">Hetzner Cloud</h1>
    <h2 align="center"><code>firewall</code></h2>
</p>

[![License](https://img.shields.io/github/license/terraform-hetzner-modules/terraform-hetzner-firewall?label=License)](https://opensource.org/licenses/MIT)
[![Terraform](https://img.shields.io/badge/Terraform-_>=_1.7-brightgreen?logo=terraform&logoColor=623CE4)][terraform]
[![OpenTofu](https://img.shields.io/badge/OpenTofu-_>=_1.8-brightgreen?logo=opentofu)][opentofu]
[![CI Status](https://github.com/terraform-hetzner-modules/terraform-hetzner-firewall/actions/workflows/testing.yaml/badge.svg)](https://github.com/terraform-hetzner-modules/terraform-hetzner-firewall/blob/main/.github/workflows/testing.yaml)
[![GitHub Release](https://img.shields.io/github/v/release/terraform-hetzner-modules/terraform-hetzner-firewall?label=Release)][github_releases]
[![GitHub Activity](https://img.shields.io/github/commit-activity/m/terraform-hetzner-modules/terraform-hetzner-firewall?label=Commits)][github_commits]
[![Renovate](https://img.shields.io/badge/Renovate-enabled-brightgreen?logo=renovate&logoColor=1A1F6C)][renovate]
[![Pre-Commit](https://img.shields.io/badge/PreCommit-enabled-brightgreen?logo=precommit&logoColor=FAB040)][pre-commit]

A [Terraform module][module] to create and manage firewalls for your servers within [Hetzner Cloud][hetzner].

## ✨ TL;DR

```hcl
module "hetzner_firewall_apache" {
  source = "terraform-hetzner-modules/firewall/hetzner"
  ...
}
```

## Compatibility and examples

Requires Terraform >= 1.7 (OpenTofu >= 1.8 tested) and hcloud ~> 1.70.
See [basic](examples/basic) and [full](examples/full) examples; configure credentials through `HCLOUD_TOKEN`.

Read the [upgrade guide](docs/UPGRADING.md) before moving from v1.
The generated [schema report](docs/SCHEMA.md) lists provider fields, module
mappings, and remaining coverage review items.
Run `terraform init -backend=false`, `terraform validate`, and `terraform test`
for credential-free validation and tests.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | ~> 1.70 |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_apply"></a> [apply](#input\_apply) | Named attachment targets, each with exactly one server\_id or label\_selector. | ```map(object({ server_id = optional(number) label_selector = optional(string) }))``` | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels attached to the firewall. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the firewall. | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | Named rules. Inbound rules use source\_ips; outbound rules use destination\_ips. Ports are required only for TCP/UDP. | ```map(object({ direction = string protocol = string port = optional(string) description = optional(string) source_ips = optional(list(string), []) destination_ips = optional(list(string), []) }))``` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_apply_to"></a> [apply\_to](#output\_apply\_to) | The 'apply\_to' configuration for the new Hetzner Cloud firewall. |
| <a name="output_id"></a> [id](#output\_id) | The unique ID for the new Hetzner Cloud firewall. |
| <a name="output_labels"></a> [labels](#output\_labels) | The labels for the new Hetzner Cloud firewall. |
| <a name="output_name"></a> [name](#output\_name) | The name for the new Hetzner Cloud firewall. |
| <a name="output_rules"></a> [rules](#output\_rules) | The rules for the new Hetzner Cloud firewall. |
<!-- END_TF_DOCS -->

### 🔃 Contributing

Refer to our [documentation for contributors][contributing] for contributing guidelines, commit message
formats and versioning tips.

### 📥 Maintainers

This project is owned and maintained by [Terraform Hetzner Modules][org]. Refer to the [`AUTHORS`][authors] or [`CODEOWNERS`][owners]
for more information. You may also use the linked contact details to reach out directly.

### ©️ Copyright

- _Assets provided by:_ **[HashiCorp][hashicorp]**
- _Sources provided by:_ **[Terraform Hetzner Modules][org]** under the **[MIT License][license]**

<!-- INTERNAL REFERENCES -->

<!-- Project references -->

<!-- File references -->

[license]: LICENSE
[contributing]: docs/CONTRIBUTING.md
[authors]: .github/AUTHORS
[owners]: .github/CODEOWNERS

<!-- General links -->

[org]: https://github.com/terraform-hetzner-modules
[terraform]: https://terraform.io
[opentofu]: https://opentofu.org/
[hashicorp]: https://www.hashicorp.com/
[hetzner]: https://hetzner.com
[github_releases]: https://github.com/terraform-hetzner-modules/terraform-hetzner-firewall/releases
[github_commits]: https://github.com/terraform-hetzner-modules/terraform-hetzner-firewall/commits/main/

<!-- Third-party -->

[module]: https://registry.terraform.io/modules/terraform-hetzner-modules/firewall/hetzner/latest
[renovate]: https://renovatebot.com/
[pre-commit]: https://pre-commit.com/
