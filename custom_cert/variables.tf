variable "server_url" {
  type = "string"
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "email_address" {
    type = "string"
}

variable "tfe_common_name" {
    type = "string"
}

variable "tfe_subject_alternative_names" {
  type = "list"
  default = []
}

variable "gitlab_common_name" {
    type = "string"
}

variable "gitlab_subject_alternative_names" {
  type = "list"
  default = []
}
