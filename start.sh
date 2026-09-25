#!/usr/bin/env bash
# ============================================================
# PISCINE PEDAGO - DATA SCIENCE
# Data Science 3 - The present — ASISTENTE GLOBAL (raíz)
#
#   • Estado CSV + entregas
#   • Ejecutar Histogram (y el resto cuando existan)
#
# Uso:  ./start.sh
# Entregas subject: Histogram.* Correlation.* points.*
#                   standardization.* Normalization.* split.*
# ============================================================

set -u

RESET='\033[0m'
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"

print_header() {
    clear
    echo
    echo -e "${CYAN}${BOLD}╔════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}${BOLD}║  PISCINE PEDAGO - DATA SCIENCE - sternero - 42 Málaga      ║${RESET}"
    echo -e "${CYAN}${BOLD}║  Data Science 3 – The present – Asistente GLOBAL           ║${RESET}"
    echo -e "${CYAN}${BOLD}╚════════════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -e "${WHITE}  Script:   ${SCRIPT_DIR}/start.sh${RESET}"
    echo -e "${WHITE}  Proyecto: ${PROJECT_DIR}${RESET}"
    echo
}

pause() { echo; read -r -p "$(echo -e "${CYAN}Pulsa Enter...${RESET}")"; }
section() {
    echo
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}$1${RESET}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
}
ok()   { echo -e "${GREEN}✓ $1${RESET}"; }
warn() { echo -e "${YELLOW}⚠ $1${RESET}"; }
err()  { echo -e "${RED}✗ $1${RESET}"; }
info() { echo -e "${CYAN}→ $1${RESET}"; }

ask_yes_no() {
    local prompt="$1" default="$2" answer
    if [ "$default" = "s" ]; then
        read -r -p "$(echo -e "${YELLOW}${prompt} [S/n] → ${RESET}")" answer
        answer=${answer:-s}
    else
        read -r -p "$(echo -e "${YELLOW}${prompt} [s/N] → ${RESET}")" answer
        answer=${answer:-n}
    fi
    [[ "$answer" =~ ^[sS]$ ]]
}

status_env() {
    section "📊  Estado Module 3"
    for f in data/Train_knight.csv data/Test_knight.csv \
             ex00/Train_knight.csv ex00/Test_knight.csv; do
        if [[ -f "$PROJECT_DIR/$f" ]]; then ok "$f"
        else warn "Falta $f"; fi
    done
    echo
    echo -e "${BOLD}Entregas${RESET}"
    local pairs=(
        "ex00:Histogram.py"
        "ex01:Correlation.py"
        "ex02:points.py"
        "ex03:standardization.py"
        "ex04:Normalization.py"
        "ex05:split.py"
    )
    local p dir file
    for p in "${pairs[@]}"; do
        dir="${p%%:*}"; file="${p##*:}"
        if [[ -f "$PROJECT_DIR/$dir/$file" ]]; then ok "$dir/$file"
        else warn "Pendiente $dir/$file"; fi
    done
    echo
    info "Este menú NO sustituye Histogram.* / … / split.*"
}

run_hist() {
    section "▶️  EX00 – Histogram"
    local dir="$PROJECT_DIR/ex00"
    if [[ ! -f "$dir/Histogram.py" ]]; then err "Sin Histogram.py"; return 1; fi
    echo "  1) ventana   2) solo PNG (Agg)"
    local m
    read -r -p "[1/2] → " m
    if [[ "${m:-1}" == "2" ]]; then
        ( cd "$dir" && MPLBACKEND=Agg python3 Histogram.py )
    else
        ( cd "$dir" && python3 Histogram.py )
    fi
    ok "Fin EX00"
}

main_menu() {
    while true; do
        print_header
        echo -e "  ${BOLD}MENÚ GLOBAL – Module 3 The present${RESET}"
        echo
        echo "  1)  Estado (CSV + entregas)"
        echo "  2)  Ejecutar EX00 Histogram.py"
        echo "  d)  Documentación (rutas)"
        echo "  q)  Salir"
        echo
        local o
        read -r -p "Opción → " o
        case "${o:-}" in
            1) status_env; pause ;;
            2) run_hist; pause ;;
            d|D)
                section "📘  Docs"
                echo "  $PROJECT_DIR/README.md"
                echo "  $PROJECT_DIR/ex00/README.md"
                echo "  $PROJECT_DIR/ex00/python.md"
                pause
                ;;
            q|Q) echo "Hasta luego."; exit 0 ;;
            *) warn "Opción no válida"; pause ;;
        esac
    done
}

print_header
echo -e "Asistente ${BOLD}GLOBAL${RESET} del Module 3 (CSV, sin PostgreSQL)."
echo
if ask_yes_no "¿Ver estado al arrancar?" "s"; then
    status_env
    pause
fi
main_menu
