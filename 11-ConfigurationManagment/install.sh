# Update package list and install prerequisites
sudo apt update
sudo apt install -y software-properties-common

# Add Ansible PPA and install Ansible
sudo add-apt-repository ppa:ansible/ansible
sudo apt update
sudo apt install -y ansible