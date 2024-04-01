resource "aws_secretsmanager_secret" "plr_pg_url" {
  name = "${var.application}_pg_url"
}

resource "aws_secretsmanager_secret" "plr_pg_user" {
  name = "${var.application}_user"
}

resource "aws_secretsmanager_secret" "plrweb_db_name" {
  name = "${var.web_application}_db_name"
}

resource "aws_secretsmanager_secret" "plrweb_keycloak_client_secret" {
  name = "${var.web_application }_keycloak_client_secret"
}

resource "aws_secretsmanager_secret" "plrweb_keycloak_client_id" {
  name = "${var.web_application }_keycloak_client_id"
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

resource "aws_secretsmanager_secret" "plrweb_env_name" {
  name = "${var.web_application }_env_name"
}

resource "aws_secretsmanager_secret" "plrweb_esb_dist_service" {
  name = "${var.web_application }_esb_dist_service"
}

resource "aws_secretsmanager_secret" "plrweb_esb_batch_service_uri" {
  name = "${var.web_application }_esb_batch_service_uri"
}

resource "aws_secretsmanager_secret" "plrweb_esb_address_validation_service_uri" {
  name = "${var.web_application }_esb_address_validation_service_uri"
}

resource "aws_secretsmanager_secret" "plrweb_esb_keystore_password" {
  name = "${var.web_application }_esb_keystore_password"
}

resource "aws_secretsmanager_secret" "plrweb_esb_key_password" {
  name = "${var.web_application }_esb_key_password"
}

resource "aws_secretsmanager_secret" "plrweb_esb_truststore_password" {
  name = "${var.web_application }_esb_truststore_password"
}

resource "aws_secretsmanager_secret" "plrweb_ums_url" {
  name = "${var.web_application }_ums_url"
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

resource "aws_secretsmanager_secret" "plresb_keyclock_cert_url" {
  name = "${var.esb_application }_keyclock_cert_url"
}

resource "aws_secretsmanager_secret" "plresb_ums_url" {
  name = "${var.esb_application }_ums_url"
}

resource "aws_secretsmanager_secret" "plresb_sftp_password" {
  name = "${var.esb_application }_sftp_password"
}

resource "aws_secretsmanager_secret" "plresb_plr_endpoint_base_url" {
  name = "${var.esb_application }_plr_endpoint_base_url"
}

resource "aws_secretsmanager_secret" "plresb_filedrop_location" {
  name = "${var.esb_application }_filedrop_location"
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

resource "aws_secretsmanager_secret_version" "plresb_keyclock_cert_url" {
  secret_id     = aws_secretsmanager_secret.plresb_keyclock_cert_url.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plresb_ums_url" {
  secret_id     = aws_secretsmanager_secret.plresb_ums_url.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plresb_sftp_password" {
  secret_id     = aws_secretsmanager_secret.plresb_sftp_password.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plresb_plr_endpoint_base_url" {
  secret_id     = aws_secretsmanager_secret.plresb_plr_endpoint_base_url.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plresb_filedrop_location" {
  secret_id     = aws_secretsmanager_secret.plresb_filedrop_location.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plrweb_keycloak_client_secret" {
  secret_id     = aws_secretsmanager_secret.plrweb_keycloak_client_secret.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plrweb_keycloak_db_name" {
  secret_id     = aws_secretsmanager_secret.plrweb_keycloak_db_name.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plrweb_keycloak_client_id" {
  secret_id     = aws_secretsmanager_secret.plrweb_keycloak_client_id.id
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

resource "aws_secretsmanager_secret_version" "plrweb_env_name" {
  secret_id     = aws_secretsmanager_secret.plrweb_env_name.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plrweb_esb_dist_service" {
  secret_id     = aws_secretsmanager_secret.plrweb_esb_dist_service.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plrweb_esb_batch_service_uri" {
  secret_id     = aws_secretsmanager_secret.plrweb_esb_batch_service_uri.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plrweb_esb_address_validation_service_uri" {
  secret_id     = aws_secretsmanager_secret.plrweb_esb_address_validation_service_uri.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plrweb_esb_keystore_password" {
  secret_id     = aws_secretsmanager_secret.plrweb_esb_keystore_password.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plrweb_esb_truststore_password" {
  secret_id     = aws_secretsmanager_secret.plrweb_esb_truststore_password.id
  secret_string = "changeme"
}

resource "aws_secretsmanager_secret_version" "plrweb_ums_url" {
  secret_id     = aws_secretsmanager_secret.plrweb_ums_url.id
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

