include {
  path = find_in_parent_folders()
}

generate "test_tfvars" {
  path              = "test.auto.tfvars"
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
  alb_origin_id = "gist.hlth.gov.bc.ca"
  application_url = "gist.hlth.gov.bc.ca"
  aurora_acu_min = 0.5
  aurora_acu_max = 4
  EOF
}
