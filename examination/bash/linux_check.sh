#!/bin/bash
# ---------------------------------------------------------
# Filnamn: linux_check.sh
# Syfte:   Utför säkerhetskontroller i Linux, analyserar
#          processer och identifierar risker.
# Output:  JSON-data + loggar
# Författare: Adnan
# Datum: $(date +%Y-%m-%d)
# ---------------------------------------------------------

# Filvägar för output och loggar
output="../data/linux_output.json"
logfile="../data/anomalies.log"

# Funktion: loggar meddelanden till anomalies.log
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') INFO: $1" >> "$logfile"
}

# Funktion: hämtar aktiva processer
get_processes() {
    processes=$(ps aux)
}

# Funktion: kontrollerar processer mot en risklista
check_risks() {
    :
}

# Funktion: exporterar resultat till JSON
export_json() {
    :
}

# Huvudflöde
main() {
    get_processes
    check_risks
    export_json
}

main
