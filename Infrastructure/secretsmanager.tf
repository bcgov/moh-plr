resource "aws_secretsmanager_secret" "plr_pg_url" {
  name = "${var.application}_pg_url"
}

resource "aws_secretsmanager_secret" "plr_pg_user" {
  name = "${var.application}_user"
}

resource "aws_secretsmanager_secret" "gis_keycloak_client_secret" {
  name = "${var.application}_keycloak_client_secret"
}

resource "aws_secretsmanager_secret" "gis_provider_uri" {
  name = "${var.application}_provider_uri"
}

resource "aws_secretsmanager_secret" "gis_redirect_uri" {
  name = "${var.application}_redirect_uri"
}

resource "aws_secretsmanager_secret" "gis_siteminder_logout_uri" {
  name = "${var.application}_siteminder_logout_uri"
}

resource "aws_secretsmanager_secret" "gis_phsa_logout_uri" {
  name = "${var.application}_phsa_logout_uri"
}

resource "aws_secretsmanager_secret_version" "gis_keycloak_client_secret" {
  secret_id     = aws_secretsmanager_secret.gis_keycloak_client_secret.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "gis_provider_uri" {
  secret_id     = aws_secretsmanager_secret.gis_provider_uri.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "gis_redirect_uri" {
  secret_id     = aws_secretsmanager_secret.gis_redirect_uri.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "gis_siteminder_logout_uri" {
  secret_id     = aws_secretsmanager_secret.gis_siteminder_logout_uri.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "gis_phsa_logout_uri" {
  secret_id     = aws_secretsmanager_secret.gis_phsa_logout_uri.id
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

