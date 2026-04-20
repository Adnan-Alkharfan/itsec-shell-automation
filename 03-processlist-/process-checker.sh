#!/bin/bash

logfile="process_check.log"

# Funktion för loggning
log() {
    echo "$(date) - $1" | tee -a "$logfile"
}

# Funktion för processkontroll
check_process() {
    local p="$1"

    if pgrep "$p" &>/dev/null; then
        log "Processen '$p' körs."
    else
        log "VARNING: Processen '$p' körs inte."
    fi
}

# Funktion som loopar igenom listan
run_checks() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        log "FEL: Filen $file saknas."
        exit 1
    fi

    while read -r process; do
        [[ -z "$process" ]] && continue
        check_process "$process"
    done < "$file"
}

# Huvudblock
run_checks "Linux-processlist.txt"
log "Kontroller slutförda."