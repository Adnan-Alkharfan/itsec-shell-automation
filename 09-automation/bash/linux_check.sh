#!/bin/bash

output="../data/linux_processes.json"
logfile="../data/anomalies.log"

log() {
    echo "$(date) - $1" | tee -a "$logfile"
}

log "Startar Linux-kontroll..."
# Hämta processlista
processes=$(ps -eo comm --no-headers)

log "Processlista insamlad."
# Bygg JSON-struktur
json="{\"processes\": ["

while read -r p; do
    json="$json{\"name\": \"$p\"},"
done <<< "$processes"

# Ta bort sista kommatecknet
json="${json%,}]}"
echo "$json" > "$output"
log "JSON exporterad till $output"
# Lista över riskprocesser
risk=("nc" "netcat" "hydra" "john")

# Detektion av riskprocesser
for r in "${risk[@]}"; do
    if echo "$processes" | grep -q "$r"; then
        log "VARNING – Riskprocess upptäckt: $r"
    fi
done

log "Linux-kontroll klar."
