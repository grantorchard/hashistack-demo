#!/bin/bash
set -x

echo "Running Vault init"

export VAULT_KEYSHARES=5
export VAULT_KEYTHRESHOLDS=3
export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_TOKEN="root"
export VAULT_LICENSE_FILE1="/tmp/vault1.license"
export VAULT_LICENSE_FILE2="/tmp/vault2.license"

vault operator init -key-shares=$VAULT_KEYSHARES -key-threshold=$VAULT_KEYTHRESHOLDS --format json | jq '.' | cat > ~/vaultkeys

for i in $( seq 0 $VAULT_KEYTHRESHOLDS )
do
       vault operator unseal $(cat ~/vaultkeys | jq -r '.unseal_keys_b64'[$i])
done

sudo cp /root/vaultkeys ~/
sudo cp /root/vaultkeys /tmp/

export VAULT_TOKEN=$(cat ~/vaultkeys | jq -r '.root_token')


echo "Checking if Vault license exists"

if test -e "$VAULT_LICENSE_FILE1"; 
then
       echo "License found; Applying Vault license to VAULT 1"
       VAULT_LICENSE=$(cat /tmp/vault1.license)

       curl \
       --header "X-Vault-Token: $VAULT_TOKEN" \
       --request POST \
       -H "Content-Type: application/json" \
       -d '{"text":"'$VAULT_LICENSE'"}' \
       http://127.0.0.1:8200/v1/sys/license
fi

if test -e "$VAULT_LICENSE_FILE2";  
then
       echo "License found; Applying Vault license to VAULT 2 (DR)"
       VAULT_LICENSE=$(cat /tmp/vault2.license)

       curl \
       --header "X-Vault-Token: $VAULT_TOKEN" \
       --request POST \
       -H "Content-Type: application/json" \
       -d '{"text":"'$VAULT_LICENSE'"}' \
       http://127.0.0.1:8200/v1/sys/license
fi
