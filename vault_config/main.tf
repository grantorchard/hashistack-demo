terraform {
  required_version = "> 0.12.0"
}

provider vault {
    address = var.vault_address
    token = var.vault_token
}

provider vault {
    alias = "vp-pepsi"
    namespace = "pepsi"
    address = var.vault_address
}

provider vault  {
    alias = "vp-coke"
    namespace = "coke"
    address = var.vault_address
}


# # Read in policies from the files created in the policies folder.

# data template_file "admin" {
#     template = "${file("policies/admin.hcl")}"
# }
# resource vault_policy "admin" {
#   name = "admin"

#   policy = <<EOT
#     ${data.template_file.admin.rendered}
# EOT
# }

# # Create entity for "me/you" in default space

# resource vault_identity_entity "me" {
#   name      = var.vault_entity_name
#   policies  = [vault_policy.admin.name]
#   metadata  = {
#     }
# }

# # Create entity for "me/you" in coke space

# resource vault_identity_entity "me-coke" {
#   depends_on = [vault_namespace.coke]
#   provider  = vault.vp-coke
#   name      = var.vault_entity_name
#   policies  = [vault_policy.admin.name]
#   metadata  = {
#     }
# }

# # Create entity for "me/you" in coke space

# resource vault_identity_entity "me-pepsi" {
#   depends_on = [vault_namespace.pepsi]
#   provider  = vault.vp-pepsi
#   name      = var.vault_entity_name
#   policies  = [vault_policy.admin.name]
#   metadata  = {
#     }
# }

# # Create Github auth backend and associated Github entity alias

# resource vault_github_auth_backend "github-hashicorp" {
#   organization = "hashicorp"
# }
# resource vault_identity_entity_alias "github" {
#     name = var.github_username
#     canonical_id = vault_identity_entity.me.id
#     mount_accessor = vault_github_auth_backend.github-hashicorp.accessor
# }

# # Namespaces

resource "vault_namespace" "pepsi" {
  provider  = vault.vp-pepsi
  path = "/pepsi"
}

resource "vault_namespace" "coke" {
  provider  = vault.vp-coke
  path = "/coke"
}


# # Create Userpass backend and associated Userpass entity alias

// resource vault_auth_backend "userpass" {
//   type = "userpass"
// }
//
// resource vault_generic_endpoint "me" {
//   depends_on           = [vault_auth_backend.userpass]
//   path                 = "auth/userpass/users/${var.vault_entity_name}"
//   ignore_absent_fields = true
//
//   data_json = <<EOT
// {
//   "password": "${var.vault_entity_password}"
// }
// EOT
// }

# resource vault_identity_entity_alias "userpass" {
#     name = var.vault_entity_name
#     canonical_id = vault_identity_entity.me.id
#     mount_accessor = vault_auth_backend.userpass.accessor
# }
# # Pepsi
# # Create Userpass backend and associated Userpass entity alias

# resource vault_auth_backend "userpass-pepsi" {
#   depends_on = [vault_namespace.pepsi]
#   provider  = vault.vp-pepsi
#   type = "userpass"
# }

# resource vault_generic_endpoint "me-pepsi" {
#   provider  = vault.vp-pepsi
#   depends_on           = [vault_auth_backend.userpass-pepsi]
#   path                 = "auth/userpass/users/${var.vault_entity_name}"
#   ignore_absent_fields = true

#   data_json = <<EOT
# {
#   "password": "${var.vault_entity_password}"
# }
# EOT
# }

# resource vault_identity_entity_alias "userpass-pepsi" {
#     depends_on = [vault_namespace.pepsi]
#     name = var.vault_entity_name
#     canonical_id = vault_identity_entity.me-pepsi.id
#     mount_accessor = vault_auth_backend.userpass-pepsi.accessor
# }
# # Coke
# # Create Userpass backend and associated Userpass entity alias

# resource vault_auth_backend "userpass-coke" {
#   provider  = vault.vp-coke
#   type = "userpass"
# }

# resource vault_generic_endpoint "me-coke" {
#   provider  = vault.vp-coke
#   depends_on           = [vault_auth_backend.userpass-coke]
#   path                 = "auth/userpass/users/${var.vault_entity_name}"
#   ignore_absent_fields = true

#   data_json = <<EOT
# {
#   "password": "${var.vault_entity_password}"
# }
# EOT
# }

# resource vault_identity_entity_alias "userpass-coke" {
#     name = var.vault_entity_name
#     canonical_id = vault_identity_entity.me-coke.id
#     mount_accessor = vault_auth_backend.userpass-coke.accessor
# }

# # Create GCP Backend.

# resource vault_gcp_auth_backend "gcp" {
#     credentials  = "${file(var.gcp_credentials_json)}"
# }

# # Enable Vault Auditing to File

# resource "vault_audit" "auditfile" {
#   type = "file"

#   options = {
#     file_path = "/tmp/audit.log"
#   }
# }

# //TODO - Add Namespaces for these

# # Enable secret enginers
# # resource "vault_mount" "coke" {
# #   provider = vault.vp-coke
# #   path        = "secret"
# #   type        = "secret"
# #   description = "This is the coke mount"
# # }

# # resource "vault_mount" "pepsi" {
# #   provider = vault.vp-pepsi
# #   path        = "secret"
# #   type        = "secret"
# #   description = "This is the Pepsi mount"
# # }
# # Enable basic Keyvalue data

# # resource "vault_generic_secret" "pepsi-secrets" {
# #   provider = vault.vp-pepsi
# #   path = "/secret/web-user"
# #   # namespace = "pepsi"

# #   data_json = <<EOT
# # {
# #   "user":   "web-pepsi",
# #   "password": "Hashi1!"
# # }
# # EOT
# # }

# # resource "vault_generic_secret" "coke-secrets" {
# #   path = "secret/web-user"
# #   # namespace = "coke"
# #   provider = vault.vp-coke
# #   data_json = <<EOT
# # {
# #   "user":   "web-coke",
# #   "password": "Hashi1!"
# # }
# # EOT
# # }

# # Populate some basic name spaces and add specifc namespace users
