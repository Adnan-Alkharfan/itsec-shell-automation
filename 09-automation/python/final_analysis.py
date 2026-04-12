import json
import csv

# --- Läs Linux-processer ---
with open("../data/linux_processes.json") as f:
    linux = json.load(f)["processes"]

# --- Läs Windows-tjänster ---
services = []
with open("../data/windows_services.csv") as f:
    reader = csv.DictReader(f)
    for row in reader:
        services.append(row)

# --- Läs anomaly-loggen ---
with open("../data/anomalies.log") as f:
    anomalies = f.readlines()

# --- Risklogik ---
report = []

# Kontrollera misstänkta Linux-processer
linux_risk = [p["name"] for p in linux if p["name"] in ["nc", "netcat", "hydra"]]

for p in linux_risk:
    report.append(f"CRITICAL: Linux riskprocess upptäckt – {p}")

# Kontrollera riskabla Windows-tjänster
risk_services = ["Telnet", "RemoteRegistry", "Spooler"]

for svc in services:
    if svc["Name"] in risk_services:
        report.append(f"WARNING: Riskabel Windows-tjänst – {svc['Name']}")

# Lägg in anomaly-loggar
report.append("= ANOMALI-LOGG =")
report.extend([line.strip() for line in anomalies])

# --- Skriv slutrapport ---
with open("../data/final_security_report.txt", "w") as f:
    for line in report:
        f.write(line + "\n")

print("Slutrapport skapad: final_security_report.txt")
