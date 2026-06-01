# 🏗️ Architecture

## Infrastructure Proxmox

```
proxmox-alex-01 (192.168.1.210)
├── Hardware
│   ├── CPU : Intel Core i3-9100T @ 3.10GHz (4 cœurs)
│   ├── RAM : 15.43 Go
│   ├── NVMe : 128 Go — Système Proxmox (pve-root + local)
│   ├── SSD SATA : 128 Go — Pool LVM-thin (local-lvm) ⚠️ 85% usure
│   └── USB : 500 Go LaCie — Stockage secondaire (lacie)
│
├── CT101 influxdb-grafana (192.168.1.200)
│   ├── InfluxDB 2.9.1 :8086
│   └── Grafana 11.6.0 :3000
│
├── CT102 wireguard
│   └── VPN WireGuard — Accès distant sécurisé
│
└── VM100 vm-wordpress
    └── Serveur web WordPress

```

## Flux de données

```
Proxmox Metric Server
        │
        ▼ (UDP → HTTP/8086)
   InfluxDB 2.x
   Bucket: Proxmox
        │
        ├── Measurements natifs Proxmox :
        │   ├── cpustat    (CPU nœud)
        │   ├── memory     (RAM nœud)
        │   ├── disk       (Stockage)
        │   ├── diskio     (I/O disques)
        │   ├── nics       (Réseau)
        │   └── system     (VMs/LXC + stockages)
        │
Telegraf Agent (nœud Proxmox)
        │
        ▼ (HTTP/8086)
   InfluxDB 2.x
        │
        ├── Measurements Telegraf :
        │   ├── cpu        (CPU détaillé)
        │   ├── mem        (RAM détaillée)
        │   ├── disk       (Disques)
        │   ├── temp       (Températures CPU/NVMe)
        │   └── smart_device (S.M.A.R.T. disques)
        │
        ▼
   Grafana 11.x
   Dashboard: Monitoring Proxmox
```

## Stockages Proxmox

| Stockage | Type | Taille | Rôle |
|---|---|---|---|
| pve-root | ext4 (NVMe) | 128 Go | Système Proxmox |
| local | dir (NVMe) | 38.7 Go | ISOs, backups, snippets |
| local-lvm | LVM-thin (SSD SATA) | 188 Go | Disques VMs et LXC |
| lacie | dir (USB) | 457 Go | Stockage secondaire |

## Ressources allouées

| Ressource | Alloué | Disponible | Status |
|---|---|---|---|
| vCPUs | 5 / 4 cœurs | — | 🟠 Over-provisionné |
| RAM | 3.5 Go / 15.43 Go | 11.9 Go | 🟢 OK |
| Disque | ~44 Go / 188 Go | ~144 Go | 🟢 OK |
