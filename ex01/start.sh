#!/usr/bin/env bash
# ============================================================
# PISCINE PEDAGO - DATA SCIENCE
# Module 3 – The present – EX01 Correlation
#
# sternero – 42 Málaga – 2026
#
# Asistente opcional (NO sustituye Correlation.*)
# - Localizar / sincronizar Train_knight.csv
# - Estado Python + entrega
# - Ejecutar Correlation.py
# - Docs y defensa
#
# Uso:
#   cd .../data_science_3_the_present/ex01
#   chmod +x start.sh && ./start.sh
# ============================================================

set -u

RESET=$'\033[0m'
BOLD=$'\033[1m'
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
CYAN=$'\033[0;36m'
MAGENTA=$'\033[0;35m'
WHITE=$'\033[1;37m'

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MODULE3_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
DATA_DIR="$MODULE3_DIR/data"
CORR_PY="$SCRIPT_DIR/Correlation.py"
TRAIN_NAME="Train_knight.csv"
TRAIN_CSV=""

print_header() {
    clear
    echo
    echo -e "${CYAN}${BOLD}╔════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}${BOLD}║  Module 3 – The present – EX01 Correlation                 ║${RESET}"
    echo -e "${CYAN}${BOLD}║  sternero – 42 Málaga                                      ║${RESET}"
    echo -e "${CYAN}${BOLD}╚════════════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -e "${WHITE}  $SCRIPT_DIR${RESET}"
    echo
}

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

_first_existing() {
    local name="$1" root path login
    login="$(id -un 2>/dev/null || whoami)"
    local roots=(
        "$SCRIPT_DIR" "$DATA_DIR" "$MODULE3_DIR" "$MODULE3_DIR/data"
        "$(pwd)" "$(pwd)/data"
        "$HOME/sgoinfre/42_outer_core/piscine_pedago_data_science/data_science_3_the_present"
        "$HOME/sgoinfre/42_outer_core/piscine_pedago_data_science/data_science_3_the_present/data"
        "$HOME/sgoinfre/42_outer_core/piscine_pedago_data_science/data_science_3_the_present/ex00"
        "$HOME/sgoinfre/42_outer_core/piscine_pedago_data_science/data_science_3_the_present/ex01"
        "$HOME/sgoinfre/students/${login}/42_outer_core/piscine_pedago_data_science/data_science_3_the_present"
        "$HOME/sgoinfre"
    )
    for root in "${roots[@]}"; do
        [[ -z "$root" || ! -d "$root" ]] && continue
        path="$root/$name"
        if [[ -f "$path" ]]; then
            echo "$(cd -- "$(dirname -- "$path")" && pwd)/$(basename -- "$path")"
            return 0
        fi
    done
    return 1
}

_find_by_name() {
    local name="$1" found="" r login
    login="$(id -un 2>/dev/null || whoami)"
    for r in "$MODULE3_DIR" \
             "$HOME/sgoinfre/42_outer_core/piscine_pedago_data_science" \
             "$HOME/sgoinfre/students/${login}/42_outer_core/piscine_pedago_data_science" \
             "$HOME/sgoinfre"
    do
        [[ -d "$r" ]] || continue
        found="$(find "$r" -maxdepth 6 -type f -name "$name" 2>/dev/null | head -n 1 || true)"
        [[ -n "$found" && -f "$found" ]] && { echo "$found"; return 0; }
    done
    return 1
}

locate_train() {
    TRAIN_CSV="$(_first_existing "$TRAIN_NAME" || true)"
    [[ -z "$TRAIN_CSV" ]] && TRAIN_CSV="$(_find_by_name "$TRAIN_NAME" || true)"
    export KNIGHT_TRAIN_CSV="${TRAIN_CSV:-}"
}

sync_train() {
    section "📂  Buscar y dejar Train en data/ (fuente del módulo)"
    locate_train
    if [[ -z "$TRAIN_CSV" ]]; then
        err "No se encontró $TRAIN_NAME"
        return 1
    fi
    ok "Fuente hallada: $TRAIN_CSV"
    mkdir -p "$DATA_DIR"
    # Una sola copia canónica: data/ del módulo (como tras EX00)
    if [[ "$TRAIN_CSV" != "$DATA_DIR/$TRAIN_NAME" ]]; then
        cp -f "$TRAIN_CSV" "$DATA_DIR/$TRAIN_NAME"
        ok "Copiado → data/$TRAIN_NAME"
    else
        ok "Ya está en data/"
    fi
    TRAIN_CSV="$DATA_DIR/$TRAIN_NAME"
    export KNIGHT_TRAIN_CSV="$TRAIN_CSV"
    info "Correlation.py lee desde data/ (no hace falta CSV dentro de ex01/)"
}

