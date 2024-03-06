#data "aws_acm_certificate" "plrweb_certificate" {
#  domain      = var.web_url
#  statuses    = ["ISSUED"]
#  most_recent = true
#}

module "web_api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "2.2.2"

  name                   = "${var.web_application}-http-api"
  description            = "HTTP API Gateway"
  protocol_type          = "HTTP"
  create_api_domain_name = false

  #  domain_name                 = var.web_url
  #  domain_name_certificate_arn = data.aws_acm_certificate.plrweb_certificate.arn

  integrations = {
    "ANY /{proxy+}" = {
      connection_type    = "VPC_LINK"
      vpc_link           = "plrweb-vpc"
      integration_uri    = data.aws_alb_listener.front_end.arn
      integration_type   = "HTTP_PROXY"
      integration_method = "ANY"
    }
  }
  vpc_links = {
    plrweb-vpc = {
      name               = "${var.web_application}-vpc-link"
      security_group_ids = [data.aws_security_group.web.id]
      subnet_ids         = data.aws_subnets.web.ids
    }
  }
}

#data "aws_acm_certificate" "plresb_certificate" {
#  domain      = var.esb_url
#  statuses    = ["ISSUED"]
#  most_recent = true
#}

module "esb_api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "2.2.2"

  name                   = "${var.esb_application}-http-api"
  description            = "HTTP API Gateway"
  protocol_type          = "HTTP"
  create_api_domain_name = false

  #  domain_name                 = var.esb_url
  #  domain_name_certificate_arn = data.aws_acm_certificate.plresb_certificate.arn

  integrations = {
    "ANY /{proxy+}" = {
      connection_type    = "VPC_LINK"
      vpc_link           = "plresb-vpc"
      integration_uri    = data.aws_alb_listener.front_end.arn
      integration_type   = "HTTP_PROXY"
      integration_method = "ANY"
    }
  }
  vpc_links = {
    plresb-vpc = {
      name               = "${var.esb_application}-vpc-link"
      security_group_ids = [data.aws_security_group.web.id]
      subnet_ids         = data.aws_subnets.web.ids
    }
  }
}