#!/bin/bash

# Define Loki and Promtail versions
LOKI_VERSION="2.9.0"
PROMTAIL_VERSION="2.9.0"

# Define Docker images
LOKI_IMAGE="grafana/loki:${LOKI_VERSION}"
PROMTAIL_IMAGE="grafana/promtail:${PROMTAIL_VERSION}"

# Create directories for Loki and Promtail configuration
mkdir -p ~/loki-config
mkdir -p ~/promtail-config

# Download Loki configuration
wget https://raw.githubusercontent.com/grafana/loki/v${LOKI_VERSION}/cmd/loki/loki-local-config.yaml -O ~/loki-config/loki-config.yaml

# Download Promtail configuration
wget https://raw.githubusercontent.com/grafana/loki/v${LOKI_VERSION}/clients/cmd/promtail/promtail-docker-config.yaml -O ~/promtail-config/promtail-config.yaml

# Create Docker Compose file
cat <<EOF > docker-compose.yml
version: '3.2'
services:
  loki:
    image: ${LOKI_IMAGE}
    container_name: loki
    ports:
      - 3100:3100
    volumes:
      - ~/loki-config/loki-config.yaml:/etc/loki/loki-config.yaml
    networks:
      - monitoring

  promtail:
    image: ${PROMTAIL_IMAGE}
    container_name: promtail
    volumes:
      - ~/promtail-config/promtail-config.yaml:/etc/promtail/promtail-config.yaml
      - /var/log:/var/log
    command:
      - -config.file=/etc/promtail/promtail-config.yaml
    networks:
      - monitoring

networks:
  monitoring:
    driver: bridge
EOF

# Start services using Docker Compose
docker-compose up -d

# Print status
echo "Loki and Promtail have been installed and started!"
echo "Loki: http://localhost:3100"
