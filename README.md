# hashistack-demo

The Hashi Stack contained here within provides an environment that can be prepared before going offline to ensure validation and consumption of various elements of the HashiCorp stack.

## Pre-Requisites

**Terraform**
You are required to supply your own `license.rli` file for Terraform Enterprise.

**Vault**
You are required to supply your own Vault Enterprise license file(s) based on the number of nodes you're using. They must be named `vault1.license` and `vault2.license` in the `vault-files` folder.


## Vagrant Deployment Options

There are five total deployment styles. They are as follows:

1. Terraform Enterprise - Single Node
   1. Needs a write up
   2. Needs validation
2. Vault Enterprise - Single Node
   - *Requires vault1.license*
   - To enable a single Vault node please run `vagrant up vault`
   - Run `vagrant ssh vault` to access node
   - Vault keys are located at `/tmp/vaultkeys` and persisted under root. Use `sudo cat /root/vaultkeys` if node is restarted
   - This will result in a initialised vault node that is licensed
3. Vault Enterprise - Additional Node
   - *Requires vault1.license and vault2.license*
   - To enable a two seperate Vault node please run `vagrant up vault vault-dr`
   - Run `vagrant ssh vault` to access node
   - Vault keys are located at `/tmp/vaultkeys` and persisted under root. Use `sudo cat /root/vaultkeys` if node is restarted


