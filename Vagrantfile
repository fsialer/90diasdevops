Vagrant.configure("2") do |config|
    config.vm.box= "ubuntu/jammy64"
    
    config.vm.define 'docker' do |docker|
        docker.vm.network "private_network",ip: "192.168.10.11"
        docker.vm.provider "virtualbox" do |v|
            v.memory = 2024
            v.cpus = 4 
        end
        docker.vm.provision "setup_docker", type:"shell", path:"./scripts/setup.sh"
        config.vm.provision "shell", inline: <<-SHELL
            docker stop app
            docker rm app
            docker compose down
            mkdir -p /home/vagrant/app
            cp -r /vagrant/app/* /home/vagrant/app/ > /dev/null 2>&1
            cd ./app
            docker compose up -d
        SHELL
        docker.vm.provision "setup_docker", type:"shell", path:"./scripts/check-app.sh"

    end
end