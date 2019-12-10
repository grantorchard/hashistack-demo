provider vault {
    address = var.vault_address
    token = var.vault_token
}

# Read in policies from the files created in the policies folder.

data template_file "admin" {
    template = "${file("policies/admin.hcl")}"
}
resource vault_policy "admin" {
  name = "admin"

  policy = <<EOT
    ${data.template_file.admin.rendered}
EOT
}

# Create entity for "me/you"

resource vault_identity_entity "me" {
  name      = var.vault_entity_name
  policies  = [vault_policy.admin.name]
  metadata  = {
    }
}

# Create Github auth backend and associated Github entity alias

resource vault_github_auth_backend "github-hashicorp" {
  organization = "hashicorp"
}
resource vault_identity_entity_alias "github" {
    name = var.github_username
    canonical_id = vault_identity_entity.me.id
    mount_accessor = vault_github_auth_backend.github-hashicorp.accessor
}


# Create Userpass backend and associated Userpass entity alias

resource vault_auth_backend "userpass" {
  type = "userpass"
}

resource vault_generic_endpoint "me" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/${var.vault_entity_name}"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "password": "${var.vault_entity_password}"
}
EOT
}

resource vault_identity_entity_alias "userpass" {
    name = var.vault_entity_name
    canonical_id = vault_identity_entity.me.id
    mount_accessor = vault_auth_backend.userpass.accessor
}

# Create GCP Backend.

resource vault_gcp_auth_backend "gcp" {
    credentials  = "${file(var.gcp_credentials_json)}"
}