variable "server_ids" {
  description = "Existing servers to attach."
  type        = set(number)
  default     = []
}

variable "label_selectors" {
  description = "Additional servers selected by labels."
  type        = set(string)
  default     = ["role=web"]
}
