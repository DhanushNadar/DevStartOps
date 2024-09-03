#!/bin/bash

# Define versions and URLs
LOKI_VERSION="2.9.0"
PROMTAIL_VERSION="2.9.0"
LOKI_URL="https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip"
PROMTAIL_URL="https://github.com/grafana/loki/releases/download/v${PROMTAIL_VERSION}/promtail-linux-amd64.zip"

# Update package lists
sudo apt-get update -y

# Install dependencies
sudo apt-get install -y wget unzip

# Download and install Loki
wget ${LOKI_URL} -O loki.zip
unzip loki.zip
sudo mv loki-linux-amd64 /usr/local/bin/loki
sudo mkdir -p /etc/loki

# Create a Loki configuration file
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

# Create a systemd service file for Loki
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

# Download and install Promtail
wget ${PROMTAIL_URL} -O promtail.zip
unzip promtail.zip
sudo mv promtail-linux-amd64 /usr/local/bin/promtail
sudo mkdir -p /etc/promtail

# Create a Promtail configuration file
sudo tee /etc/promtail/promtail-config.yaml > /dev/null <<EOF
server:
  http_listen_port: 9080

positions:
  filename: /tmp/positions.yaml

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*log
EOF

# Create a systemd service file for Promtail
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

# Reload systemd to apply the new services
sudo systemctl daemon-reload

# Start and enable Loki and Promtail
sudo systemctl start loki
sudo systemctl enable loki
sudo systemctl start promtail
sudo systemctl enable promtail

# Clean up
rm -f loki.zip promtail.zip

# Print status
echo "Loki and Promtail installation complete!"
echo "Loki: http://localhost:3100"
echo "Promtail: http://localhost:9080"
