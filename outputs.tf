output "id" {
  value       = hcloud_firewall.current.id
  description = "The unique ID for the new Hetzner Cloud firewall."
}

output "name" {
  value       = hcloud_firewall.current.name
  description = "The name for the new Hetzner Cloud firewall."
}

output "labels" {
  value       = hcloud_firewall.current.labels
  description = "The labels for the new Hetzner Cloud firewall."
}

output "rules" {
  value       = hcloud_firewall.current.rule
  description = "The rules for the new Hetzner Cloud firewall."
}

output "apply_to" {
  value       = hcloud_firewall.current.apply_to
  description = "The 'apply_to' configuration for the new Hetzner Cloud firewall."
}

output "attachment" {
  value       = try(hcloud_firewall_attachment.current[0], null)
  description = "Complete separate attachment attributes, or null when disabled."
}

output "attachment_id" {
  value       = try(hcloud_firewall_attachment.current[0].id, null)
  description = "ID of the separate attachment, or null when disabled."
}
