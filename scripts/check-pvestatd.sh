#!/bin/bash
# check-pvestatd.sh
# Vérifie que pvestatd envoie bien les métriques vers InfluxDB
# Usage : bash check-pvestatd.sh

echo "=== Statut pvestatd ==="
systemctl is-active pvestatd && echo "✅ pvestatd actif" || echo "❌ pvestatd inactif"

echo ""
echo "=== Erreurs récentes (10 dernières minutes) ==="
ERRORS=$(journalctl -u pvestatd --since "10 minutes ago" | grep -c "error")
if [ "$ERRORS" -gt 0 ]; then
    echo "⚠️ $ERRORS erreur(s) détectée(s) :"
    journalctl -u pvestatd --since "10 minutes ago" | grep "error" | tail -5
else
    echo "✅ Aucune erreur"
fi

echo ""
echo "=== Statut Telegraf ==="
systemctl is-active telegraf && echo "✅ Telegraf actif" || echo "❌ Telegraf inactif"

echo ""
echo "=== Test S.M.A.R.T. ==="
for disk in sda nvme0n1 sdb; do
    if [ -b "/dev/$disk" ]; then
        HEALTH=$(smartctl -H /dev/$disk 2>/dev/null | grep "SMART overall" | awk '{print $NF}')
        echo "/dev/$disk : $HEALTH"
    fi
done

echo ""
echo "=== Températures ==="
for zone in /sys/class/thermal/thermal_zone*/temp; do
    TEMP=$(cat $zone)
    TEMP_C=$(echo "scale=1; $TEMP/1000" | bc)
    echo "$zone : ${TEMP_C}°C"
done
