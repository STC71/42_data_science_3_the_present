#!/usr/bin/env bash
# Module 3 – EX03 standardization – menú opcional (NO sustituye standardization.*)
set -u
RESET=$'\033[0m'; BOLD=$'\033[1m'
RED=$'\033[0;31m'; GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'; CYAN=$'\033[0;36m'
MAGENTA=$'\033[0;35m'

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MODULE3_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
DATA_DIR="$MODULE3_DIR/data"
PY="$SCRIPT_DIR/standardization.py"

ok(){ echo -e "${GREEN}✓ $1${RESET}"; }
warn(){ echo -e "${YELLOW}⚠ $1${RESET}"; }
err(){ echo -e "${RED}✗ $1${RESET}"; }
info(){ echo -e "${CYAN}→ $1${RESET}"; }
pause(){ echo; read -r -p "$(echo -e "${CYAN}Pulsa Enter...${RESET}")"; }
section(){
    echo
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}$1${RESET}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
}

print_header(){
    clear
    echo
    echo -e "${CYAN}${BOLD}╔════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}${BOLD}║  Module 3 – EX03 standardization                           ║${RESET}"
    echo -e "${CYAN}${BOLD}║  sternero – 42 Málaga                                      ║${RESET}"
    echo -e "${CYAN}${BOLD}╚════════════════════════════════════════════════════════════╝${RESET}"
    echo
}

status_env(){
    section "📊  Estado"
    for f in Train_knight.csv Test_knight.csv; do
        [[ -f "$DATA_DIR/$f" ]] && ok "data/$f" || warn "Falta data/$f"
    done
    [[ -f "$PY" ]] && ok "standardization.py" || err "Falta script"
    command -v python3 >/dev/null && ok "python3" || err "sin python3"
}

run_std(){
    section "▶️  standardization.py"
    [[ -f "$PY" ]] || { err "Sin script"; return 1; }
    export KNIGHT_TRAIN_CSV="$DATA_DIR/Train_knight.csv"
    export KNIGHT_TEST_CSV="$DATA_DIR/Test_knight.csv"
    echo "  1) ventana  2) solo PNG (Agg)"
    local m; read -r -p "[1/2] → " m
    if [[ "${m:-2}" == "1" ]]; then
        ( cd "$SCRIPT_DIR" && python3 standardization.py )
    else
        ( cd "$SCRIPT_DIR" && MPLBACKEND=Agg python3 standardization.py )
    fi
}

print_header
echo -e "Entrega: ${BOLD}standardization.*${RESET}"
echo "  1) Estado  2) Ejecutar  3) Defensa  q) Salir"
while true; do
    read -r -p "Opción → " o
    case "${o:-}" in
        1) status_env; pause; print_header ;;
        2) run_std; pause; print_header ;;
        3) section "🎓  Defensa"
           echo "  z = (x - mean) / std por skill; print antes/después;"
           echo "  scatter EX02 (Awareness×Strength) con valores z."
           pause; print_header ;;
        q|Q) exit 0 ;;
        *) warn "Opción no válida" ;;
    esac
    echo "  1) Estado  2) Ejecutar  3) Defensa  q) Salir"
done
