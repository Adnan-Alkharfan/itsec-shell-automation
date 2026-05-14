#!/usr/bin/env bash
# ---------------------------------------------------------
# Filnamn: linux_check.sh
# Syfte:   Träning – samla processer + analys + riskkontroll
# Output:  linux_output.json + anomalies.log
# ---------------------------------------------------------

OUTPUT="../data/linux_output.json"
LOGFILE="../data/anomalies.log"

echo "Analyserar processer..."
sleep 0.5

# Steg 1: Hämta processer
processes=$(ps aux --no-heading | awk '{print $11}')
count=$(echo "$processes" | wc -l)
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
user=$(whoami)

# Steg 2: Skriv JSON
{
    echo "{"
    echo "  \"timestamp\": \"$timestamp\","
    echo "  \"user\": \"$user\","
    echo "  \"process_count\": $count,"
    echo "  \"processes\": ["
    echo "$processes" | sed 's/.*/    "&",/' 
    echo "  ]"
    echo "}"
} > "$OUTPUT"

echo "Kontrollerar risker..."
sleep 0.5

# Steg 3: Enkel riskkontroll
echo "---- Anomaly Log ----" > "$LOGFILE"

for p in $processes; do
    case "$p" in
        *nc*|*netcat*)
            echo "Risk: Netcat process detected ($p)" >> "$LOGFILE"
            ;;
        *curl*)
            echo "Risk: curl process detected ($p)" >> "$LOGFILE"
            ;;
        *wget*)
            echo "Risk: wget process detected ($p)" >> "$LOGFILE"
            ;;
        *ssh*)
            echo "Notice: SSH process found ($p)" >> "$LOGFILE"
            ;;
        *python*)
            echo "Info: Python process running ($p)" >> "$LOGFILE"
            ;;
    esac
done

echo "Klar! Data sparad i $OUTPUT och $LOGFILE"
