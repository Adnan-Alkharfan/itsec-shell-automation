import json

# 1) Läs in JSON-fil
with open("events.json", "r", encoding="utf-8") as f:
    data = json.load(f)

events = data["events"]

print("Alla events:")
for e in events:
    print(e)
import json

# 1) Läs in JSON-fil
with open("events.json", "r", encoding="utf-8") as f:
    data = json.load(f)

events = data["events"]

# 2) Räkna failed logins per user
fail_counts = {}

for e in events:
    user = e["user"]
    event_type = e["event"]

    if event_type == "failed_login":
        fail_counts[user] = fail_counts.get(user, 0) + 1

print("\nFailed logins per user:")
for user, count in fail_counts.items():
    print(user, "→", count)
import csv

# 3) Läs in CSV-fil
users = []

with open("users.csv", "r", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        users.append(row)

print("\nUsers from CSV:")
for u in users:
    print(u)
# 4) Funktion för riskklassificering
def classify_risk(fails, status):
    # BONUS-regel först
    if fails >= 1 and status == "disabled":
        return "CRITICAL RISK"

    # Regel 1
    if fails >= 3:
        return "HIGH RISK"

    # Regel 2
    if fails >= 1:
        return "MEDIUM RISK"

    # Regel 3
    return "LOW RISK"
print("\nRisknivåer:")
for u in users:
    name = u["username"]
    status = u["status"]

    fails = fail_counts.get(name, 0)

    risk = classify_risk(fails, status)

    print(f"{name} → {risk} (fails={fails}, status={status})")
