variable "server_url" {
  type = "string"
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "email_address" {
    type = "string"
}

variable "common_name" {
    type = "string"
}

variable "subject_alternative_names" {
  type = "list"
  default = []
}



