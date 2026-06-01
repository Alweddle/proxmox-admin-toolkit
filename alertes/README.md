# 🔔 Alertes Grafana

## Configuration

- **Contact point** : Email Gmail (SMTP)
- **Dossier** : `Proxmox Alertes`
- **Groupe d'évaluation** : `proxmox-node` (interval : 1 min)

## Règles d'alerte

| Nom | Seuil | Pending | Panel lié |
|---|---|---|---|
| CPU Proxmox - Utilisation élevée | > 80% | 5 min | 🖥️ CPU |
| RAM Proxmox - Utilisation élevée | > 85% | 5 min | 🧠 RAM |
| Disque Proxmox - Espace critique | > 85% | immédiat | 💾 Disque pve-root |
| Load Average Proxmox - Charge élevée | avg5 > 4 | 5 min | 📊 Load Average |
| IO Wait Proxmox - Disques saturés | > 25% | 5 min | ⏳ I/O Wait |
| SSD SATA - Usure critique | > 90% | immédiat | 💾 Usure SSD SATA |

## Seuils expliqués

### CPU > 80%
Le processeur est sous forte charge. Au-delà de 80% pendant 5 minutes consécutives, c'est une charge anormale pour un serveur homelab.

### RAM > 85%
La mémoire vive est presque saturée. Avec 15.43 Go disponibles, 85% représente ~13 Go utilisés — risque de swap.

### Disque système > 85%
L'espace système est critique. Proxmox peut avoir des comportements instables si le disque système est plein.

### Load Average > 4
Le load average dépasse le nombre de cœurs physiques (4). Le serveur est structurellement sous pression.

### I/O Wait > 25%
Le CPU attend trop longtemps que les disques répondent. Peut indiquer un disque défaillant ou saturé.

### Usure SSD SATA > 90%
Le SSD SATA SK Hynix SC311 est à 85% d'usure. Une alerte à 90% signifie un remplacement **urgent** nécessaire.

## Format des notifications email

**Sujet** : `⚠️ Grafana Alert - {nom_alerte}`

**Corps** :
```
🔴 Alerte déclenchée sur proxmox-alex-01

Règle : {nom_alerte}
Statut : Firing
Lien dashboard : http://192.168.1.200:3000/d/...
```
