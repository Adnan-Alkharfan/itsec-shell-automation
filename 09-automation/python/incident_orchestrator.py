import json
import csv
import re

# ------------------------
# 1. Läs Linux-data (JSON)
# ------------------------
with open("../data/linux_processes.json") as f:
    linux = json.load(f)["processes"]

linux_procs = [p["name"] for p in linux]

# ------------------------
# 2. Läs Windows-data (CSV)
# ------------------------
windows_services = []
with open("../data/windows_services.csv") as f:
    for row in csv.DictReader(f):
        windows_services.append(row["Name"])

# ------------------------
# 3. Läs anomalies.log
# ------------------------
with open("../data/anomalies.log") as f:
    anomalies = [line.strip() for line in f]

# ------------------------
# 4. Läs auth.log
# ------------------------
ip_fail_count = {}
with open("../data/auth.log") as f:
    for line in f:
        if "failed" in line.lower():
            match = re.search(r"(\d{1,3}(\.\d{1,3}){3})", line)
            if match:
                ip = match.group(1)
                ip_fail_count[ip] = ip_fail_count.get(ip, 0) + 1

# ------------------------
# 5. Risklogik
# ------------------------
riskprocesses = ["nc", "netcat", "hydra", "john"]
risktjenster = ["RemoteRegistry", "Telnet", "Spooler"]

incidents = []

# Linux-processrisker
for p in linux_procs:
    if p in riskprocesses:
        incidents.append(f"CRITICAL: Riskprocess upptäckt – {p}")

# Windows-tjänster
for svc in windows_services:
    if svc in risktjenster:
        incidents.append(f"HIGH: Riskabel Windows-tjänst upptäckt – {svc}")

# Brute-force detektion
for ip, count in ip_fail_count.items():
    if count >= 5:
        incidents.append(f"CRITICAL: Brute-force-indikator från IP {ip} ({count} fails)")
    elif count >= 1:
        incidents.append(f"MEDIUM: Misstänkta felaktiga inloggningar från {ip}")

# Anomalier från tidigare script
for anomaly in anomalies:
    incidents.append(f"INFO (från anomalies.log): {anomaly}")

# ------------------------
# 6. Notifieringslogik
# ------------------------
with open("../data/alerts.json", "w") as f:
    json.dump({"alerts": incidents}, f, indent=4)

print("= INCIDENT SUMMARY =")
for inc in incidents:
    print("-", inc)

# ------------------------
# 7. Slutrapport
# ------------------------
with open("../data/incident_report.txt", "w") as f:
    for inc in incidents:
        f.write(inc + "\n")

print("\nIncidentrapport skapad: incident_report.txt")
