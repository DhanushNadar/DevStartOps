#!/bin/bash

# Define Grafana version
GRAFANA_VERSION="9.5.0"

# Define Grafana image
GRAFANA_IMAGE="grafana/grafana:${GRAFANA_VERSION}"

# Pull the Grafana Docker image
docker pull ${GRAFANA_IMAGE}

# Run Grafana container
docker run -d \
  --name=grafana \
  -p 3000:3000 \
  -v grafana-storage:/var/lib/grafana \
  ${GRAFANA_IMAGE}

# Print status
echo "Grafana has been installed and started!"
echo "Grafana: http://localhost:3000"
