terraform {
  backend "gcs" {
    bucket  = "datawireio-cloud-terraform"
    prefix  = "vault-server"
  }
}
