# Upgrade guide

This refresh targets `hetznercloud/hcloud ~> 1.70` and Terraform >= 1.7.
The test matrix covers Terraform 1.7.5/1.16.6 and OpenTofu 1.8.8/1.13.1.
These are module compatibility tests; older engines are not necessarily in the provider's own supported test matrix.

## Before upgrading

Back up the root configuration's state and commit its dependency lock file. Upgrade the module source
and run `terraform init -upgrade` (or `tofu init -upgrade`). Review the plan before applying it.
Child module lock files do not constrain the consuming root configuration.

The minimum engine/provider versions and typed object inputs are intentional compatibility changes.
Use the next major module release. Unknown object properties may be discarded by Terraform's object
conversion: check property names against the generated input documentation.

Existing resource names and caller-supplied map keys remain stable. Retain those keys when upgrading.
Changes to resource identity or other immutable properties can still trigger replacement according
to the provider; no migration can make those configuration changes intrinsically non-destructive.

## Checks

Run `terraform init -backend=false`, `terraform validate`, and `terraform test`
(or the equivalent `tofu` commands). Initialize and validate the examples and
test helpers separately. Tests mock cloud resources.
No cloud credentials are needed and no real infrastructure is created.

Before a production release, exercise creation, a second no-change plan, updates, and teardown in a
disposable Hetzner project. Mocks do not verify live API behavior, quotas, or capacity.

## Provider coverage maintenance

Formr generates the [schema report](SCHEMA.md). With the module initialized,
run `formr schema . -o docs/SCHEMA.md` to regenerate it and
`formr check . --report docs/SCHEMA.md` to check for drift. Use the same engine
and provider selections recorded in the report's provenance.

The current default policy checks inventory completeness and unresolved
analysis. Strict interface coverage and exception annotations are not yet
implemented, so a passing default check does not approve omitted fields.

Regenerate README inputs/outputs with `terraform-docs -c .github/linters/.terraform-docs.yml .`.
Resource IDs remain provider-managed. Deprecated fields are not reintroduced as new inputs.

## Firewall changes

`rules` and `apply` are maps of typed objects. Ports are required for TCP/UDP and omitted for ICMP/GRE/ESP;
rule descriptions are optional. Inbound rules use only `source_ips`, outbound rules only `destination_ips`.
CIDRs support both IP families. Each attachment target must contain exactly one `server_id` or string
`label_selector`, for example `{ label_selector = "environment=prod" }`. Labels now default to `{}`.

Manage a firewall's attachments through one ownership mechanism. Avoid simultaneously managing the
same attachment through this module, `hcloud_firewall_attachment`, and a server's `firewall_ids`.

## Separate firewall attachment

The optional attachment is additive: existing inline `apply` configurations keep their behavior.
New `server_ids` and `label_selectors` inputs feed a single `hcloud_firewall_attachment.current[0]`.
Use `attach = true` when IDs are unknown during planning. Explicit false suppresses creation; null
infers creation from non-empty target sets. An enabled attachment must have at least one target.
Do not combine this with inline `apply` targets or another resource managing this firewall's attachments.

Moving existing inline targets to the separate resource is an ownership migration, not a resource move.
Remove inline `apply` configuration, supply the same complete target sets, and import the existing
attachment using the firewall ID into `module.<name>.hcloud_firewall_attachment.current[0]`.
Review the plan for unintended detachment before applying. Test this migration in a disposable project.
The firewall resource keeps its existing address; no automatic moved block is needed.

The attachment's SDK `id` field is provider-managed rather than exposed as a creation input.
