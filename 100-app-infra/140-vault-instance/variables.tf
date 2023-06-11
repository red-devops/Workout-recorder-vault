variable "region" {
  description = "Region where to build infrastructure"
  type        = string
}

variable "team" {
  description = "Name of the team"
  type        = string
}

variable "kms_key_id" {
  description = "Vault kms key ID for auto unseal"
  type        = string
}
