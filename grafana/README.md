# 📊 Dashboard Grafana — Monitoring Proxmox

## Import

1. Dans Grafana → **Dashboards → Import**
2. Uploade `monitoring-proxmox.json`
3. Sélectionne ta datasource InfluxDB
4. Clique **Import**

## Panels par Row

### 🖥️ Row 1 — Nœud Proxmox
| Panel | Type | Métrique |
|---|---|---|
| Machine — proxmox-alex-01 | Text HTML | Infos statiques nœud |
| 🖥️ CPU | Gauge | cpustat.cpu * 100 |
| 🧠 RAM | Gauge | memory.memused / memtotal |
| 💾 Disque pve-root | Gauge | disk.used_percent |
| ⏱️ Uptime | Stat | system.uptime |
| 🧮 CPU alloué | Gauge | sum(system.cpus) / 4 cœurs |
| 🧠 RAM allouée | Gauge | sum(system.maxmem) / 15.43 Go |
| 💾 Disque alloué | Gauge | sum(system.maxdisk) / 188 Go |
| ⚡ Load 1 min | Stat+Area | cpustat.avg1 |
| 📊 Load 5 min | Stat+Area | cpustat.avg5 |
| 📈 Load 15 min | Stat+Area | cpustat.avg15 |
| 📊 Load Average | Time series | cpustat.avg1/5/15 |
| ⏳ I/O Wait | Gauge | cpustat.wait * 100 |
| ⏳ I/O Wait Historique | Time series | cpustat.wait * 100 |
| ❤️ Santé du nœud | Time series | cpu + ram + iowait |

### 🌡️ Row 2 — Températures & S.M.A.R.T.
| Panel | Type | Métrique |
|---|---|---|
| 🌡️ Températures CPU | Time series | temp.coretemp_core_* |
| 🌡️ Temp CPU | Stat+Area | temp.coretemp_package_id_0 |
| 💿 Temp NVMe | Stat+Area | temp.nvme_composite |
| 💾 Usure SSD SATA | Gauge | 100 - smart_device.media_wearout_indicator |
| 🏥 Santé des disques | Table | smart_device.* |

### 💽 Row 3 — Stockages
| Panel | Type | Métrique |
|---|---|---|
| 💽 Stockages Proxmox | Bar gauge | system.used/total (storages) |
| 💽 Stockages Proxmox | Table | system.used/total/free |
| 💿 I/O Disques | Time series | diskio.read_bytes/write_bytes |

### 🌐 Row 4 — Réseau
| Panel | Type | Métrique |
|---|---|---|
| 🌐 Réseau | Time series | nics.receive/transmit (enp1s0) |

### 🚀 Row 5 — VMs & Conteneurs
| Panel | Type | Métrique |
|---|---|---|
| 🖥️ VMs & Conteneurs LXC | Table | system.cpu/mem/disk/uptime (qemu+lxc) |

## Datasource requise

- **Type** : InfluxDB
- **Query Language** : Flux
- **URL** : http://192.168.1.200:8086
- **Bucket** : Proxmox
