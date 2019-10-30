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
echo "Your Terraform Enterprise environment is ready! Logon at https://10.10.0.2, or https://tfe.hashidemos.local if you have already configured your hosts file."
READY

$gitlab = <<-GITLAB
    sudo apt-get update
    sudo apt-get install -y curl openssh-server ca-certificates
    curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
    sudo EXTERNAL_URL="https://gitlab.hashidemos.local" apt-get install gitlab-ee
GITLAB

Vagrant.configure(2) do |config|
    config.vm.box = "bento/ubuntu-18.04"
    config.vm.provider "virtualbox" do |vb|
        vb.memory = "4096"
        vb.cpus = "2"
    end

    # TFE
    config.vm.define "tfe" do |tfe|
        tfe.vm.network "private_network", ip: "10.10.0.2"
        tfe.vm.hostname = "tfe1"
        tfe.vm.provision "docker"
        tfe.vm.provision "file", source: "files/.", destination: "/tmp"
        tfe.vm.provision "shell", inline: "mv /tmp/replicated.conf /etc/replicated.conf"
        tfe.vm.provision "shell", inline: "chmod 644 /etc/replicated.conf"
        tfe.vm.provision "shell", inline: $script
        #tfe.vm.provision "shell", inline: $ready
    end

    # Gitlab
    config.vm.define "gitlab" do |gitlab|
        gitlab.vm.network "private_network", ip: "10.10.0.3"
        gitlab.vm.hostname = "gitlab"
        gitlab.vm.provision "shell", inline: $gitlab
    end
end
    


