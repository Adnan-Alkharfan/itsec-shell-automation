import logging
from logging.handlers import RotatingFileHandler
import os

def setup_logger(name="analysis_engine", log_dir="logs", level=logging.INFO):
    # Create logs directory if it doesn't exist
    if not os.path.exists(log_dir):
        os.makedirs(log_dir)

    logger = logging.getLogger(name)
    logger.setLevel(level)

    # Prevent adding multiple handlers if logger already exists
    if logger.handlers:
        return logger

    log_path = os.path.join(log_dir, f"{name}.log")

    handler = RotatingFileHandler(
        log_path,
        maxBytes=5_000_000,   # 5 MB per file
        backupCount=5         # keep 5 old log files
    )

    formatter = logging.Formatter(
        "%(asctime)s - %(levelname)s - %(message)s"
    )

    handler.setFormatter(formatter)
    logger.addHandler(handler)

    return logger
