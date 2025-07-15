Vagrant.configure("2") do |config|
    config.vm.box= "ubuntu/jammy64"
    
    config.vm.define 'docker' do |docker|
        docker.vm.network "private_network",ip: "192.168.10.11"
        docker.vm.provider "virtualbox" do |v|
            v.memory = 2024
            v.cpus = 4 
        end
        docker.vm.provision "setup_docker", type:"shell", path:"./scripts/setup.sh"
    end
end