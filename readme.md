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


-----------



---for daily startup
consul agent -dev
sudo nomad agent -dev-connect
nomad job run scale.nomad.hcl

(delete job)
nomad job stop -purge scale  


nomad job run autoscaler.nomad
nomad job run prometheus.nomad
nomad job run webapp.nomad
nomad job run traefik.nomad


scalar(nomad_nomad_job_summary_running{exported_job="webapp",task_group="demo"})

scalar(nomad_nomad_job_summary_running{exported_job="wordpress-app",task_group="wordpress-group"})


avg(nomad_client_allocs_memory_allocated{exported_job="wordpress-app",task_group="wordpress-group"})

avg(nomad_client_allocs_memory_usage{exported_job="wordpress-app"})



nomad job run autoscaler.nomad
nomad job run prometheus.nomad

nomad job run grafana.nomad
nomad job run loki.nomad

nomad job run scale.nomad.hcl


for working autoscle (
nomad job run autoscaler.nomad
nomad job run prometheus.nomad
nomad job run scale.nomad.hcl
)

  <!-- config.vm.network "forwarded_port", guest: 3000, host: 3000, host_ip: "127.0.0.1:3000"    # Grafana
  config.vm.network "forwarded_port", guest: 4646, host: 4646, host_ip: "127.0.0.1:4646"    # Nomad
  config.vm.network "forwarded_port", guest: 8000, host: 8000, host_ip: "127.0.0.1:8000"    # Demo webapp
  config.vm.network "forwarded_port", guest: 8081, host: 8081, host_ip: "127.0.0.1:8081"    # Traefik admin
  config.vm.network "forwarded_port", guest: 9090, host: 9090, host_ip: "127.0.0.1:9090"    # Prometheus -->

http://127.0.0.1:3000 Grafana
http://127.0.0.1:8081 Traefik
http://127.0.0.1:9090 Prometheus

hey -c 100 -z 30s http://213.165.232.20:20141


https://developer.hashicorp.com/nomad/docs/operations/metrics-reference
https://developer.hashicorp.com/nomad/docs/configuration/telemetry

http://213.165.232.33:4646/v1/metrics?format=prometheus

```
1.in nomad.hcl  in all the vms add 
telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
  prometheus_metrics         = true
}
restart nomad in all the vms 

2.make sure there is no error (e.g  connecting error) in autoscaler logs
3.check the prometheus graph with your query. it should not be empty.
```

# loads nomad with our defined config
sudo nomad agent -dev-connect -config=/etc/nomad.d

http://192.168.1.25:3000/d/8QlvShyZz/nomad-autoscaler-demo?orgId=1&refresh=5s