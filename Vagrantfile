Vagrant.configure("2") do |config|
  config.vm.box = "4640BOX"
  config.ssh.username = "admin"
  config.ssh.private_key_path = "files/acit_admin_id_rsa"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Setup 3 VMs
  # Nginx - 192.168.150.30
  # Mongodb - 192.168.150.20
  # todoapp - 192.168.150.10
  config.vm.define "TODO_NGINX_4640" do |todoweb|
    todoweb.vm.provider "virtualbox" do |vb|
      vb.name = "TODO_NGINX_4640"
      vb.memory = 1536
    end
    todoweb.vm.hostname = "todo.nginx"
    todoweb.vm.network "private_network", ip: "192.168.150.30"
    todoweb.vm.network "forwarded_port", guest: 80, host: 8888
    todoweb.vm.provision "file", source: "files/nginx.conf", destination: "/tmp/nginx.conf"
    todoweb.vm.provision "shell", inline: <<-SHELL
      mv /tmp/nginx.conf /etc/nginx/
      dnf install -y nginx
      systemctl enable nginx
      systemctl start nginx
    SHELL
  end

  config.vm.define "TODO_DB_4640" do |tododb|
    tododb.vm.provider "virtualbox" do |vb|
      vb.name = "TODO_DB_4640"
      vb.memory = 1536
    end
    tododb.vm.hostname = "todo.db"
    tododb.vm.network "private_network", ip: "192.168.150.20"
    tododb.vm.provision "file", source: "files/mongodb_ACIT4640.tgz", destination: "/tmp/mongodb_ACIT4640.tgz"
    tododb.vm.provision "file", source: "files/mongo.repo", destination: "/tmp/mongodb-org-4.4.repo"
    tododb.vm.provision "shell", inline: <<-SHELL
      mv /tmp/mongodb-org-4.4.repo /etc/yum.repos.d/
      yum install -y tar
      yum install -y mongodb-org
      systemctl enable mongod
      systemctl start mongod
      mongo --eval "db.createCollection('ACIT4640')"
      export LANG=C
      mkdir /home/admin/mongodb_ACIT4640
      mv /tmp/mongodb_ACIT4640.tgz /home/admin/mongodb_ACIT4640
      tar zxf /home/admin/mongodb_ACIT4640/mongodb_ACIT4640.tgz
      mongorestore -d ACIT4640 /home/admin/mongodb_ACIT4640
    SHELL
  end

  config.vm.define "TODO_APP_4640" do |todoapp|
    todoapp.vm.provider "virtualbox" do |vb|
      vb.name = "TODO_APP_4640"
      vb.memory = 2048
    end
    todoapp.vm.hostname = "todo.app"
    todoapp.vm.network "private_network", ip: "192.168.150.10"
    todoapp.vm.provision "file", source: "files/todoapp.service", destination: "/tmp/todoapp.service"
    todoapp.vm.provision "file", source: "files/install.sh", destination: "/tmp/install.sh"
    todoapp.vm.provision "shell", inline: <<-SHELL
      mv /tmp/install.sh /home/admin/
      mv /tmp/todoapp.service /etc/systemd/system/
      curl https://raw.githubusercontent.com/dvershinin/apt-get-centos/master/apt-get.sh -o /usr/local/bin/apt-get
      chmod 0755 /usr/local/bin/apt-get
      curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
      dnf install -y git nodejs
      bash /home/admin/install.sh
      # Reload and start todoapp Deamon
      systemctl daemon-reload
      systemctl enable todoapp
      systemctl start todoapp
    SHELL
  end
end