# Step 1: Update System Packages
sudo apt update

# Step 2: Install Required Packages
sudo apt install -y curl wget apt-transport-https

# Step 3: Install Docker
sudo apt install -y docker.io

# Start and enable Docker
sudo systemctl enable --now docker

# Add current user to docker group (To use docker without root)
sudo usermod -aG docker $USER && newgrp docker

# Step 4: Install Minikube
# Download Minikube binary
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Make Minikube executable and move it to /usr/local/bin/
chmod +x minikube
sudo mv minikube /usr/local/bin/

# Step 5: Install kubectl
# Download kubectl binary
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Make kubectl executable and move it to /usr/local/bin/
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

