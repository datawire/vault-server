# Managed Vault to Kubernetes synchronized Secrets

Secrets put into a specific key space in Vault are automatically synchronized to Kubernetes clusters running the sync program.

## Notes

- The sync program is [VaultingKube](https://github.com/sunshinekitty/vaultingkube) which is only compatible with v1 storage engines in Vault. The tool works but has a bunch of issues. It is fairly straightforward code and could either be forked or rewritten easily enough.
- Vault is a general purpose secrets storage and transmission system and as such it lacks a good UX around Kuberetes. If the setup here feels painful... it is.

# Adding Secrets

The vaultingkube integration requires secrets and config data be stored at the following keyspace: `vaultkube/clusters/${NAMESPACE}/[configmaps|secrets]`. The `${NAMESPACE}` determines which Kubernetes Namespace a `ConfigMap` or `Secret` will appear in.

For example, with Metriton we have `vaultkube/clusters/${NAMESPACE}/[configmaps|secrets]`.

## Create a Secrets Keyspace

`vault secrets enable -version=1  vaultkube/clusters/${NAMESPACE}/secrets`

## (Optional) Create a ConfigMaps Keyspace

`vault secrets enable -version=1  vaultkube/clusters/${NAMESPACE}/configmaps`

## Create a Secret named `MySecret`

`vault kv put vaultkube/clusters/${NAMESPACE}/secrets/MySecret foo=bar baz=bot`

## Create a Secret named `MySecret` with the contents of a file in one of the keys

`vault kv put vaultkube/clusters/${NAMESPACE}/secrets/MySecret foo=@/path/to/your-secret`
