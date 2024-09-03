#!/bin/bash

# Define Node Exporter version and URLs
NODE_EXPORTER_VERSION="1.5.1"
NODE_EXPORTER_URL="https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"

# Update package lists
sudo apt-get update -y

# Install dependencies
sudo apt-get install -y wget tar

# Download and install Node Exporter
wget ${NODE_EXPORTER_URL} -O node_exporter.tar.gz
tar -xzf node_exporter.tar.gz
sudo mv node_exporter-${NODE_EXPORTER_VERSION}/node_exporter /usr/local/bin/

# Create a system user for Node Exporter
sudo useradd --no-create-home --shell /bin/false node_exporter

# Create a systemd service file for Node Exporter
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to apply the new service
sudo systemctl daemon-reload

# Start and enable Node Exporter
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

# Clean up
rm -f node_exporter.tar.gz

# Print status
echo "Node Exporter installation complete!"
echo "Node Exporter: http://localhost:9100/metrics"
