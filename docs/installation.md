# 📦 Guide d'installation

## Prérequis

- Proxmox VE 9.x
- Conteneur LXC Debian 12 pour InfluxDB + Grafana
- Accès root au nœud Proxmox

---

## 1. Créer le conteneur LXC InfluxDB + Grafana

Dans Proxmox → **Create CT** :

| Paramètre | Valeur |
|---|---|
| CT ID | 101 |
| Hostname | influxdb-grafana |
| Template | Debian 12 |
| CPU | 2 vCPU |
| RAM | 1024 Mo |
| Disque | 8 Go (local-lvm) |
| IP | 192.168.1.200/24 |

---

## 2. Installer InfluxDB 2.x

```bash
# Dans le conteneur CT101
curl -s https://repos.influxdata.com/influxdata-archive_compat.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | tee /etc/apt/sources.list.d/influxdata.list
apt-get update && apt-get install -y influxdb2
systemctl enable influxdb
systemctl start influxdb
```

Accède à `http://IP:8086` et configure :
- Organisation : `CelialexHome`
- Bucket : `Proxmox`
- Token : note-le précieusement

---

## 3. Installer Grafana

```bash
apt-get install -y apt-transport-https software-properties-common
wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | tee /etc/apt/sources.list.d/grafana.list
apt-get update && apt-get install -y grafana
systemctl enable grafana-server
systemctl start grafana-server
```

---

## 4. Configurer Proxmox Metric Server

Dans Proxmox → **Datacenter → Metric Server → Add → InfluxDB** :

| Paramètre | Valeur |
|---|---|
| Name | influxdb |
| Server | 192.168.1.200 |
| Port | 8086 |
| Protocol | HTTP |
| Organization | CelialexHome |
| Bucket | Proxmox |
| Token | (ton token InfluxDB) |

---

## 5. Installer Telegraf sur le nœud Proxmox

```bash
# Sur le nœud Proxmox
wget https://dl.influxdata.com/telegraf/releases/telegraf_1.33.0-1_amd64.deb
dpkg -i telegraf_1.33.0-1_amd64.deb
apt-get install -y smartmontools sudo nvme-cli

# Configurer sudo pour Telegraf
echo 'telegraf ALL=(root) NOPASSWD:/usr/sbin/smartctl' >> /etc/sudoers

# Copier la config Telegraf
cp telegraf/proxmox.conf /etc/telegraf/telegraf.d/proxmox.conf
# Éditer le token dans le fichier

systemctl enable telegraf
systemctl start telegraf
```

---

## 6. Importer le dashboard Grafana

1. Dans Grafana → **Dashboards → Import**
2. Uploade le fichier `grafana/dashboards/monitoring-proxmox.json`
3. Sélectionne la datasource InfluxDB
4. Clique **Import**

---

## 7. Configurer les alertes email (Gmail)

```bash
# Dans le conteneur CT101
nano /etc/grafana/grafana.ini
```

Section `[smtp]` :

```ini
[smtp]
enabled = true
host = smtp.gmail.com:587
user = ton.email@gmail.com
password = """ton_app_password_sans_espaces"""
from_address = ton.email@gmail.com
from_name = Grafana Proxmox
skip_verify = false
```

```bash
systemctl restart grafana-server
```
