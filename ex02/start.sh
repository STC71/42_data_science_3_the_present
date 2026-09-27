#!/usr/bin/env bash
# Module 3 – EX02 points – menú opcional (NO sustituye points.*)
set -u
RESET=$'\033[0m'; BOLD=$'\033[1m'
RED=$'\033[0;31m'; GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'; CYAN=$'\033[0;36m'
MAGENTA=$'\033[0;35m'; WHITE=$'\033[1;37m'

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MODULE3_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
DATA_DIR="$MODULE3_DIR/data"
PY="$SCRIPT_DIR/points.py"

print_header() {
    clear
    echo
    echo -e "${CYAN}${BOLD}╔════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}${BOLD}║  Module 3 – The present – EX02 points                      ║${RESET}"
    echo -e "${CYAN}${BOLD}║  sternero – 42 Málaga                                      ║${RESET}"
    echo -e "${CYAN}${BOLD}╚════════════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -e "${WHITE}  $SCRIPT_DIR${RESET}"
    echo
}
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
ask_yes_no(){
    local p="$1" d="$2" a
    if [ "$d" = "s" ]; then read -r -p "$(echo -e "${YELLOW}${p} [S/n] → ${RESET}")" a; a=${a:-s}
    else read -r -p "$(echo -e "${YELLOW}${p} [s/N] → ${RESET}")" a; a=${a:-n}; fi
    [[ "$a" =~ ^[sS]$ ]]
}

status_env(){
    section "📊  Estado EX02"
    for f in Train_knight.csv Test_knight.csv; do
        if [[ -f "$DATA_DIR/$f" ]]; then ok "data/$f"
        else warn "Falta data/$f (usa start.sh de ex00 opción 2)"; fi
    done
    [[ -f "$PY" ]] && ok "points.py" || err "Falta points.py"
    command -v python3 >/dev/null && ok "python3 $(python3 --version 2>&1)" || err "sin python3"
    for m in pandas matplotlib numpy; do
        python3 -c "import $m" 2>/dev/null && ok "import $m" || warn "Falta $m"
    done
}

run_points(){
    section "▶️  points.py"
    [[ -f "$PY" ]] || { err "Sin points.py"; return 1; }
    if [[ ! -f "$DATA_DIR/Train_knight.csv" || ! -f "$DATA_DIR/Test_knight.csv" ]]; then
        err "CSV no están en data/. Sincroniza desde ex00 o copia a data/."
        return 1
    fi
    export KNIGHT_TRAIN_CSV="$DATA_DIR/Train_knight.csv"
    export KNIGHT_TEST_CSV="$DATA_DIR/Test_knight.csv"
    echo "  1) ventana   2) solo PNG (Agg)"
    local m; read -r -p "[1/2] → " m
    if [[ "${m:-1}" == "2" ]]; then
        ( cd "$SCRIPT_DIR" && MPLBACKEND=Agg python3 points.py )
    else
        ( cd "$SCRIPT_DIR" && python3 points.py )
    fi
    [[ -f "$SCRIPT_DIR/points.png" ]] && ok "points.png" || warn "Sin points.png"
}

show_docs(){
    section "📘  Docs"
    echo "  $SCRIPT_DIR/README.md"
    echo "  $SCRIPT_DIR/python.md"
    echo "  4 scatters: Train sep/mix + Test mismos ejes"
}

eval_rem(){
    section "🎓  Defensa"
    echo "  • Separación: skills ligadas al bando (Awareness×Strength)."
    echo "  • Mezcla: skills casi independientes (Push×Mass)."
    echo "  • Test sin etiqueta → un color."
}

print_header
echo -e "Entrega: ${BOLD}points.*${RESET}"
echo
echo -e "${CYAN}${BOLD}  MENÚ EX02 – points${RESET}"
echo "  1) Estado  2) Ejecutar  3) Docs  4) Defensa  q) Salir"
echo
while true; do
    read -r -p "Opción → " o
    case "${o:-}" in
        1) status_env; pause; print_header ;;
        2) run_points; pause; print_header ;;
        3) show_docs; pause; print_header ;;
        4) eval_rem; pause; print_header ;;
        q|Q) echo "Hasta luego."; exit 0 ;;
        *) warn "Opción no válida" ;;
    esac
    echo -e "${CYAN}${BOLD}  MENÚ EX02 – points${RESET}"
    echo "  1) Estado  2) Ejecutar  3) Docs  4) Defensa  q) Salir"
    echo
done
