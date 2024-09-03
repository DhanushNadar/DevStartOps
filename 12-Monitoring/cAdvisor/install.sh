#!/bin/bash

# Define cAdvisor version
CADVISOR_VERSION="v0.46.0"

# Define cAdvisor download URL
CADVISOR_URL="https://github.com/google/cadvisor/releases/download/${CADVISOR_VERSION}/cadvisor-${CADVISOR_VERSION}.tar.gz"

# Update package lists
sudo apt-get update -y

# Install dependencies
sudo apt-get install -y wget tar

# Download cAdvisor
wget ${CADVISOR_URL} -O cadvisor.tar.gz

# Extract cAdvisor
tar -xzf cadvisor.tar.gz

# Move cAdvisor binary to /usr/local/bin
sudo mv cadvisor /usr/local/bin/cadvisor

# Create a systemd service file for cAdvisor
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

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable and start the cAdvisor service
sudo systemctl enable cadvisor
sudo systemctl start cadvisor

# Clean up
rm -f cadvisor.tar.gz

# Print status
echo "cAdvisor has been installed and started!"
echo "cAdvisor: http://localhost:8080"
