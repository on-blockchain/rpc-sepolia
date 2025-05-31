#!/bin/bash

echo -e "Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo -e "Installing docker if not installed"
if ! command -v docker &>/dev/null; then
    echo -e "Docker not found. Installing Docker..."
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
	# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker $USER
    echo -e "Docker successfully installed!"
else
    echo -e "Docker is installed"
fi

mkdir -p data/nethermind data/lighthouse jwtsecret
sudo chown -R $USER:$USER ./data/nethermind
sudo chmod -R 755 ./data/nethermind
sudo chown -R $USER:$USER ./data/lighthouse
sudo chmod -R 755 ./data/lighthouse

if [ ! -f jwtsecret/engine.jwt ];
then
    openssl rand -hex 32 > jwtsecret/engine.jwt
fi

echo "Starting ETH Sepolia RPC & Beacon"
docker-compose up -d

echo -e "Use \ncurl -X POST http://localhost:8545 -H "Content-Type:application/json" -d '{\"jsonrpc\":\"2.0\",\"method\":\"net_peerCount\",\"params\":[],\"id\":1}' \n to check if the RPC has been synched\n\n"

echo -e "Use \ncurl http://localhost:5052/eth/v1/node/syncing \nto check Beacon status"
