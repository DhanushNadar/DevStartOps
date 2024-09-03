#!/bin/bash

# Define cAdvisor version
CADVISOR_VERSION="latest"

# Pull the cAdvisor Docker image
docker pull gcr.io/cadvisor/cadvisor:${CADVISOR_VERSION}

# Run cAdvisor container
docker run -d \
  --name=cadvisor \
  --net=host \
  -v /:/rootfs:ro \
  -v /var/run:/var/run:rw \
  -v /sys:/sys:ro \
  -v /var/lib/docker/:/var/lib/docker:ro \
  -p 8080:8080 \
  gcr.io/cadvisor/cadvisor:${CADVISOR_VERSION}

# Print status
echo "cAdvisor is now running on http://localhost:8080"