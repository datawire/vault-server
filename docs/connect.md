# Connect to the Vault Server

## Get master token

1. Set `PROJECT_ID` environment variable to the ID of the Google Cloud project.

    `export PROJECT_ID=`
   
2. Set `GCS_BUCKET_NAME` environment variable to the name of the vault storage Google Cloud Storage bucket.

    `export GCS_BUCKET_NAME=datawireio-cloud-vault-storage`
    
3. Run `tools/get-vault-token.sh`

## Connect to the Vault Server

1. `source vault.env`
2. `vault login`

A success message and some technical stuff get dumped to `STDOUT`.

```text
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                REDACTED
token_accessor       REDACTED
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
```
