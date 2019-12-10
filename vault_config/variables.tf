
variable vault_address {
    type = "string"
    default = "http://10.10.0.3:8200"
}
variable vault_token {
    type = "string"
    default = "root"
}

variable vault_entity_name {
    type = "string"
}

variable github_username {
    type = "string"
}

variable vault_entity_password {
    type = "string"
    default = "Hashi1!"
    description = "Used for setting up the entity alias with the userpass backend. This password will be captured in the state file so do not use a real password."
}

variable gcp_credentials_json {
    type = "string"
}
