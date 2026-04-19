#!/usr/bin/env python3
# ---------------------------------------------------------
# Filnamn: analysis_engine.py
# Syfte:   Analysmotor som korrelerar Linux- och Windowsdata,
#          identifierar anomalier och genererar slutrapport.
# Output:  final_report.txt
# Författare: Adnan
# Datum: 2026-04-14
# ---------------------------------------------------------

# ---------------------------------------------------------
# Funktion: Enkel avvikelsedetektion (moment 3)
# Syfte:   Identifiera misstänkta värden i loggfilen
# ---------------------------------------------------------
def detect_anomalies():
    anomalies = []

    try:
        with open("../data/anomalies.log", "r") as f:
            lines = f.readlines()
            if len(lines) > 10:
                anomalies.append("För många säkerhetshändelser upptäckta.")
    except FileNotFoundError:
        anomalies.append("Loggfil saknas.")

    return anomalies

def load_linux():
    """Läser linux_output.json"""
    pass

def load_windows():
    """Läser windows_output.csv"""
    pass

def load_anomalies():
    """Läser anomalies.log"""
    pass

def classify_processes():
    """Analyserar processdata"""
    pass

def classify_services():
    """Analyserar tjänstdata"""
    pass

def classify_ip_events():
    """Analyserar nätverks- eller logghändelser"""
    pass

def generate_report():
    """Skapar slutrapporten"""
    pass

def main():
    load_linux()
    load_windows()
    load_anomalies()
    classify_processes()
    classify_services()
    classify_ip_events()
    detect_anomalies()
    generate_report()

main()
