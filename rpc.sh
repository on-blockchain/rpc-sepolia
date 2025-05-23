#!/bin/bash
set -e

# Check if Docker is installed
if ! command -v docker &> /dev/null;
then
    echo "Installing Docker"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
fi

# Check if Docker Compose is installed
if ! docker-compose version &> /dev/null;
then
    echo "Installing Docker-Compose"
    apt install docker-compose
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
