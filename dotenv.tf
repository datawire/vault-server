locals {
  vault_crt = "${tls_locally_signed_cert.vault.cert_pem}\n${tls_self_signed_cert.vault_ca.cert_pem}"
}

data "template_file" "dotenv" {
  template = "${file("${path.module}/deploy.env.tpl")}"

  vars {
    vault_server_count          = "${var.vault_server_count}"
    vault_load_balancer_address = "${google_compute_address.vault.address}"
    vault_gcs_bucket_name       = "${google_storage_bucket.vault.name}"
    vault_init_kms_key_id       = "${var.vault_init_crypto_key_id}"
    vault_crt                   = "${tls_locally_signed_cert.vault.cert_pem}\n${tls_self_signed_cert.vault_ca.cert_pem}"
    vault_crt_base64            = "${base64encode(local.vault_crt)}"
    vault_key                   = "${tls_private_key.vault.private_key_pem}"
    vault_key_base64            = "${base64encode(tls_private_key.vault.private_key_pem)}"
  }
}
