#!/bin/bash

# Define Prometheus version and Docker image
PROMETHEUS_VERSION="2.46.0"
PROMETHEUS_IMAGE="prom/prometheus:${PROMETHEUS_VERSION}"

# Update package lists and install Docker if not already installed
sudo apt-get update -y
sudo apt-get install -y docker.io

# Pull the Prometheus Docker image
sudo docker pull ${PROMETHEUS_IMAGE}

# Create Prometheus configuration directory
sudo mkdir -p /etc/prometheus

# Create a default Prometheus configuration file
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF

# Run Prometheus container
sudo docker run -d \
  --name=prometheus \
  -p 9090:9090 \
  -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
  ${PROMETHEUS_IMAGE}

# Print status
echo "Prometheus installation complete!"
echo "Prometheus: http://localhost:9090"
