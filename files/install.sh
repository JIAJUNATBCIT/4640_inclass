#!/bin/bash -x
DIR="/home/todoapp/ACIT4640-todo-app"
#add todoapp user
sudo useradd todoapp
#set password to todoapp user
sudo sh -c 'echo P@ssw0rd | passwd todoapp --stdin'
# navigate to the todoapp home
cd /home/todoapp/
# If the project folder already exists, DELETE it
if [ -d "./ACIT4640-todo-app" ]; then sudo rm -Rf "./ACIT4640-todo-app"; fi
# clone project from git to current folder
sudo git clone https://github.com/timoguic/ACIT4640-todo-app.git
# navigate to the project folder
cd ./ACIT4640-todo-app
# install project packages
sudo npm install
# Reconfig MongoDB path
sudo rm -rf $DIR/config/database.js
sudo cat <<EOF > database.js
module.exports = {
    url: 'mongodb://192.168.150.20/ACIT4640'
}; 
EOF
sudo mv database.js $DIR/config/
# disable SE Linux
sudo setenforce 0
sudo sed -r -i 's/SELINUX=(enforcing|disabled)/SELINUX=permissive/' /etc/selinux/config
# Adjust todoapp home folder permission
cd ~
sudo chmod a+rx /home/todoapp/
sudo chown todoapp:todoapp /home/todoapp/ACIT4640-todo-app/
