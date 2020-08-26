variable "region" {
  default = "us-east-1"
}

variable "aws_endpoint" {
default = "s3.amazonaws.com"
}
variable "aws_access_key" {}
variable "aws_secret_access_key" {}

variable "api_request_key" {}
variable "api_response_key" {}

variable "whoi_ip" {
  default = "128.128.0.0/16"
}

variable "id_generator_url" {}
variable "id_generator_api_key" {}

variable "auth_url" {
    default = "https://orcid.org/oauth/authorize"
}
variable "auth_force_logout_url" {
    default = "https://orcid.org/userStatus.json?logUserOut=true"
}
variable "auth_token_url" {
    default = "https://orcid.org/oauth/token"
}
variable "auth_client_id" {}
variable "auth_client_secret" {}

variable "orcid_api_url" {
    default = "https://pub.orcid.org/v3.0"
}


variable "submission_version" {}
