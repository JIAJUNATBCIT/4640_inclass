Vagrant.configure("2") do |config|
  config.vm.box = "4640BOX"
  config.ssh.username = "admin"
  config.ssh.private_key_path = "files/acit_admin_id_rsa"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Setup 3 VMs
  # Nginx - 192.168.150.30
  # Mongodb - 192.168.150.20
  # todoapp - 192.168.150.10
  config.vm.define "TODO_NGINX_4640" do |todoapp|
    todoapp.vm.provider "virtualbox" do |vb|
      vb.name = "TODO_NGINX_4640"
      vb.memory = 1536
  end
  todoapp.vm.hostname = "TODO_NGINX_4640"
  todoapp.vm.network "private_network", ip: "192.168.150.30"
  todoapp.vm.network "forwarded_port", guest: 80, host: 8888
  todoapp.vm.provision "file", source: "files/nginx.conf", destination: "/tmp/nginx.conf"
  config.vm.provision "shell", inline: <<-SHELL
      dnf install -y nginx
      mv /tmp/nginx.conf /etc/nginx/nginx.conf
      systemctl enable nginx
      systemctl start nginx
  SHELL

  config.vm.define "TODO_DB_4640" do |tododb|
    tododb.vm.provider "virtualbox" do |vb|
      vb.name = "TODO_DB_4640"
      vb.memory = 1536
  end
  todoapp.vm.hostname = "TODO_DB_4640"
  todoapp.vm.network "private_network", ip: "192.168.150.20"
  todoapp.vm.provision "file", source: "files/mongodb_ACIT4640.tgz", destination: "/tmp/mongodb_ACIT4640.tgz"
  todoapp.vm.provision "file", source: "files/mongo.repo", destination: "/tmp/mongo.repo"
  config.vm.provision "shell", inline: <<-SHELL
      mv /tmp/mongo.repo /etc/yum.repos.d/mongodb-org-4.4.repo
      dnf install -y mongodb-org
      systemctl enable mongod
      systemctl start mongod
      mongo --eval "db.createCollection('ACIT4640')"
      export LANG=C
      tar zxf /tmp/mongodb_ACIT4640.tgz ~/mongodb_ACIT4640
      mongorestore -d ACIT4640 ~/mongodb_ACIT4640
      # create mongodb instance
      mongo --eval "db.createCollection('acit4640')"
  SHELL

  config.vm.define "TODO_APP_4640" do |todoapp|
    todoapp.vm.provider "virtualbox" do |vb|
      vb.name = "TODO_APP_4640"
      vb.memory = 2048
  end
  todoapp.vm.hostname = "TODO_APP_4640"
  todoapp.vm.network "private_network", ip: "192.168.150.10"
  todoapp.vm.provision "file", source: "files/todoapp.service", destination: "/tmp/todoapp.service"
  todoapp.vm.provision "file", source: "files/install.sh", destination: "/tmp/install.sh"
  config.vm.provision "shell", inline: <<-SHELL
    bash /tmp/install.sh
    # Reload and start todoapp Deamon
    systemctl daemon-reload
    systemctl enable todoapp
       start todoapp
  SHELL
end