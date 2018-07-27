terraform {
  backend "gcs" {
    bucket  = "datawireio-cloud-terraform"
    prefix  = "cloud-infra"
  }
}
