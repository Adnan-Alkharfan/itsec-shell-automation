import json
import csv
import re

# ---- 1. Läs CSV ----
users = {}

with open("users.csv") as f:
    for row in csv.DictReader(f):
        users[row["username"]] = {
            "status": row["status"],
            "fails": 0
        }
# ---- 2. Läs JSON ----
with open("events.json") as f:
    events = json.load(f)["events"]

for e in events:
    if e["event"] == "failed_login":
        user = e["user"]
        if user in users:
            users[user]["fails"] += 1
# ---- 3. Läs textloggen ----
ip_fail_count = {}

with open("auth.log") as f:
    for line in f:
        if re.search(r"failed", line, re.IGNORECASE):
            match = re.search(r"(\d{1,3}(.\d{1,3}){3})", line)
            if match:
                ip = match.group(1)
                ip_fail_count[ip] = ip_fail_count.get(ip, 0) + 1
# ---- 4. Riskregler ----
def classify_user(userinfo):
    fails = userinfo["fails"]
    status = userinfo["status"]

    if status == "disabled" and fails > 0:
        return "CRITICAL"
    if fails >= 3:
        return "HIGH RISK"
    if fails >= 1:
        return "MEDIUM RISK"
    return "LOW RISK"


def classify_ip(fails):
    if fails >= 5:
        return "BRUTE FORCE SUSPECT"
    if fails >= 1:
        return "SUSPICIOUS"
    return "LOW"
# ---- 5. Rapportgenerering ----
with open("final_report.txt", "w") as r:

    r.write("=== USER RISK REPORT ===\n")
    for username, info in users.items():
        r.write(f"{username}: {classify_user(info)} (fails={info['fails']}, status={info['status']})\n")

    r.write("\n=== IP RISK REPORT ===\n")
    for ip, count in ip_fail_count.items():
        r.write(f"{ip}: {classify_ip(count)} (fails={count})\n")

print("Analys klar. Se final_report.txt.")
