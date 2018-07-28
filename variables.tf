variable "project" {
  description = "Google Cloud project that contains the vault cluster"
}

variable "project_services" {
  type = "list"
  description = "List of project services that need to be enabled"
  default = [
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
  ]
}

variable "region" {
  description = "Google Cloud region where the cluster is running"
}

variable "service_account_iam_roles" {
  type = "list"
  description = "List of IAM roles that need to be enabled for the vault service account"
  default = [
    "roles/resourcemanager.projectIamAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/iam.serviceAccountTokenCreator",
    "roles/iam.serviceAccountUser",
    "roles/viewer",
  ]
}

variable "storage_bucket_roles" {
  type = "list"
  description = "List of storage bucket roles that need to be enabled"
  default = [
    "roles/storage.legacyBucketReader",
    "roles/storage.objectAdmin",
  ]
}

variable "kms_crypto_key_roles" {
  type = "list"
  default = [
    "roles/cloudkms.cryptoKeyEncrypterDecrypter",
  ]
}

variable "keyring_location" {
  description = "location of the Google Cloud KMS keyring"
  default = "global"
}

variable "keyring_name" {
  description = "name of the Google Cloud KMS keyring"
  default = "vault"
}

variable "vault_init_crypto_key_name" {
  description = "name of the vault-init Google Cloud KMS crypto key"
  default = "vault-init"
}

variable "vault_server_count" {
  description = "Number of vault servers (also kubernetes nodes)"
  default = 3
}

variable "zone" {
  description = "Google Cloud zone where the cluster is running"
}

// -----------------------------------------------------------------------------
// Default Node Pool Configuration
//
// These should not need to be configured but they are exposed just in case.
// -----------------------------------------------------------------------------

variable "node_disk_size_gb" {
  default = 10
}

variable "node_disk_type" {
  default = "pd-standard"
}

variable "node_image_type" {
  default = "COS"
}

variable "node_labels" {
  type        = "map"
  description = "Map of key/value pairs to label Nodes with. These will propogate into Kubernetes as Node Labels"
  default     = {}
}

variable "node_machine_type" {
  description = "Name of the Google Compute Engine machine type"
  default = "n1-standard-2"
}
