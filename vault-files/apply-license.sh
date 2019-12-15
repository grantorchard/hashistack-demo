#!/bin/bash
set -x

echo "Applying Vault license"

VAULT_LICENSE=$(<vault1.license)

JSON_STRING=$( jq -n \
                  --arg vl "$VAULT_LICENSE" \
                  '{text: $vl}' )

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    -H "Content-Type: application/json" \
    -d '{"text":"'$VAULT_LICENSE'"}' \
    http://127.0.0.1:8200/v1/sys/license

