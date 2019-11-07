# -*- mode: ruby -*-
# vi: set ft=ruby :

# Terraform Enterprise Variables
tfe_ip = ENV['TFE_IP'] || "10.10.0.2"

# Consul variables
consul_host_port = ENV['CONSUL_HOST_PORT'] || 8500
consul_version = ENV['CONSUL_VERSION'] || "1.6.1"
consul_ent_url = ENV['CONSUL_ENT_URL']
consul_group = "consul"
consul_user = "consul"
consul_comment = "Consul"
consul_home = "/srv/consul"

# Vault variables
vault_ip = ENV['VAULT_IP'] || "10.10.0.3"
vault_host_port = ENV['VAULT_HOST_PORT'] || 8200
vault_version = ENV['VAULT_VERSION'] || "1.3.0-beta1+ent"
vault_ent_url = ENV['VAULT_ENT_URL']
vault_group = "vault"
vault_user = "vault"
vault_comment = "Vault"
vault_home = "/srv/vault"


$script  = <<-SCRIPT
echo "Installing Terraform enterprise. Go make yourself a coffee."
curl -s https://install.terraform.io/ptfe/stable | bash -s \
    local-address=#{tfe_ip} \
    public-address=#{tfe_ip} \
    no-proxy \
    no-docker >> null
SCRIPT

$ready = <<-READY
while ! curl -ksfS --connect-timeout 5 https://#{tfe_ip}/_health_check; do
    echo "Querying health check service..... this may take a while"
    sleep 5
done
echo "Your Terraform Enterprise environment is ready! Logon at https://10.10.0.2, or https://tfe.hashicorplabs.com if you have already configured your hosts file."
READY



Vagrant.configure(2) do |config|

    # TFE
    config.vm.define "tfe" do |tfe|
        tfe.vm.provider "virtualbox" do |vb|
            vb.memory = "4096"
            vb.cpus = "2"
        end
        tfe.vm.box = "bento/ubuntu-18.04"
        tfe.vm.network "private_network", ip: tfe_ip
        tfe.vm.hostname = "tfe1"
        tfe.vm.provision "file", source: "files/.", destination: "/tmp"
        tfe.vm.provision "shell", inline: "mv /tmp/replicated.conf /etc/replicated.conf"
        tfe.vm.provision "shell", inline: "chmod 644 /etc/replicated.conf"
        tfe.vm.provision "docker"
        tfe.vm.provision "shell", inline: $script
        tfe.vm.provision "shell", inline: "docker run --detach \
                                                      --hostname gitlab.example.com \
                                                      --publish 8443:443 --publish 8080:80 --publish 8222:22 \
                                                      --name gitlab \
                                                      --restart always \
                                                      --volume /srv/gitlab/config:/etc/gitlab \
                                                      --volume /srv/gitlab/logs:/var/log/gitlab \
                                                      --volume /srv/gitlab/data:/var/opt/gitlab \
                                                      --env GITLAB_OMNIBUS_CONFIG=\"external_url 'https://gitlab.hashicorplabs.com'; letsencrypt['enabled'] = false\" \
                                                        gitlab/gitlab-ce:latest"
        tfe.vm.provision "shell", inline: "sudo snap install ngrok"
        tfe.vm.post_up_message = "
            Your Terraform Enterprise machine has been successfully provisioned!
            Please browse to https://#{tfe_ip}:8800 to track the installation progress of TFE. The console password is Hashicorp1!
            Gitlab is also starting up, and will be accessible at https://10.10.0.2:8443 shortly."
    end

    #Vault
    config.vm.define "vault" do |vault|
        vault.vm.box = "bento/ubuntu-18.04"
        vault.vm.network "private_network", ip: vault_ip
        vault.vm.hostname = "vault"
        vault.vm.provision "shell", inline: "sudo apt -y install unzip"
        vault.vm.provision "shell", inline: "curl https://raw.githubusercontent.com/hashicorp/guides-configuration/master/shared/scripts/base.sh | bash"
        vault.vm.network :forwarded_port, guest: 8200, host: vault_host_port, auto_correct: true
        vault.vm.network :forwarded_port, guest: 8500, host: consul_host_port, auto_correct: true
        vault.vm.provision "shell", inline: "curl https://raw.githubusercontent.com/hashicorp/guides-configuration/master/shared/scripts/setup-user.sh | bash",
            env: {
            "GROUP" => consul_group,
            "USER" => consul_user,
            "COMMENT" => consul_comment,
            "HOME" => consul_home,
            }
        vault.vm.provision "shell", inline: "curl https://raw.githubusercontent.com/hashicorp/guides-configuration/master/consul/scripts/install-consul.sh | bash",
            env: {
            "VERSION" => consul_version,
            "URL" => consul_ent_url,
            "USER" => consul_user,
            "GROUP" => consul_group,
            }        
        vault.vm.provision "shell", inline: "curl https://raw.githubusercontent.com/hashicorp/guides-configuration/master/consul/scripts/install-consul-systemd.sh | bash"   
        vault.vm.provision "shell", inline: "curl https://raw.githubusercontent.com/hashicorp/guides-configuration/master/shared/scripts/setup-user.sh | bash",
            env: {
                "GROUP" => vault_group,
                "USER" => vault_user,
                "COMMENT" => vault_comment,
                "HOME" => vault_home,
            }
        vault.vm.provision "shell", inline: "curl https://raw.githubusercontent.com/hashicorp/guides-configuration/master/vault/scripts/install-vault.sh | bash",
            env: {
                "VERSION" => vault_version,
                "URL" => vault_ent_url,
                "USER" => vault_user,
                "GROUP" => vault_group,
            }
        vault.vm.provision "shell", inline: "curl https://raw.githubusercontent.com/hashicorp/guides-configuration/master/vault/scripts/install-vault-systemd.sh | bash"
        vault.vm.provision "shell", inline: "sudo snap install ngrok"
        vault.vm.post_up_message = "
            Your Vault dev cluster has been successfully provisioned!
            To SSH into a Vault host, run the below command.
              $ vagrant ssh
            You can interact with Vault using any of the CLI (https://www.vaultproject.io/docs/commands/index.html)
            or API (https://www.vaultproject.io/api/index.html) commands.
              # The Root token for your Vault -dev instance is set to `root` and placed in /srv/vault/.vault-token,
              # the `VAULT_TOKEN` environment variable has already been set for you
              $ echo $VAULT_TOKEN
              $ sudo cat /srv/vault/.vault-token
              # Use the CLI to write and read a generic secret
              $ vault kv put secret/cli foo=bar
              $ vault kv get secret/cli
              # Use the API to write and read a generic secret
              $ curl -H \"X-Vault-Token: $VAULT_TOKEN\" -X POST -d '{\"data\": {\"bar\":\"baz\"}}' http://127.0.0.1:8200/v1/secret/data/api | jq '.'
              $ curl -H \"X-Vault-Token: $VAULT_TOKEN\" http://127.0.0.1:8200/v1/secret/data/api | jq '.'
            Visit the Vault UI: http://#{vault_ip}:#{vault_host_port}
            Don't forget to tear your VM down after.
              $ vagrant destroy
            "
    end
end

    


