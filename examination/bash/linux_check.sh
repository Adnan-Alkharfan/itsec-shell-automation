#!/usr/bin/env bash
# ---------------------------------------------------------
# Filnamn: linux_check.sh
# Syfte:   Samla in Linux-processer, loggar och upptäcka
#          avvikelser för vidare analys i Python.
# Output:  linux_output.json, anomalies.log
# Författare: Adnan
# Datum: 2026-04-14
# ---------------------------------------------------------

OUTPUT="../data/linux_output.json"
ANOMALY_LOG="../data/anomalies.log"

# ---------------------------------------------------------
# Moment 1 – Samla processer och loggar
# ---------------------------------------------------------
collect_processes() {
    ps aux --no-heading | awk '{print $11}' > /tmp/process_list.txt
}

collect_logs() {
    journalctl -n 50 > /tmp/linux_logs.txt
}

# ---------------------------------------------------------
# Moment 3 – Enkel avvikelsedetektion
# ---------------------------------------------------------
detect_anomalies() {
    local count
    count=$(wc -l < /tmp/linux_logs.txt)

    if [ "$count" -gt 100 ]; then
        echo "För många logghändelser i Linux." >> "$ANOMALY_LOG"
    fi
}

# ---------------------------------------------------------
# Moment 4 – Exportera data till JSON
# ---------------------------------------------------------
export_to_json() {
    {
        echo "{"
        echo "\"processes\": ["
        sed 's/.*/"&"/' /tmp/process_list.txt | paste -sd "," -
        echo "],"
        echo "\"logs\": ["
        sed 's/.*/"&"/' /tmp/linux_logs.txt | paste -sd "," -
        echo "]"
        echo "}"
    } > "$OUTPUT"
}

# ---------------------------------------------------------
# Huvudflöde – Moment 4 komplett
# ---------------------------------------------------------
main() {
    collect_processes
    collect_logs
    detect_anomalies
    export_to_json
}

main
