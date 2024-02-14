include {
  path = find_in_parent_folders()
}

generate "prod_tfvars" {
  path              = "prod.auto.tfvars"
  if_exists         = "overwrite"
  disable_signature = true
  contents          = <<-EOF
  web_cpu = 512
  web_memory = 1024
  esb_cpu = 512
  esb_memory = 1024
  web_port = 8181
  esb_port = 8181
  fam_console_idp_name = "TEST-IDIR"
  alb_origin_id = "plr.ynr9ed-prod.nimbus.cloud.gov.bc.ca"
  application_url = "gis.hlth.gov.bc.ca"
  EOF
}
