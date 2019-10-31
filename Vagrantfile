# -*- mode: ruby -*-
# vi: set ft=ruby :

$script  = <<-SCRIPT
echo "Installing Terraform enterprise. Go make yourself a coffee."
curl -s https://install.terraform.io/ptfe/stable | bash -s \
    local-address=10.10.0.2 \
    public-address=10.10.0.2 \
    no-proxy \
    no-docker >> null
SCRIPT

$ready = <<-READY
while ! curl -ksfS --connect-timeout 5 https://10.10.0.2/_health_check; do
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
        tfe.vm.network "private_network", ip: "10.10.0.2"
        tfe.vm.hostname = "tfe1"
        tfe.vm.provision "docker"
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
        tfe.vm.provision "file", source: "files/.", destination: "/tmp"
        tfe.vm.provision "shell", inline: "mv /tmp/replicated.conf /etc/replicated.conf"
        tfe.vm.provision "shell", inline: "chmod 644 /etc/replicated.conf"
        tfe.vm.provision "shell", inline: $script
    end
end

    


