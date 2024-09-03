#!/bin/bash

# This script sets up Prometheus, cAdvisor, Redis, Node Exporter, Loki, and Promtail using Docker Compose.
# Ensure that the app you want to monitor runs on the same network as these services. Add your app's Docker Compose configuration at the top of this file and ensure it is on the same network.

# Download Prometheus configuration
echo "Downloading Prometheus configuration..."
wget https://raw.githubusercontent.com/prometheus/prometheus/main/documentation/examples/prometheus.yml -O prometheus.yml

# Modify Prometheus configuration
echo "Modifying Prometheus configuration..."
cat <<EOF >> prometheus.yml
- job_name: "Docker Containers"
  static_configs:
    - targets: ["cadvisor:8080"]

- job_name: "NodeExporter"
  static_configs:
    - targets: ["node-exporter:9100"]

- job_name: "Loki"
  static_configs:
    - targets: ["loki:3100"]
EOF

# Download Loki configuration
echo "Downloading Loki configuration..."
wget https://raw.githubusercontent.com/grafana/loki/v2.8.0/cmd/loki/loki-local-config.yaml -O loki-config.yml

# Download Promtail configuration
echo "Downloading Promtail configuration..."
wget https://raw.githubusercontent.com/grafana/loki/v2.8.0/clients/cmd/promtail/promtail-docker-config.yaml -O promtail-config.yml

# Create Docker Compose file
echo "Creating Docker Compose file..."
cat <<EOF > docker-compose.yml
version: '3.2'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - 9090:9090
    command:
      - --config.file=/etc/prometheus/prometheus.yml
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
    depends_on:
      - cadvisor
      - node-exporter
      - loki

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    ports:
      - 8080:8080
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro

  redis:
    image: redis:latest
    container_name: redis
    ports:
      - 6379:6379

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    ports:
      - "9100:9100"
    networks:
      - monitoring

  loki:
    image: grafana/loki:latest
    container_name: loki
    ports:
      - 3100:3100
    volumes:
      - ./loki-config.yml:/etc/loki/loki-config.yaml

  promtail:
    image: grafana/promtail:latest
    container_name: promtail
    volumes:
      - ./promtail-config.yml:/etc/promtail/promtail-config.yaml

networks:
  monitoring:
    driver: bridge

EOF

# Start Docker Compose services
echo "Starting Docker Compose services..."
docker-compose up -d

# Print status
echo "Setup complete!"
echo "Prometheus: http://localhost:9090"
echo "Grafana: http://localhost:3000"
echo "Loki: http://localhost:3100"
echo "cAdvisor: http://localhost:8080"
echo "Node Exporter: http://localhost:9100"