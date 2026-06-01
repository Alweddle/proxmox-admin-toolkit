# 📊 Configuration InfluxDB

## Paramètres

| Paramètre | Valeur |
|---|---|
| URL | http://192.168.1.200:8086 |
| Organisation | CelialexHome |
| Bucket | Proxmox |
| Version | 2.9.1 |

## Tokens API

| Token | Rôle |
|---|---|
| `ProxMox` | Écriture des métriques depuis Proxmox Metric Server |
| `Alweddle's Token` | Token admin principal |

## Measurements disponibles

### Depuis Proxmox Metric Server
| Measurement | Contenu |
|---|---|
| `cpustat` | CPU du nœud (cpu, wait, avg1/5/15, cpus...) |
| `memory` | RAM du nœud (memtotal, memused, memfree, swap...) |
| `disk` | Espace disque (used_percent, free, total...) |
| `diskio` | I/O disques (read_bytes, write_bytes, io_util...) |
| `nics` | Réseau (receive, transmit par interface) |
| `system` | VMs/LXC + stockages (cpu, mem, maxmem, uptime...) |
| `ballooninfo` | Mémoire balloon des VMs |

### Depuis Telegraf
| Measurement | Contenu |
|---|---|
| `cpu` | CPU détaillé (usage_user, usage_system, usage_iowait...) |
| `mem` | RAM détaillée |
| `disk` | Disques avec points de montage |
| `temp` | Températures (coretemp, nvme, acpitz, pch...) |
| `smart_device` | S.M.A.R.T. disques (media_wearout_indicator, temp_c, power_on_hours...) |

## Tags importants

| Tag | Valeurs | Description |
|---|---|---|
| `host` | `proxmox-alex-01` (nœud) ou nom VM/LXC | Identifiant source |
| `nodename` | `proxmox-alex-01` | Nœud Proxmox |
| `object` | `nodes`, `qemu`, `lxc`, `storages` | Type d'objet |
| `vmid` | `100`, `101`, `102` | ID de la VM/LXC |
| `instance` | `enp1s0`, `lo`... | Interface réseau |
| `device` | `sda`, `nvme0n1`, `sdb` | Périphérique disque |
| `sensor` | `coretemp_core_0`... | Capteur température |