status_env() {
    section "📊  Estado EX01 – Correlation"
    locate_train
    echo -e "${BOLD}Datos${RESET}"
    if [[ -n "$TRAIN_CSV" ]]; then
        ok "Train: $TRAIN_CSV"
    else
        warn "Falta $TRAIN_NAME"
    fi
    if [[ -f "$DATA_DIR/$TRAIN_NAME" ]]; then
        ok "data/$TRAIN_NAME (fuente canónica)"
    else
        warn "Falta data/$TRAIN_NAME → opción 2"
    fi
    echo
    echo -e "${BOLD}Python${RESET}"
    if command -v python3 >/dev/null 2>&1; then
        ok "python3: $(python3 --version 2>&1)"
    else
        err "sin python3"
    fi
    local mod missing=()
    for mod in pandas numpy; do
        if python3 -c "import $mod" 2>/dev/null; then ok "import $mod"
        else warn "Falta $mod"; missing+=("$mod"); fi
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        if ask_yes_no "¿pip install --user ${missing[*]}?" "s"; then
            python3 -m pip install --user "${missing[@]}"
        fi
    fi
    echo
    echo -e "${BOLD}Entrega${RESET}"
    [[ -f "$CORR_PY" ]] && ok "Correlation.py" || err "Falta Correlation.py"
    info "Este menú NO sustituye Correlation.*"
}

run_corr() {
    section "▶️  Correlation.py"
    [[ -f "$CORR_PY" ]] || { err "Sin Correlation.py"; return 1; }
    locate_train
    if [[ -z "$TRAIN_CSV" ]] || [[ ! -f "$DATA_DIR/$TRAIN_NAME" ]]; then
        warn "Sin Train en data/"
        if ask_yes_no "¿Buscar y colocar en data/ ahora?" "s"; then
            sync_train || return 1
        else
            return 1
        fi
    fi
    export KNIGHT_TRAIN_CSV="$DATA_DIR/$TRAIN_NAME"
    info "Usando $KNIGHT_TRAIN_CSV"
    info "python3 Correlation.py"
    ( cd "$SCRIPT_DIR" && python3 Correlation.py )
    ok "Fin EX01"
}

show_docs() {
    section "📘  Docs"
    echo "  $SCRIPT_DIR/README.md"
    echo "  $SCRIPT_DIR/python.md"
    echo "  Subject: Correlation.* · target knight · features"
}

eval_reminder() {
    section "🎓  Defensa"
    echo "  • Pearson entre cada skill y knight (0/1)."
    echo "  • Lista ordenada: arriba = más relacionadas con el bando."
    echo "  • Solo Train (Test no tiene etiqueta)."
}

show_menu() {
    echo -e "${CYAN}${BOLD}  MENÚ EX01 – Correlation${RESET}"
    echo
    echo "  1)  Estado"
    echo "  2)  Buscar / sincronizar Train_knight.csv"
    echo "  3)  Ejecutar Correlation.py"
    echo "  4)  Documentación"
    echo "  5)  Recordatorio de defensa"
    echo "  q)  Salir"
    echo
}

menu_loop() {
    local o
    while true; do
        print_header
        echo -e "Entrega: ${BOLD}Correlation.*${RESET} (menú = ayuda)"
        echo
        show_menu
        read -r -p "Opción → " o
        case "${o:-}" in
            1) status_env; pause ;;
            2) sync_train; pause ;;
            3) run_corr; pause ;;
            4) show_docs; pause ;;
            5) eval_reminder; pause ;;
            q|Q) echo "Hasta luego."; exit 0 ;;
            *) warn "Opción no válida"; pause ;;
        esac
    done
}

print_header
info "Localizando Train…"
locate_train
[[ -n "$TRAIN_CSV" ]] && ok "$TRAIN_CSV" || warn "Sin Train → opción 2"
echo
if ask_yes_no "¿Ver estado al arrancar?" "s"; then status_env; pause; fi
menu_loop
