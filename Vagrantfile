# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "opscode-ubuntu-12.04.box"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-12.04.box"

  config.vm.network :hostonly, "192.168.33.12"
  config.vm.host_name = "subversion"  

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = [ "./cookbooks", ".." ]
    chef.data_bags_path = "./test/kitchen/data_bags"

    chef.add_recipe "vagrant-ohai"
    chef.add_recipe "subversion::server"
    
    chef.json = { }
    chef.log_level = :debug
  end
end
