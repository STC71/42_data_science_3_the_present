#!/usr/bin/env bash
# ============================================================
#  PISCINE PEDAGO - DATA SCIENCE
#  Module 3 - The present - EX00 Histogram
#  sternero - 42 Málaga
# ============================================================
set -u
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

print_header() {
  clear
  echo -e "${CYAN}"
  echo "╔════════════════════════════════════════════════════════════╗"
  echo "║  Module 3 – The present – EX00 Histogram                   ║"
  echo "║  sternero – 42 Málaga                                      ║"
  echo "╚════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"
  echo -e "  ${BOLD}${SCRIPT_DIR}${NC}"
  echo
}

status() {
  echo -e "${BOLD}Estado${NC}"
  for f in Histogram.py Train_knight.csv Test_knight.csv; do
    if [[ -f "$f" ]]; then echo -e "  ${GREEN}✓${NC} $f"
    else echo -e "  ${YELLOW}⚠${NC} falta $f"; fi
  done
  echo
}

run_hist() {
  echo -e "${BOLD}Ejecutar Histogram.py${NC}"
  echo "  1) ventana   2) solo PNG (Agg)"
  read -r -p "[1/2] → " m
  if [[ "${m:-1}" == "2" ]]; then
    MPLBACKEND=Agg python3 Histogram.py
  else
    python3 Histogram.py
  fi
}

print_header
echo -e "Asistente EX00 · Test + Train histograms (skills × knight)"
echo -e "Entrega: ${BOLD}Histogram.*${NC} (este menú no sustituye la entrega)"
echo
status
while true; do
  echo "  1) Estado"
  echo "  2) Ejecutar Histogram.py"
  echo "  3) Documentación (README / python.md)"
  echo "  q) Salir"
  read -r -p "Opción → " o
  case "${o:-}" in
    1) status ;;
    2) run_hist ;;
    3) echo "  README.md · python.md en este directorio" ;;
    q|Q) echo "Hasta luego."; exit 0 ;;
    *) echo "Opción no válida" ;;
  esac
  echo
done
