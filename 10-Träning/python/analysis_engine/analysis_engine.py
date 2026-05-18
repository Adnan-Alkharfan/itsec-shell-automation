# ---------------------------------------------------------
# Filnamn: analysis.py
# Syfte:   Träning – läsa JSON från Linux + Windows och analysera
# Output:  combined_report.json
# ---------------------------------------------------------

import json
from datetime import datetime

linux_path = "../data/linux_output.json"
windows_path = "../data/windows_output.json"
output_path = "../data/combined_report.json"

print("Läser JSON-filer...")

# Steg 1: Läs Linux JSON
with open(linux_path, "r", encoding="utf-8") as f:
    linux_data = json.load(f)

# Steg 2: Läs Windows JSON
with open(windows_path, "r", encoding="utf-8") as f:
    windows_data = json.load(f)

print("Analyserar data...")

# Steg 3: Enkel analys
combined = {
    "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    "linux_process_count": linux_data.get("process_count", len(linux_data.get("processes", []))),
    "windows_process_count": windows_data.get("process_count", len(windows_data.get("processes", []))),
    "total_processes": (
        linux_data.get("process_count", 0) +
        windows_data.get("process_count", 0)
    ),
    "linux_sample": linux_data.get("processes", [])[:5],
    "windows_sample": windows_data.get("processes", [])[:5],
}

# Steg 4: Skriv rapport
with open(output_path, "w", encoding="utf-8") as f:
    json.dump(combined, f, indent=4)

print("Klar! Rapport sparad i combined_report.json")
