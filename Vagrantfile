
Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.define "web1" do |web1|
    web1.vm.network "forwarded_port", guest: 80, host: 8080
    web1.vm.network "public_network"
    web1.vm.provision "shell", path: "provision_shared_apache.sh"
  end

  config.vm.define "web2" do |web2|
    #web2.vm.network "forwarded_port", guest: 80, host: 8080
    web2.vm.network "public_network"
    #web2.vm.provision "shell", path: "provision_shared_apache.sh"
  end
end
