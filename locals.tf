locals {
  // as far as I can tell this form of <location>/<key-ring>/<key> is only valid for Terraform...
  tf_vault_init_crypto_key_id = "${var.keyring_location}/${var.keyring_name}/${var.vault_init_crypto_key_name}"

  // this is the form used by Google Cloud libraries
  vault_init_crypto_key_id = "projects/${var.project}/locations/${var.keyring_location}/keyRings/${var.keyring_name}/cryptoKeys/${var.vault_init_crypto_key_name}"

  vault_crt = "${tls_locally_signed_cert.vault.cert_pem}\n${tls_self_signed_cert.vault_ca.cert_pem}"
}