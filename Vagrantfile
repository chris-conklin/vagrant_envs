
Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"


  config.vm.network "forwarded_port", guest: 80, host: 8080


  config.vm.network "public_network"


  config.vm.provision "shell", path: "provision_shared_apache.sh"

end
