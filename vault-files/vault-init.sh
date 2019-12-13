#!/bin/bash
set -x

echo "Running Vault init"

export VAULT_KEYSHARES=5
export VAULT_KEYTHRESHOLDS=3
export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_TOKEN="root"

vault operator init -key-shares=$VAULT_KEYSHARES -key-threshold=$VAULT_KEYTHRESHOLDS --format json | jq '.' | cat > ~/vaultkeys

for i in $( seq 0 $VAULT_KEYTHRESHOLDS )
do
       vault operator unseal $(cat ~/vaultkeys | jq -r '.unseal_keys_b64'[$i])
done

export VAULT_TOKEN=$(cat ~/vaultkeys | jq -r '.root_token')