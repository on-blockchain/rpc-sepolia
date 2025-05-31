# Sepolia RPC + Beacon Node Setup

This script sets up an RPC and Beacon node for the Ethereum Sepolia testnet using a simple Bash script.

---

## ✅ Requirements

- Tested on **Ubuntu 24.04**
- You need **root access**
- **SSD required**
- Expected disk space: **650 GB**

---

## 🔒 Security Notes

- If you're installing this on a **VPS**, your node will be publicly accessible.
- **You must configure your firewall** (e.g., UFW or iptables) to block unwanted access to ports `5052` and `8545`.
- Never expose your RPC to the open internet without access restrictions — scanners and bots will find and abuse it.

---

## ⚙️ How to Install

Run this command in your terminal:

```bash
git clone https://github.com/on-blockchain/rpc-sepolia.git && cd rpc-sepolia && chmod +x rpc.sh && bash rpc.sh
```

---

## 🌐 Access URLs

Once installed, you can access your RPC and Beacon endpoints at:

### RPC URL:
- `http://localhost:5052`
- or `http://<your-server-ip>:5052`

### Beacon URL:
- `http://localhost:8545`
- or `http://<your-server-ip>:8545`

---

## 🔄 Sync Notes

> 🔸 **Beacon will not start syncing until the RPC node is fully synced.**  
> 🔸 **RPC sync can take several days.**

### Check if RPC is syncing:
```bash
curl -X POST http://localhost:8545 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}'
```

If the node is fully synced, you will see:
```json
{
  "jsonrpc": "2.0",
  "result": false,
  "id": 1
}
```

### Check if Beacon is syncing (only works after RPC is synced):
```bash
curl http://localhost:5052/eth/v1/node/syncing | jq
```

Expected output if synced:
```json
{
  "data": {
    "is_syncing": false,
    "is_optimistic": false,
    "el_offline": false,
    "head_slot": "7749973",
    "sync_distance": "0"
  }
}
```

---

## 🏠 Hosting from Desktop with Dynamic IP?

If your ISP gives you a **dynamic IP**, you can use a Dynamic DNS provider like:

- [noip.com](https://www.noip.com)

Or use your own domain with Cloudflare:

👉 Use this script to automatically update your Cloudflare DNS every minute:  
[https://github.com/on-blockchain/cloudflare-dns-updater](https://github.com/on-blockchain/cloudflare-dns-updater)

---

## 🖥️ VirtualBox Users

If you're running this inside a VirtualBox VM and want access from another VM or host:

- Forward **port 5052** and **port 8545** in VirtualBox network settings.

---

## 🌍 Accessing from External Network

If you want to expose your node to the internet:

1. **Forward ports** `5052` and `8545` on your **router**.
2. **Restrict access** to specific IPs or ranges using firewall rules.

⚠️ Exposing your RPC to the internet without restrictions is risky. Bots will find and exploit open nodes.

---

## 🛡️ Final Note

Always monitor your endpoints. Publicly exposed nodes are **not secure by default** — take precautions.
