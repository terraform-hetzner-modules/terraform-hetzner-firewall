# Full firewall example

Two firewalls demonstrate mutually exclusive attachment models: `apply` manages inline associations,
while `attach`, `server_ids`, and `label_selectors` manage a separate attachment. Never enable both
models for the same firewall. The example also shows inbound and outbound rule fields; the unused
address list is empty for each direction.

Replace the unrestricted SSH source CIDRs with your administrative ranges before applying.
Attachments happen after the example server is created and do not guarantee first-boot protection.

## Running the example

Export `HCLOUD_TOKEN`, supply the inputs described in `variables.tf`, then run:

```shell
terraform init
terraform plan
terraform apply
```

This creates real infrastructure. Review the plan and any deletion protection before cleanup.
See the [module README](../../README.md) for provider configuration and input descriptions.
