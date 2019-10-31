provider "acme" {
  server_url = var.server_url
}

resource "tls_private_key" "tfe" {
  algorithm = "RSA"
}

resource "acme_registration" "tfe" {
  account_key_pem = "${tls_private_key.tfe.private_key_pem}"
  email_address   = var.email_address
}

resource "acme_certificate" "tfe" {
  account_key_pem           = "${acme_registration.tfe.account_key_pem}"
  common_name               = var.tfe_common_name
  subject_alternative_names = var.tfe_subject_alternative_names

  dns_challenge {
    provider = "route53"
  }
}

resource "tls_private_key" "gitlab" {
  algorithm = "RSA"
}

resource "acme_registration" "gitlab" {
  account_key_pem = "${tls_private_key.gitlab.private_key_pem}"
  email_address   = var.email_address
}

resource "acme_certificate" "gitlab" {
  account_key_pem           = "${acme_registration.gitlab.account_key_pem}"
  common_name               = var.gitlab_common_name
  subject_alternative_names = var.gitlab_subject_alternative_names

  dns_challenge {
    provider = "route53"
  }
}
