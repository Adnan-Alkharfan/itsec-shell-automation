#!/bin/bash
# ---------------------------------------------------------
# Exempel: Enkel processkontroll i Bash
# Syfte:   Visa hur Bash används för systemnära kontroller
# ---------------------------------------------------------

# Hämtar aktiva processer
processes=$(ps aux)

# Filtrerar processer som använder mycket CPU
echo "$processes" | awk '$3 > 20 {print $0}'
