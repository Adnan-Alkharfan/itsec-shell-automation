from utils import setup_logger
import json
from datetime import datetime
from detectors import detect_high_cpu

logger = setup_logger()
logger.info("Starting analysis engine...")

linux_path = "../../data/linux_output.json"
windows_path = "../../data/windows_output.json"
output_path = "../../data/combined_report.json"


print("Läser JSON-filer...")

# Läs Linux JSON

try:
    with open(linux_path, "r", encoding="utf-8") as f:
        linux_data = json.load(f)
except Exception as e:
    logger.error(f"Failed to parse Linux JSON: {e}")
    raise

# Läs Windows JSON

try:
    with open(windows_path, "r", encoding="utf-8") as f:
        windows_data = json.load(f)
except Exception as e:
    logger.error(f"Failed to parse Windows JSON: {e}")
    raise

print("Analyserar data...")
linux_anomalies = detect_high_cpu(linux_data.get("processes", []))
windows_anomalies = detect_high_cpu(windows_data.get("processes", []))

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
    "linux_anomalies": linux_anomalies,
    "windows_anomalies": windows_anomalies
}

with open(output_path, "w", encoding="utf-8") as f:
    json.dump(combined, f, indent=4)

print("Klar! Rapport sparad i combined_report.json")
logger.info("Analysis completed successfully.")
