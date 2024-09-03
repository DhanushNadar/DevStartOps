#!/bin/bash

# Define Node Exporter version and Docker image
NODE_EXPORTER_VERSION="1.5.0"
NODE_EXPORTER_IMAGE="prom/node-exporter:${NODE_EXPORTER_VERSION}"

# Update package lists and install Docker if not already installed
sudo apt-get update -y
sudo apt-get install -y docker.io

# Pull the Node Exporter Docker image
sudo docker pull ${NODE_EXPORTER_IMAGE}

# Run Node Exporter container
sudo docker run -d \
  --name=node-exporter \
  -p 9100:9100 \
  --network=host \
  ${NODE_EXPORTER_IMAGE}

# Print status
echo "Node Exporter installation complete!"
echo "Node Exporter: http://localhost:9100/metrics"
