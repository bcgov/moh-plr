resource "aws_secretsmanager_secret" "plr_pg_url" {
  name = "${var.application}_pg_url"
}

resource "aws_secretsmanager_secret" "plr_pg_user" {
  name = "${var.application}_user"
}

resource "aws_secretsmanager_secret" "plrweb_keycloak_client_secret" {
  name = "${var.web_application }_keycloak_client_secret"
}

resource "aws_secretsmanager_secret" "plrweb_provider_uri" {
  name = "${var.web_application }_provider_uri"
}

resource "aws_secretsmanager_secret" "plrweb_redirect_uri" {
  name = "${var.web_application }_redirect_uri"
}

resource "aws_secretsmanager_secret" "plrweb_siteminder_logout_uri" {
  name = "${var.web_application }_siteminder_logout_uri"
}

resource "aws_secretsmanager_secret" "plrweb_phsa_logout_uri" {
  name = "${var.web_application }_phsa_logout_uri"
}

resource "aws_secretsmanager_secret" "plresb_keycloak_client_secret" {
  name = "${var.esb_application }_keycloak_client_secret"
}

resource "aws_secretsmanager_secret" "plresb_provider_uri" {
  name = "${var.esb_application }_provider_uri"
}

resource "aws_secretsmanager_secret" "plresb_redirect_uri" {
  name = "${var.esb_application }_redirect_uri"
}

resource "aws_secretsmanager_secret" "plresb_siteminder_logout_uri" {
  name = "${var.esb_application }_siteminder_logout_uri"
}

resource "aws_secretsmanager_secret" "plresb_phsa_logout_uri" {
  name = "${var.esb_application }_phsa_logout_uri"
}


resource "aws_secretsmanager_secret_version" "plresb_keycloak_client_secret" {
  secret_id     = aws_secretsmanager_secret.plresb_keycloak_client_secret.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plresb_provider_uri" {
  secret_id     = aws_secretsmanager_secret.plresb_provider_uri.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plresb_redirect_uri" {
  secret_id     = aws_secretsmanager_secret.plresb_redirect_uri.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plresb_siteminder_logout_uri" {
  secret_id     = aws_secretsmanager_secret.plresb_siteminder_logout_uri.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plresb_phsa_logout_uri" {
  secret_id     = aws_secretsmanager_secret.plresb_phsa_logout_uri.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plrweb_keycloak_client_secret" {
  secret_id     = aws_secretsmanager_secret.plrweb_keycloak_client_secret.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plrweb_provider_uri" {
  secret_id     = aws_secretsmanager_secret.plrweb_provider_uri.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plrweb_redirect_uri" {
  secret_id     = aws_secretsmanager_secret.plrweb_redirect_uri.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plrweb_siteminder_logout_uri" {
  secret_id     = aws_secretsmanager_secret.plrweb_siteminder_logout_uri.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plrweb_phsa_logout_uri" {
  secret_id     = aws_secretsmanager_secret.plrweb_phsa_logout_uri.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id     = aws_secretsmanager_secret.plr_pg_user.id
  secret_string = <<EOF
{
  "username": "plrmerge",
  "password": "changeme"
}
EOF
  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret_version" "plr_pg_url" {
  secret_id     = aws_secretsmanager_secret.plr_pg_url.id
  secret_string = "changeme"
}

