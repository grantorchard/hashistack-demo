#!/bin/bash
set -x

## refresh root token
export VAULT_TOKEN=$(sudo cat /root/vaultkeys | jq -r '.root_token')
export 
## define download
PLUGIN_URI=https://github.com/sethvargo/vault-secrets-gen/releases/download/v0.0.4/vault-secrets-gen__linux_amd64.zip
echo "Downloading and preparing custom Vault plugin to cluster"
# Download, unzip, move, and ready
sudo curl -LO $PLUGIN_URI
unzip vault-secrets-gen__linux_amd64.zip -d /tmp
sudo mkdir /etc/vault.d/plugins/
sudo mv /tmp/vault-secrets-gen /etc/vault.d/plugins/
# get SHA256 value
export SHA256=$(shasum -a 256 "/etc/vault.d/plugins/vault-secrets-gen" | cut -d' ' -f1)
## Add to vault
echo "Importing into Vault"
vault write sys/plugins/catalog/secret/secrets-gen \
    sha_256="${SHA256}" \
    command="vault-secrets-gen"
## Enable plugin/engine
echo "Enabling plugin"
vault secrets enable \
    -path="gen" \
    -plugin-name="secrets-gen" \
    plugin

vault write gen/password length=36 symbols=5

vault write gen/passphrase words=5
