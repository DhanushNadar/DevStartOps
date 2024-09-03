#!/bin/bash

# Define Grafana version
GRAFANA_VERSION="9.5.0"

# Define Grafana download URL
GRAFANA_URL="https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.amd64.deb"

# Update package lists
sudo apt-get update -y

# Install dependencies
sudo apt-get install -y wget

# Download Grafana
wget ${GRAFANA_URL} -O grafana.deb

# Install Grafana
sudo dpkg -i grafana.deb

# Fix dependencies if needed
sudo apt-get install -f -y

# Enable and start Grafana service
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Print status
echo "Grafana has been installed and started!"
echo "Grafana: http://localhost:3000"
