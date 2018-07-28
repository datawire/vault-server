data "template_file" "dotenv" {
  template = "${file("${path.module}/deploy.env.tpl")}"

  vars {
    vault_server_count          = "${var.vault_server_count}"
    vault_load_balancer_address = "${google_compute_address.vault.address}"
    vault_gcs_bucket_name       = "${google_storage_bucket.vault.name}"
    vault_init_kms_key_id       = "${local.vault_init_crypto_key_id}"
    vault_crt_base64            = "${base64encode(local.vault_crt)}"
    vault_key_base64            = "${base64encode(tls_private_key.vault.private_key_pem)}"
  }
}

resource "null_resource" "dotenv" {
  triggers {
    vault_server_count          = "${md5(var.vault_server_count)}"
    vault_load_balancer_address = "${md5(google_compute_address.vault.address)}"
    vault_gcs_bucket_name       = "${md5(google_storage_bucket.vault.name)}"
    vault_init_kms_key_id       = "${md5(local.vault_init_crypto_key_id)}"
    vault_crt_base64            = "${md5(base64encode(local.vault_crt))}"
    vault_key_base64            = "${md5(base64encode(tls_private_key.vault.private_key_pem))}"
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.dotenv.rendered}' > ${path.module}/.env"
  }
}
