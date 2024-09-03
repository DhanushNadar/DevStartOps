#!/bin/bash

# Define Prometheus version and URL
PROMETHEUS_VERSION="2.46.0"
PROMETHEUS_URL="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz"

# Update package lists
sudo apt-get update -y

# Install dependencies
sudo apt-get install -y wget tar

# Download and install Prometheus
wget ${PROMETHEUS_URL} -O prometheus.tar.gz
tar -xzf prometheus.tar.gz
sudo mv prometheus-${PROMETHEUS_VERSION}/prometheus /usr/local/bin/
sudo mv prometheus-${PROMETHEUS_VERSION}/promtool /usr/local/bin/

# Create configuration directory
sudo mkdir -p /etc/prometheus
sudo mv prometheus-${PROMETHEUS_VERSION}/prometheus.yml /etc/prometheus/

# Create a systemd service file
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

# Enable and start Prometheus service
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Clean up
rm -f prometheus.tar.gz

# Print status
echo "Prometheus installation complete!"
echo "Prometheus: http://localhost:9090"
