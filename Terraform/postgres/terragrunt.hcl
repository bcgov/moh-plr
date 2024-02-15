include {
  path = find_in_parent_folders()
}

generate "dev_tfvars" {
  path              = "dev.auto.tfvars"
  if_exists         = "overwrite"
  disable_signature = true
  contents          = <<-EOF
  web_cpu = 512
  web_memory = 1024
  esb_cpu = 512
  esb_memory = 1024
  web_port = 8181
  esb_port = 8181
  fam_console_idp_name = "DEV-IDIR"
  alb_origin_id = "gisd.hlth.gov.bc.ca"
  application_url = "gisd.hlth.gov.bc.ca"
  aurora_acu_min = 0.5
  aurora_acu_max = 1
  EOF
}