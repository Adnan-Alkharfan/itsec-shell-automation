from utils import setup_logger

logger = setup_logger()

def detect_high_cpu(processes, threshold=80):
    anomalies = []

    for p in processes:
        cpu = p.get("cpu", 0)
        name = p.get("name", "unknown")

        if cpu > threshold:
            msg = f"High CPU detected: {name} ({cpu}%)"
            anomalies.append(msg)
            logger.warning(msg)

    return anomalies
