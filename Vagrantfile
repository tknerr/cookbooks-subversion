# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "ubuntu-12.04-server-amd64-vagrant.box"
  config.vm.box_url = "W:\\boxes\\ubuntu-12.04-server-amd64-vagrant.box"


  config.vm.network :hostonly, "192.168.33.12"
  config.vm.host_name = "camp-svn"
  
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ".."
    chef.data_bags_path = "..\\..\\my-chef-repo\\data_bags"
    chef.add_recipe "vagrant-ohai"
    chef.add_recipe "subversion::server"
  end
end
