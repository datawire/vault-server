region = "us-central1"
project = "datawireio-cloud"
zone = "us-central1-a"
vault_server_count = 3
vault_init_crypto_key_id = "us-central1/vault/vault-init"

node_labels = {
  "datawire.io/team"        = "syseng"
  "datawire.io/env"         = "prd"
  "datawire.io/terraformed" = "true"
}
