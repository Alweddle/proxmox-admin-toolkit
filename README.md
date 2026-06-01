# 🖥️ Proxmox Admin Toolkit

Collection d'outils de monitoring et d'administration pour **Proxmox VE 9.x** avec **InfluxDB 2.x** et **Grafana 11.x**.

## 📦 Stack technique

```
Proxmox VE → InfluxDB 2.x → Grafana
Proxmox VE → Telegraf → InfluxDB 2.x → Grafana
```

| Composant | Version | Rôle |
|---|---|---|
| Proxmox VE | 9.0.3 | Hyperviseur |
| InfluxDB | 2.9.1 | Base de données métriques |
| Grafana | 11.6.0 | Visualisation |
| Telegraf | 1.33.0 | Agent de collecte avancée |

## 📁 Contenu

| Dossier | Description |
|---|---|
| [grafana/](./grafana/) | Dashboard Grafana — Monitoring Proxmox complet |
| [telegraf/](./telegraf/) | Configuration Telegraf — S.M.A.R.T., températures |
| [influxdb/](./influxdb/) | Configuration InfluxDB — bucket, token, organisation |
| [alertes/](./alertes/) | Règles d'alertes Grafana configurées |
| [docs/](./docs/) | Documentation — installation, architecture, dépannage |
| [scripts/](./scripts/) | Scripts utilitaires |

## 🚀 Dashboard Grafana

Le dashboard couvre :

- **🖥️ Nœud Proxmox** — CPU, RAM, Disque, Uptime, Load Average, I/O Wait
- **🌡️ Températures & S.M.A.R.T.** — Températures CPU/NVMe, usure SSD, santé disques
- **💽 Stockages** — Pools de stockage, I/O disques
- **🌐 Réseau** — Trafic entrant/sortant interface physique
- **🚀 VMs & Conteneurs** — CPU, RAM, disque, uptime de chaque guest

## 🔔 Alertes configurées

| Alerte | Seuil | Délai |
|---|---|---|
| CPU > 80% | 80% | 5 min |
| RAM > 85% | 85% | 5 min |
| Disque système > 85% | 85% | immédiat |
| Load Average > 4 | 4 | 5 min |
| I/O Wait > 25% | 25% | 5 min |
| Usure SSD > 90% | 90% | immédiat |

## 🏗️ Architecture

```
proxmox-alex-01 (192.168.1.210)
├── CT101 influxdb-grafana (192.168.1.200)
│   ├── InfluxDB 2.9.1 :8086
│   └── Grafana 11.6.0 :3000
├── CT102 wireguard
└── VM100 wordpress
```

## 👤 Auteur

**Alweddle** — [GitHub](https://github.com/Alweddle)

## 📄 Licence

MIT
