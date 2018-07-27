output "project" {
  value = "${var.project}"
}

output "zone" {
  value = "${var.zone}"
}

output "region" {
  value = "${var.region}"
}

output "address" {
  value = "${google_compute_address.vault.address}"
}

output "vault_server_count" {
  value = "${var.vault_server_count}"
}

output "vault_dotenv" {
  value = "${data.template_file.dotenv.rendered}"
}
