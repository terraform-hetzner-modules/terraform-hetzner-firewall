## [2.0.0](https://github.com/terraform-hetzner-modules/terraform-hetzner-firewall/compare/v1.0.0...v2.0.0) (2026-10-14)

### ⚠ BREAKING CHANGES

* **module/firewall:** require Terraform >= 1.7 and hcloud ~> 1.70. Rules and
attachment targets now use typed objects and reject invalid combinations.

### Features

* **module/firewall:** refresh firewall rules and repository tooling ([4264d6b](https://github.com/terraform-hetzner-modules/terraform-hetzner-firewall/commit/4264d6ba473006a501f70c2ebce33ab119066aca))

### Bug Fixes

* **ci:** propagate verified release and Super-Linter fixes ([b57698b](https://github.com/terraform-hetzner-modules/terraform-hetzner-firewall/commit/b57698b6e6d428fde67e5e73cb98a80623de7c63))

## 1.0.0 (2024-11-19)

### Features

* initial release `v1.0.0` ([b70e95d](https://github.com/terraform-hetzner-modules/terraform-hetzner-firewall/commit/b70e95d7a9cc890dc38b165c4a3b13bda9c7d664))
