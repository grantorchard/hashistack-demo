# hashistack-demo

The Hashi Stack contained here within provides an environment that can be prepared before going offline to ensure validation and consumption of various elements of the HashiCorp stack.

## Requirements

You are required to supply your own `license.rli` file for Terraform Enterprise.

You are required to supply your own Vault Enterprise license file. The content of `vault.license` should be added within 30 minutes of Vault starting up otherwise it will auto-seal.

You will need to run `vault operator init` to initialise Vault.

**Unsealing Vault**

To initiatlise and unseal vault you will run the following `vagrant ssh vault` and access the given Vault instance.

```
export VAULT_KEYSHARES=5
export VAULT_KEYTHRESHOLDS=3

```

Initlise the Vault cluster with defined key values adn shares.

```
vault operator init -key-shares=$VAULT_KEYSHARES -key-threshold=$VAULT_KEYTHRESHOLDS --format json | jq '.' | cat > ~/vaultkeys
```

The quick method on unsealing based upon defined number in the key thresholds.

```
for i in $( seq 0 $length )
do
       vault operator unseal $(cat ~/vaultkeys | jq -r '.unseal_keys_b64'[$i])
done
```

## Vagrant Deployment Options

There are five total deployment styles. They are as follows:

1. Terraform Enterprise - Single Node
2. Vault Enterprise - Single Node
3.s Vault Enterprise - Additional Node

## Deployment

TBC
