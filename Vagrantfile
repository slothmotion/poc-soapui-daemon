# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.ssh.shell				= "bash"
  config.ssh.forward_agent		= true
  
  # proxy configuration
  HTTP_PROXY = ENV['HTTP_PROXY'] ? ENV['HTTP_PROXY'] : ENV['http_proxy']
  HTTPS_PROXY = ENV['HTTPS_PROXY'] ? ENV['HTTPS_PROXY'] : ENV['https_proxy']
  
  if Vagrant.has_plugin?("vagrant-proxyconf") && (HTTP_PROXY || HTTPS_PROXY)
    config.proxy.http     = HTTP_PROXY
    config.proxy.https    = HTTPS_PROXY ? HTTPS_PROXY : HTTP_PROXY
    config.proxy.no_proxy = "localhost,127.0.0.1"
  end

  config.vm.boot_timeout = 300

  config.vm.define "vbox" do |vb|

    vb.vm.box = "centos/7"
    vb.vm.box_version = "1905.1"
	vb.vm.hostname = "vbox"

    vb.vm.provider "virtualbox" do |p|
      p.name = "VBoxVM"
      p.memory = "4096"
      p.cpus = 1

      # disabling the logging into Vagrantfile's parent folder
      p.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
    end

  end

  #config.vm.synced_folder '.', '/vagrant', nfs: true
  #config.vm.network "forwarded_port", guest: 22, host: 2222, host_ip: "127.0.0.1", id: 'ssh'
  
  config.vm.network "forwarded_port", guest: 8088, host: 8088
  
  config.vm.provision "shell", path: "./provision/install_utilities.sh"
  config.vm.provision "shell", path: "./provision/install_soapui.sh"
  
end
