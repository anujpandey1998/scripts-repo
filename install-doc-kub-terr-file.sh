#!/bin/bash
set -e  # Exit immediately on error

echo "### Updating package index..."
apt-get update -y

echo "### Installing prerequisites..."
apt-get install -y ca-certificates curl gnupg lsb-release software-properties-common wget

##############################
# Install Docker
##############################
echo "### Adding Docker GPG key..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "### Adding Docker APT repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > \
  /etc/apt/sources.list.d/docker.list

echo "### Installing Docker..."
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "### Enabling and starting Docker..."
systemctl enable docker
systemctl start docker

echo "### Adding 'ubuntu' user to docker group..."
usermod -aG docker ubuntu
systemctl restart docker

echo "### Verifying Docker with hello-world image..."
docker run hello-world || echo "Docker verification failed."

##############################
# Install kubectl
##############################
echo "### Installing kubectl..."
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256"

echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check || {
  echo "kubectl binary failed SHA256 verification."
  exit 1
}

install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl kubectl.sha256
echo "### kubectl installed. Version:"
kubectl version --client

##############################
# Install Terraform
##############################
echo "### Adding HashiCorp GPG key..."
wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "### Adding Terraform repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list

echo "### Installing Terraform..."
apt-get update -y
apt-get install -y terraform

echo "### Terraform installation complete. Version:"
terraform --version

#############################################################Few commands to run later###############################################
    1  clear
    2  git clone https://github.com/iam-veeramalla/ultimate-devops-project-demo.git
    3  ls
    4  cd ultimate-devops-project-demo/
    5  ls
    6  ls -ltr
    7  docker compose up -y
    8  clear
    9  df -h
   10  lsblk
   11  apt install cloud guest-utils
   12  apt install cloud-guest-utils
   13  clear
   14  df -h
   15  sudo growpart /dev/xvda 1
   16  df -h
   17  lsblk
   18  sudo growpart /dev/xvda 1
   19  lsblk
   20  df -h
   21  sudo ressize2fs /dev/xvda1
   22  sudo resize2fs /dev/xvda1
   23  df -h
   24  clear
   25  docker compose up -y
   26  clear
   27  docker compose up -d
   28  history
