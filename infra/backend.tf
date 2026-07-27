terraform {
  backend "s3" {
    bucket       = "threat-composer-terraform-state-108367189744"
    key          = "prod/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}