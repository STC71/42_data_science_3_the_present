#!/usr/bin/env bash
# Module 3 – EX05 Split – menú opcional (NO sustituye split.*)
set -u
RESET=$'\033[0m'; BOLD=$'\033[1m'
RED=$'\033[0;31m'; GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'; CYAN=$'\033[0;36m'
MAGENTA=$'\033[0;35m'

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MODULE3_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
DATA_DIR="$MODULE3_DIR/data"
PY="$SCRIPT_DIR/split.py"

ok(){ echo -e "${GREEN}✓ $1${RESET}"; }
warn(){ echo -e "${YELLOW}⚠ $1${RESET}"; }
err(){ echo -e "${RED}✗ $1${RESET}"; }
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
    echo -e "${CYAN}${BOLD}║  Module 3 – EX05 Split                                     ║${RESET}"
    echo -e "${CYAN}${BOLD}║  sternero – 42 Málaga                                      ║${RESET}"
    echo -e "${CYAN}${BOLD}╚════════════════════════════════════════════════════════════╝${RESET}"
    echo
}

run_split(){
    section "▶️  split.py"
    local src="$DATA_DIR/Train_knight.csv"
    [[ -f "$src" ]] || src="$SCRIPT_DIR/Train_knight.csv"
    [[ -f "$src" ]] || { err "No hay Train_knight.csv"; return 1; }
    ( cd "$SCRIPT_DIR" && python3 split.py "$src" -o "$SCRIPT_DIR" )
    [[ -f "$SCRIPT_DIR/Training_knight.csv" ]] && ok "Training_knight.csv"
    [[ -f "$SCRIPT_DIR/Validation_knight.csv" ]] && ok "Validation_knight.csv"
}

print_header
echo -e "Entrega: ${BOLD}split.*${RESET}"
echo "  1) Ejecutar split  2) Defensa  q) Salir"
while true; do
    read -r -p "Opción → " o
    case "${o:-}" in
        1) run_split; pause; print_header ;;
        2) section "🎓  Defensa"
           echo "  80% Training / 20% Validation · semilla 42 · estratificado por knight"
           pause; print_header ;;
        q|Q) exit 0 ;;
        *) warn "Opción no válida" ;;
    esac
    echo "  1) Ejecutar split  2) Defensa  q) Salir"
done
