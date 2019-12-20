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

# Create entity for "me/you" in default space

resource vault_identity_entity "me" {
  name      = var.vault_entity_name
  policies  = [vault_policy.admin.name]
  metadata  = {
    }
}

Grant Orchard, [20.12.19 08:11]
terraform {
  required_version = "> 0.12.0"
}

provider vault {
    token = "s.3qGrqpJLeWE9iNMYHyyyRb6T"
}

resource vault_namespace "pepsi" {
    path = "pepsi"
}

resource vault_namespace "coke" {
    path = "coke"
}

provider vault {
    alias = "pepsi"
    namespace = vault_namespace.pepsi.path
    token = "s.3qGrqpJLeWE9iNMYHyyyRb6T"
}

provider vault {
    alias = "coke"
    namespace = vault_namespace.coke.path
    token = "s.3qGrqpJLeWE9iNMYHyyyRb6T"
}

resource vault_mount "p-secret" {
  provider = vault.pepsi
  path        = "secret"
  type        = "generic"
  description = "This is an example mount"
}

resource vault_mount "c-secret" {
  provider = vault.coke
  path        = "secret"
  type        = "generic"
  description = "This is an example mount"
}

resource vault_generic_secret "p-example" {
  path = "${vault_mount.p-secret.path}/p-example"
  provider = vault.pepsi

  data_json = <<EOT
{
  "foo":   "bar",
  "pizza": "cheese"
}
EOT
}

resource vault_generic_secret "c-example" {
  path = "${vault_mount.c-secret.path}/c-example"
  provider = vault.coke

  data_json = <<EOT
{
  "foo":   "bar",
  "pizza": "cheese"
}
EOT
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

# Enable Vault Auditing to File

resource "vault_audit" "auditfile" {
  type = "file"

  options = {
    file_path = "/tmp/audit.log"
  }
}
