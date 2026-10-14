variable "name" {
  type        = string
  description = "Name of the firewall."
}
variable "labels" {
  type        = map(string)
  description = "Labels attached to the firewall."
  default     = {}
}
variable "rules" {
  type = map(object({
    direction       = string
    protocol        = string
    port            = optional(string)
    description     = optional(string)
    source_ips      = optional(list(string), [])
    destination_ips = optional(list(string), [])
  }))
  description = "Named rules. Inbound rules use source_ips; outbound rules use destination_ips. Ports are required only for TCP/UDP."
  default     = {}
  nullable    = false
  validation {
    condition     = alltrue([for r in var.rules : contains(["in", "out"], r.direction) && contains(["tcp", "udp", "icmp", "gre", "esp"], r.protocol)])
    error_message = "Rules require direction in/out and protocol tcp/udp/icmp/gre/esp."
  }
  validation {
    condition     = alltrue([for r in var.rules : contains(["tcp", "udp"], r.protocol) ? try(length(r.port) > 0, false) : r.port == null])
    error_message = "TCP/UDP rules require a port (a number, range, or any); other protocols must omit port."
  }
  validation {
    condition     = alltrue([for r in var.rules : r.direction == "in" ? length(r.source_ips) > 0 && length(r.destination_ips) == 0 : length(r.destination_ips) > 0 && length(r.source_ips) == 0])
    error_message = "Inbound rules require only source_ips; outbound rules require only destination_ips."
  }
  validation {
    condition     = alltrue(flatten([for r in var.rules : [for cidr in concat(r.source_ips, r.destination_ips) : can(cidrhost(cidr, 0))]]))
    error_message = "Firewall IP ranges must be valid IPv4 or IPv6 CIDRs."
  }
}
variable "apply" {
  type = map(object({
    server_id      = optional(number)
    label_selector = optional(string)
  }))
  description = "Inline attachment targets, each with exactly one server_id or label_selector. Mutually exclusive with an enabled separate attachment."
  default     = {}
  nullable    = false
  validation {
    condition     = alltrue([for target in var.apply : (target.server_id != null) != (target.label_selector != null)])
    error_message = "Each target must specify exactly one of server_id and label_selector."
  }
}

variable "attach" {
  type        = bool
  description = "Whether to create the single separate attachment resource. Null enables it when server_ids or label_selectors are non-empty. Set true explicitly when IDs are unknown until apply."
  default     = null
}

variable "server_ids" {
  type        = set(number)
  description = "Server IDs managed by the separate attachment resource. Leave apply empty when using this interface."
  default     = []
  nullable    = false
}

variable "label_selectors" {
  type        = set(string)
  description = "Label selectors managed by the separate attachment resource. Leave apply empty when using this interface."
  default     = []
  nullable    = false
}
