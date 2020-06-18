ptfe_int_ip = "192.168.56.33"
ptfe_ext_ip = ptfe_int_ip 
proxy_int_ip = "192.168.56.10"

Vagrant.configure("2") do |config|

  config.vm.define "proxy" do |proxy|
    proxy.vm.box = "slavrd/bionic64"

    proxy.vm.hostname = "tfe-proxy"
    proxy.vm.network "private_network", ip: proxy_int_ip
    proxy.vm.provision "shell" do |s|
      s.path = "scripts/install_squid_proxy.sh"
    end 

  end
 
  config.vm.define "tfe" do |tfe|

    tfe.vm.box = "slavrd/docker"
    tfe.vm.box_version = "19.03.8"
    
    tfe.vm.hostname = "ptfe"
    tfe.vm.network "private_network", ip: ptfe_int_ip
    tfe.vm.provider "virtualbox" do |v|
      v.memory = 1024 * 6
      v.cpus = 2
    end

    tfe.vm.provision "shell" do |s|
      s.path = "scripts/install_tfe_online.sh"
      s.privileged = true
      s.env = { PTFE_PRIVATE_IP: ptfe_int_ip, 
                PTFE_PUBLIC_IP: ptfe_ext_ip, 
                PROXY_ADDR: "http://#{proxy_int_ip}:3128"
              } 
    end 
  end
  
end
