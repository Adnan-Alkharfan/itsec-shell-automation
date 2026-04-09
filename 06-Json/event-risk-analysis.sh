#!/bin/bash

logfile="event_risk_report.log"

log() {
    echo "$(date) - $1" | tee -a "$logfile"
}

# -----------------------------------------
# 1. Läs in CSV till en array
# -----------------------------------------
declare -A status_map

while IFS=',' read -r username status; do
    [[ "$username" == "username" ]] && continue
    status_map[$username]=$status
done < users.csv

# -----------------------------------------
# 2. Räkna failed logins
# -----------------------------------------
declare -A fail_count

for user in "${!status_map[@]}"; do
    count=$(jq --arg usr "$user" \
        '.events | map(select(.user==$usr and .event=="failed_login")) | length' \
        events.json)
    fail_count[$user]=$count
done

# -----------------------------------------
# 3. Riskklassificering
# -----------------------------------------
for user in "${!status_map[@]}"; do
    fails=${fail_count[$user]}
    stat=${status_map[$user]}

    echo "DEBUG: user=$user | fails=$fails | status=$stat"

    if [[ $fails -ge 1 && "$stat" == "disabled" ]]; then
        log "$user - CRITICAL RISK (disabled + failed logins)"
    elif [[ $fails -ge 3 ]]; then
        log "$user - HIGH RISK (3+ failed attempts)"
    elif [[ $fails -ge 1 ]]; then
        log "$user - MEDIUM RISK (failed attempts)"
    else
        log "$user - LOW RISK"
    fi
done

log "Analys slutförd."
