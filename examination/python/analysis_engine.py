#!/usr/bin/env python3
# ---------------------------------------------------------
# Filnamn: analysis_engine.py
# Syfte:   Analysmotor som korrelerar Linux- och Windowsdata,
#          identifierar anomalier och genererar slutrapport.
# Output:  final_report.txt
# Författare: Adnan
# Datum: 2026-04-14
# ---------------------------------------------------------

import json
import csv

# ---------------------------------------------------------
# Funktion: Enkel avvikelsedetektion (moment 3)
# ---------------------------------------------------------
def detect_anomalies(linux_data, windows_data):
    anomalies = []

    try:
        with open("../data/anomalies.log", "r") as f:
            lines = f.readlines()
            if len(lines) > 10:
                anomalies.append("För många säkerhetshändelser upptäckta.")
    except FileNotFoundError:
        anomalies.append("Loggfil saknas.")

    return anomalies


# ---------------------------------------------------------
# Moment 4 – Ladda data
# ---------------------------------------------------------
def load_linux():
    try:
        with open("../data/linux_output.json", "r") as f:
            return json.load(f)
    except:
        return {}

def load_windows():
    try:
        with open("../data/windows_output.csv", "r") as f:
            reader = csv.DictReader(f)
            return list(reader)
    except:
        return []

def load_anomalies():
    try:
        with open("../data/anomalies.log", "r") as f:
            return f.readlines()
    except:
        return []


# ---------------------------------------------------------
# Klassificeringsfunktioner (moment 1 placeholders)
# ---------------------------------------------------------
def classify_processes(linux_data):
    pass

def classify_services(windows_data):
    pass

def classify_ip_events(linux_data):
    pass


# ---------------------------------------------------------
# Rapportgenerator (moment 4)
# ---------------------------------------------------------
def generate_report(linux_data, windows_data, anomalies):
    with open("../data/final_report.txt", "w") as f:
        f.write("=== Slutrapport – Moment 4 ===\n\n")

        f.write("Antal Linux-processer: ")
        f.write(str(len(linux_data.get("processes", []))) + "\n")

        f.write("Antal Windows-tjänster: ")
        f.write(str(len(windows_data)) + "\n\n")

        f.write("Anomalier:\n")
        if anomalies:
            for a in anomalies:
                f.write("- " + a + "\n")
        else:
            f.write("Inga anomalier upptäckta.\n")


# ---------------------------------------------------------
# Huvudflöde – Moment 4 komplett
# ---------------------------------------------------------
def main():
    linux_data = load_linux()
    windows_data = load_windows()
    anomaly_lines = load_anomalies()

    classify_processes(linux_data)
    classify_services(windows_data)
    classify_ip_events(linux_data)

    anomalies = detect_anomalies(linux_data, windows_data)

    generate_report(linux_data, windows_data, anomalies)


main()
