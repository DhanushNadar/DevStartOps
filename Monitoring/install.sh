#!/bin/bash

# Define versions and URLs
PROMETHEUS_VERSION="2.46.0"
GRAFANA_VERSION="9.5.0"
LOKI_VERSION="2.9.0"
CADVISOR_VERSION="v0.46.0"
NODE_EXPORTER_VERSION="1.6.2"
PROMTAIL_VERSION="2.9.0"

PROMETHEUS_URL="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz"
GRAFANA_URL="https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.amd64.deb"
LOKI_URL="https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip"
CADVISOR_URL="https://github.com/google/cadvisor/releases/download/${CADVISOR_VERSION}/cadvisor-${CADVISOR_VERSION}.tar.gz"
NODE_EXPORTER_URL="https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"
PROMTAIL_URL="https://github.com/grafana/promtail/releases/download/v${PROMTAIL_VERSION}/promtail-linux-amd64.zip"

# Update package lists
sudo apt-get update -y

# Install dependencies
sudo apt-get install -y wget tar unzip

# Install Prometheus
wget ${PROMETHEUS_URL} -O prometheus.tar.gz
tar -xzf prometheus.tar.gz
sudo mv prometheus-${PROMETHEUS_VERSION}/prometheus /usr/local/bin/
sudo mv prometheus-${PROMETHEUS_VERSION}/promtool /usr/local/bin/
sudo mkdir -p /etc/prometheus
sudo mv prometheus-${PROMETHEUS_VERSION}/prometheus.yml /etc/prometheus/
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml
Restart=always

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Install Grafana
wget ${GRAFANA_URL} -O grafana.deb
sudo dpkg -i grafana.deb
sudo apt-get install -f -y
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Install Loki
wget ${LOKI_URL} -O loki.zip
unzip loki.zip
sudo mv loki-linux-amd64 /usr/local/bin/loki
sudo tee /etc/systemd/system/loki.service > /dev/null <<EOF
[Unit]
Description=Loki
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/loki -config.file=/etc/loki/loki-config.yaml
Restart=always

[Install]
WantedBy=multi-user.target
EOF
sudo mkdir -p /etc/loki
sudo tee /etc/loki/loki-config.yaml > /dev/null <<EOF
auth_enabled: false

server:
  http_listen_port: 3100

positions:
  filename: /tmp/positions.yaml

distributor:
  ring:
    kvstore:
      store: inmemory
  shard_by_all_labels: true

ingester:
  chunk_idle_period: 5m
  chunk_target_size: 1048576
  max_chunk_age: 1h
  wal:
    enabled: true
    dir: /loki/wal
  chunk_pool_size: 20
  max_transfer_retries: 10
  max_transfer_retries: 10

storage_config:
  boltdb_shipper:
    active_index_directory: /loki/index
    cache_location: /loki/cache
    shared_store: filesystem
  filesystem:
    directory: /loki/chunks

compactor:
  working_directory: /loki/compactor
  shared_store: filesystem

limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h
EOF
sudo systemctl enable loki
sudo systemctl start loki

# Install cAdvisor
wget ${CADVISOR_URL} -O cadvisor.tar.gz
tar -xzf cadvisor.tar.gz
sudo mkdir -p /usr/local/bin/cadvisor
sudo mv cadvisor /usr/local/bin/cadvisor
sudo tee /etc/systemd/system/cadvisor.service > /dev/null <<EOF
[Unit]
Description=cAdvisor
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/cadvisor -port=8080
Restart=always

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable cadvisor
sudo systemctl start cadvisor

# Install Node Exporter
wget ${NODE_EXPORTER_URL} -O node_exporter.tar.gz
tar -xzf node_exporter.tar.gz
sudo mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Install Promtail
wget ${PROMTAIL_URL} -O promtail.zip
unzip promtail.zip
sudo mv promtail-linux-amd64 /usr/local/bin/promtail
sudo tee /etc/systemd/system/promtail.service > /dev/null <<EOF
[Unit]
Description=Promtail
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/promtail -config.file=/etc/promtail/promtail-config.yaml
Restart=always

[Install]
WantedBy=multi-user.target
EOF
sudo mkdir -p /etc/promtail
sudo tee /etc/promtail/promtail-config.yaml > /dev/null <<EOF
server:
  http_listen_port: 9080

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: system
EOF
sudo systemctl enable promtail
sudo systemctl start promtail

# Clean up
rm -f prometheus.tar.gz grafana.deb loki.zip cadvisor.tar.gz node_exporter.tar.gz promtail.zip

# Print status
echo "Installation complete!"
echo "Prometheus: http://localhost:9090"
echo "Grafana: http://localhost:3000"
echo "Loki: http://localhost:3100"
echo "cAdvisor: http://localhost:8080"
echo "Node Exporter: http://localhost:9100"
echo "Promtail: http://localhost:9080"
