https://developer.hashicorp.com/nomad/docs/integrations/consul-connect
This project use consul, nomad and envoy. 
works on local. vagrant is not used
pre requisite: install nomad and consul on local 


consul agent -dev

sudo nomad agent -dev-connect

curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v1.0.0/cni-plugins-linux-$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-v1.0.0.tgz
sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz



echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-arptables
echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-ip6tables
echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables


nomad job run servicemesh.nomad.hcl
nomad job run wordpress.nomad.hcl
nomad job run phpmyadmin.nomad.hcl
nomad job run mysql.nomad.hcl

open http://192.168.1.25:9002/  ()
http://localhost:8500   (consul ui)
http://localhost:4646/  (nomad ui)

http://localhost:80  (wordpress)  will open http://192.168.1.25/wp-admin/setup-config.php

http://localhost:80 (phpmyadmin)

mysql -u root -padmin  (mysql)