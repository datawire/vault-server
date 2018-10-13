data "google_container_engine_versions" "latest" {
  project = "${var.project}"
  zone    = "${var.zone}"
}

# Create a network to contain the vault cluster
resource "google_compute_network" "cluster_network" {
  auto_create_subnetworks = true
  name                    = "vault"
  description             = "vault server network"
  project                 = "${var.project}"
  routing_mode            = "REGIONAL"
}

# Create the vault service account
resource "google_service_account" "vault_server" {
  account_id   = "vault-server"
  display_name = "Vault Server"
  project      = "${var.project}"
}

# Create a service account key
resource "google_service_account_key" "vault" {
  service_account_id = "${google_service_account.vault_server.name}"
}

# Add the service account to the project
resource "google_project_iam_member" "service_account" {
  count   = "${length(var.service_account_iam_roles)}"
  project = "${var.project}"
  role    = "${element(var.service_account_iam_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.vault_server.email}"
}

# Enable required services on the project
resource "google_project_service" "service" {
  count              = "${length(var.project_services)}"
  project            = "${var.project}"
  service            = "${element(var.project_services, count.index)}"
  disable_on_destroy = false
}

# Create the storage bucket
resource "google_storage_bucket" "vault" {
  name          = "${var.project}-vault-storage"
  project       = "${var.project}"
  force_destroy = true
  storage_class = "MULTI_REGIONAL"

  versioning {
    enabled = true
  }

  depends_on = ["google_project_service.service"]
}

# Grant service account access to the storage bucket
resource "google_storage_bucket_iam_member" "vault_server" {
  count  = "${length(var.storage_bucket_roles)}"
  bucket = "${google_storage_bucket.vault.name}"
  role   = "${element(var.storage_bucket_roles, count.index)}"
  member = "serviceAccount:${google_service_account.vault_server.email}"
}

# Grant service account access to the key
resource "google_kms_crypto_key_iam_member" "vault_init" {
  count         = "${length(var.kms_crypto_key_roles)}"
  crypto_key_id = "${local.tf_vault_init_crypto_key_id}"
  role          = "${element(var.kms_crypto_key_roles, count.index)}"
  member        = "serviceAccount:${google_service_account.vault_server.email}"
}

# Create the GKE cluster
resource "google_container_cluster" "vault" {
  name               = "vault"
  project            = "${var.project}"
  zone               = "${var.zone}"
  initial_node_count = "${var.vault_server_count}"
  logging_service    = "logging.googleapis.com/kubernetes"
  min_master_version = "${data.google_container_engine_versions.latest.latest_master_version}"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  network            = "${google_compute_network.cluster_network.self_link}"
  node_version       = "${data.google_container_engine_versions.latest.latest_node_version}"

  master_auth {
    password = ""
    username = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    disk_size_gb    = "${var.node_disk_size_gb}"
    disk_type       = "${var.node_disk_type}"
    labels          = "${var.node_labels}"
    image_type      = "${var.node_image_type}"
    machine_type    = "${var.node_machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/iam",
    ]

    preemptible     = false
    service_account = "${google_service_account.vault_server.email}"
    tags            = ["vault"]

    workload_metadata_config {
      node_metadata = "EXPOSE"
    }
  }

  depends_on = ["google_project_service.service"]
  timeouts {
    // Generous Update Timeout
    //
    // Masters takes ~5min
    // Workers take about 4-7 minutes each (and possibly longer depending on disruption budgets and load)
    update = "${var.vault_server_count * 15}m"
  }
}

resource "google_compute_address" "vault" {
  name    = "vault-lb"
  region  = "${var.region}"
  project = "${var.project}"

  depends_on = ["google_project_service.service"]
}
