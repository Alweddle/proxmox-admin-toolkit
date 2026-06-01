# 🔧 Guide de dépannage

## Problème : No data dans Grafana

### Symptôme
Les panels affichent "No data" alors que Proxmox tourne normalement.

### Diagnostic
```bash
# Sur le nœud Proxmox
journalctl -u pvestatd --since "10 minutes ago"
```

### Cause 1 : Erreur 422 Unprocessable Entity
InfluxDB refuse les données — conflit de type sur un champ (int vs float).

**Solution** : Supprimer et recréer le bucket dans InfluxDB.
1. InfluxDB → Load Data → Buckets → Supprimer `Proxmox`
2. Recréer le bucket `Proxmox`
3. `systemctl restart pvestatd`

⚠️ L'historique des données sera perdu.

### Cause 2 : Token invalide
```
metrics send error 'influxdb': 401 Unauthorized
```

**Solution** : Régénérer le token dans InfluxDB → Load Data → API Tokens → ProxMox → Régénérer.
Mettre à jour dans Proxmox → Datacenter → Metric Server → Edit.

### Cause 3 : pvestatd arrêté
```bash
systemctl status pvestatd
systemctl restart pvestatd
```

---

## Problème : Telegraf ne collecte pas les données S.M.A.R.T.

### Symptôme
Le measurement `smart_device` est vide dans InfluxDB.

### Diagnostic
```bash
journalctl -u telegraf --since "10 minutes ago" | grep -i "error\|smart"
```

### Cause : sudo non installé sur Proxmox
Proxmox n'inclut pas `sudo` par défaut.

**Solution** :
```bash
apt-get install -y sudo
echo 'telegraf ALL=(root) NOPASSWD:/usr/sbin/smartctl' >> /etc/sudoers
systemctl restart telegraf
```

---

## Problème : Températures non disponibles

### Symptôme
Le measurement `temp` est vide.

### Vérification manuelle
```bash
cat /sys/class/thermal/thermal_zone*/temp
```

Si des valeurs s'affichent mais Telegraf ne les collecte pas :
```bash
systemctl restart telegraf
journalctl -u telegraf -f
```

---

## Problème : Emails d'alerte non reçus

### Vérification SMTP
Dans Grafana → Alerting → Contact points → Test

### Configuration Gmail
1. Activer la validation en deux étapes sur le compte Gmail
2. Créer un App Password sur `myaccount.google.com/apppasswords`
3. Dans `/etc/grafana/grafana.ini` — le password doit être **sans espaces** :
```ini
password = """motdepassesansespaces"""
```
```bash
systemctl restart grafana-server
```

---

## Commandes utiles

```bash
# Statut des services
systemctl status pvestatd
systemctl status telegraf
systemctl status influxdb
systemctl status grafana-server

# Logs en temps réel
journalctl -u pvestatd -f
journalctl -u telegraf -f

# Test S.M.A.R.T. manuel
smartctl -a /dev/sda
smartctl -a /dev/nvme0n1

# Test températures
cat /sys/class/thermal/thermal_zone*/temp
```
