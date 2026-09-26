#!/usr/bin/env bash
# ============================================================
# PISCINE PEDAGO - DATA SCIENCE
# Module 3 – The present – EX00 Histogram
#
# sternero – 42 Málaga – 2026
#
# Asistente opcional (NO sustituye Histogram.*)
# - Localizar Train_knight.csv / Test_knight.csv en el sistema
# - Sincronizar CSV en ex00/ y ../data/
# - Estado: datos, Python, entrega Histogram.py
# - Ejecutar Histogram.py (ventana o solo PNG)
# - Documentación y recordatorio de defensa
#
# Uso:
#   cd /ruta/a/data_science_3_the_present/ex00
#   chmod +x start.sh
#   ./start.sh
#
#   cd ~/sgoinfre/.../piscine_pedago_data_science/data_science_3_the_present/ex00
#   chmod +x start.sh; ./start.sh
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
HIST_PY="$SCRIPT_DIR/Histogram.py"

TRAIN_NAME="Train_knight.csv"
TEST_NAME="Test_knight.csv"
TRAIN_CSV=""
TEST_CSV=""

print_header()
{
    clear
    echo
    echo -e "${CYAN}${BOLD}╔════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}${BOLD}║  Module 3 – The present – EX00 Histogram                   ║${RESET}"
    echo -e "${CYAN}${BOLD}║  sternero – 42 Málaga                                      ║${RESET}"
    echo -e "${CYAN}${BOLD}╚════════════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -e "${WHITE}  $SCRIPT_DIR${RESET}"
    echo
}

ask_yes_no()
{
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

section()
{
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

# ------------------------------------------------------------
# Búsqueda automática de Train_knight.csv / Test_knight.csv
# ------------------------------------------------------------
_first_existing()
{
    local name="$1" root path login
    login="$(id -un 2>/dev/null || whoami)"
    local roots=(
        "$SCRIPT_DIR"
        "$DATA_DIR"
        "$MODULE3_DIR"
        "$MODULE3_DIR/data"
        "$(pwd)"
        "$(pwd)/data"
        "$MODULE3_DIR/../data_science_3_the_present/data"
        "$HOME/sgoinfre/42_outer_core/piscine_pedago_data_science/data_science_3_the_present/data"
        "$HOME/sgoinfre/students/${login}/42_outer_core/piscine_pedago_data_science/data_science_3_the_present/data"
        "$HOME/sgoinfre/42_outer_core/piscine_pedago_data_science/data_science_3_the_present/ex00"
        "$HOME/sgoinfre/students/${login}/42_outer_core/piscine_pedago_data_science/data_science_3_the_present/ex00"
        "$HOME/sgoinfre/42_outer_core/piscine_pedago_data_science"
        "$HOME/sgoinfre/students/${login}/42_outer_core/piscine_pedago_data_science"
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

_find_by_name()
{
    local name="$1" found="" login r
    login="$(id -un 2>/dev/null || whoami)"
    local search_roots=(
        "$MODULE3_DIR"
        "$HOME/sgoinfre/42_outer_core/piscine_pedago_data_science"
        "$HOME/sgoinfre/students/${login}/42_outer_core/piscine_pedago_data_science"
        "$HOME/sgoinfre"
    )
    for r in "${search_roots[@]}"; do
        [[ -d "$r" ]] || continue
        found="$(find "$r" -maxdepth 6 -type f -name "$name" 2>/dev/null | head -n 1 || true)"
        if [[ -n "$found" && -f "$found" ]]; then
            echo "$found"
            return 0
        fi
    done
    return 1
}

locate_knight_csvs()
{
    TRAIN_CSV=""
    TEST_CSV=""
    TRAIN_CSV="$(_first_existing "$TRAIN_NAME" || true)"
    TEST_CSV="$(_first_existing "$TEST_NAME" || true)"
    if [[ -z "$TRAIN_CSV" ]]; then
        TRAIN_CSV="$(_find_by_name "$TRAIN_NAME" || true)"
    fi
    if [[ -z "$TEST_CSV" ]]; then
        TEST_CSV="$(_find_by_name "$TEST_NAME" || true)"
    fi
    export KNIGHT_TRAIN_CSV="${TRAIN_CSV:-}"
    export KNIGHT_TEST_CSV="${TEST_CSV:-}"
}

sync_csv_here()
{
    section "📂  Buscar y sincronizar CSV"
    locate_knight_csvs

    if [[ -z "$TRAIN_CSV" || -z "$TEST_CSV" ]]; then
        err "No se localizaron ambos CSV en el sistema."
        [[ -z "$TRAIN_CSV" ]] && warn "Falta $TRAIN_NAME"
        [[ -z "$TEST_CSV" ]] && warn "Falta $TEST_NAME"
        echo
        info "Colócalos en este directorio (ex00/) o en ../data/ y repite."
        return 1
    fi

    ok "Train: $TRAIN_CSV"
    ok "Test : $TEST_CSV"
    echo

    mkdir -p "$DATA_DIR"

    # Copiar a ex00/ (junto a Histogram.py)
    if [[ "$TRAIN_CSV" != "$SCRIPT_DIR/$TRAIN_NAME" ]]; then
        cp -f "$TRAIN_CSV" "$SCRIPT_DIR/$TRAIN_NAME"
        ok "Copiado → ex00/$TRAIN_NAME"
    else
        ok "ex00/$TRAIN_NAME ya presente"
    fi
    if [[ "$TEST_CSV" != "$SCRIPT_DIR/$TEST_NAME" ]]; then
        cp -f "$TEST_CSV" "$SCRIPT_DIR/$TEST_NAME"
        ok "Copiado → ex00/$TEST_NAME"
    else
        ok "ex00/$TEST_NAME ya presente"
    fi

    # Copia canónica en data/ del módulo
    cp -f "$SCRIPT_DIR/$TRAIN_NAME" "$DATA_DIR/$TRAIN_NAME"
    cp -f "$SCRIPT_DIR/$TEST_NAME" "$DATA_DIR/$TEST_NAME"
    ok "También en data/ del módulo"

    TRAIN_CSV="$SCRIPT_DIR/$TRAIN_NAME"
    TEST_CSV="$SCRIPT_DIR/$TEST_NAME"
    export KNIGHT_TRAIN_CSV="$TRAIN_CSV"
    export KNIGHT_TEST_CSV="$TEST_CSV"
    echo
    info "Histogram.py buscará primero aquí y en ../data/"
}

# ------------------------------------------------------------
# Estado
# ------------------------------------------------------------
status_csvs()
{
    echo -e "${BOLD}Datos (CSV)${RESET}"
    locate_knight_csvs
    if [[ -n "$TRAIN_CSV" ]]; then
        ok "Train: $TRAIN_CSV"
        info "líneas ≈ $(wc -l < "$TRAIN_CSV" | tr -d ' ')"
    else
        warn "No se encontró $TRAIN_NAME"
    fi
    if [[ -n "$TEST_CSV" ]]; then
        ok "Test : $TEST_CSV"
        info "líneas ≈ $(wc -l < "$TEST_CSV" | tr -d ' ')"
    else
        warn "No se encontró $TEST_NAME"
    fi
    if [[ -f "$SCRIPT_DIR/$TRAIN_NAME" ]]; then
        ok "ex00/$TRAIN_NAME (listo para Histogram.py)"
    else
        warn "Aún no está en ex00/ → opción 2 (sincronizar)"
    fi
    if [[ -f "$SCRIPT_DIR/$TEST_NAME" ]]; then
        ok "ex00/$TEST_NAME (listo para Histogram.py)"
    else
        warn "Aún no está en ex00/ → opción 2 (sincronizar)"
    fi
    if [[ -f "$DATA_DIR/$TRAIN_NAME" ]]; then
        ok "data/$TRAIN_NAME"
    else
        warn "Aún no está en data/ → opción 2 (sincronizar)"
    fi
    if [[ -f "$DATA_DIR/$TEST_NAME" ]]; then
        ok "data/$TEST_NAME"
    else
        warn "Aún no está en data/ → opción 2 (sincronizar)"
    fi
}

status_python()
{
    echo -e "${BOLD}Python${RESET}"
    if command -v python3 >/dev/null 2>&1; then
        ok "python3: $(python3 --version 2>&1)"
    else
        err "python3 no está en el PATH"
        return
    fi
    local mod
    local missing=()
    for mod in pandas matplotlib numpy; do
        if python3 -c "import $mod" 2>/dev/null; then
            ok "import $mod"
        else
            warn "Falta $mod"
            missing+=("$mod")
        fi
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo
        info "Instalar: pip install --user ${missing[*]}"
        if ask_yes_no "¿Instalar ahora con pip --user?" "s"; then
            python3 -m pip install --user "${missing[@]}"
            echo
            for mod in "${missing[@]}"; do
                if python3 -c "import $mod" 2>/dev/null; then
                    ok "import $mod (ok)"
                else
                    err "Sigue fallando import $mod"
                fi
            done
        fi
    fi
}

status_delivery()
{
    echo -e "${BOLD}Entrega subject${RESET}"
    if [[ -f "$HIST_PY" ]]; then
        ok "Histogram.py"
    else
        err "Falta Histogram.py (entrega Histogram.*)"
    fi
    info "Este menú NO sustituye Histogram.*"
}

status_env()
{
    section "📊  Estado EX00 – Histogram"
    status_csvs
    echo
    status_python
    echo
    status_delivery
}

# ------------------------------------------------------------
# Ejecutar Histogram.py
# ------------------------------------------------------------
run_histogram()
{
    section "▶️  Ejecutar Histogram.py"
    if [[ ! -f "$HIST_PY" ]]; then
        err "No está $HIST_PY"
        return 1
    fi

    locate_knight_csvs
    if [[ -z "$TRAIN_CSV" || -z "$TEST_CSV" ]]; then
        warn "CSV no localizados."
        if ask_yes_no "¿Buscar y sincronizar ahora?" "s"; then
            sync_csv_here || return 1
        else
            err "Sin datos no se puede ejecutar."
            return 1
        fi
    else
        # Asegurar copia local para el script
        [[ -f "$SCRIPT_DIR/$TRAIN_NAME" ]] || cp -f "$TRAIN_CSV" "$SCRIPT_DIR/$TRAIN_NAME"
        [[ -f "$SCRIPT_DIR/$TEST_NAME" ]] || cp -f "$TEST_CSV" "$SCRIPT_DIR/$TEST_NAME"
        export KNIGHT_TRAIN_CSV="$SCRIPT_DIR/$TRAIN_NAME"
        export KNIGHT_TEST_CSV="$SCRIPT_DIR/$TEST_NAME"
    fi

    echo
    echo "  Histogram.py dibuja:"
    echo "    • Test  → distribución de cada skill"
    echo "    • Train → skills × target knight (Jedi / Sith)"
    echo
    echo "  1) ventana (DISPLAY)   2) solo PNG (Agg)"
    local m
    read -r -p "[1/2] → " m
    echo
    if [[ "${m:-1}" == "2" ]]; then
        info "MPLBACKEND=Agg python3 Histogram.py"
        ( cd "$SCRIPT_DIR" && MPLBACKEND=Agg python3 Histogram.py )
    else
        info "python3 Histogram.py"
        ( cd "$SCRIPT_DIR" && python3 Histogram.py )
    fi
    echo
    if [[ -f "$SCRIPT_DIR/histogram_test.png" ]]; then
        ok "histogram_test.png"
    else
        warn "No se generó histogram_test.png"
    fi
    if [[ -f "$SCRIPT_DIR/histogram_train.png" ]]; then
        ok "histogram_train.png"
    else
        warn "No se generó histogram_train.png"
    fi
    ok "Fin Histogram"
}

check_delivery()
{
    section "📋  Verificar entrega"
    if [[ -f "$HIST_PY" ]]; then
        ok "ex00/Histogram.py presente"
    else
        err "Falta Histogram.py — subject: Files to turn in : Histogram.*"
    fi
    [[ -f "$SCRIPT_DIR/README.md" ]] && ok "README.md" || warn "README.md opcional"
    [[ -f "$SCRIPT_DIR/python.md" ]] && ok "python.md" || warn "python.md opcional"
    echo
    info "En el git del módulo debe estar Histogram.* (y lo que el subject permita)."
}

show_docs()
{
    section "📘  Documentación"
    echo "  README:  $SCRIPT_DIR/README.md"
    echo "  Guía:    $SCRIPT_DIR/python.md"
    echo "  Module:  $MODULE3_DIR/README.md"
    echo
    echo -e "${BOLD}Subject EX00${RESET}"
    echo "  • Histograma(s) con Test_knight.csv"
    echo "  • Histograma(s) con Train_knight.csv (skills × knight)"
    echo "  Entrega: Histogram.*"
}

eval_reminder()
{
    section "🎓  Defensa (EX00)"
    echo "  1. Test no tiene columna knight → solo distribución de skills."
    echo "  2. Train sí → superponer Jedi / Sith para ver qué features separan."
    echo "  3. Mostrar los PNG o la ventana de matplotlib."
    echo
    info "Solo se evalúa lo del repositorio git."
}

fix_permissions()
{
    section "🔑  Permisos +x"
    chmod +x "$SCRIPT_DIR/start.sh" 2>/dev/null && ok "start.sh" || warn "start.sh"
    chmod +x "$HIST_PY" 2>/dev/null && ok "Histogram.py" || warn "Histogram.py"
}

# ------------------------------------------------------------
# Menú
# ------------------------------------------------------------
show_menu()
{
    echo -e "${CYAN}${BOLD}  MENÚ EX00 – Histogram${RESET}"
    echo
    echo "  1)  Estado (CSV, Python, entrega)"
    echo "  2)  Buscar y sincronizar Train/Test_knight.csv"
    echo "  3)  Ejecutar Histogram.py"
    echo "  4)  Verificar entrega Histogram.*"
    echo "  5)  Documentación"
    echo "  6)  Recordatorio de defensa"
    echo "  7)  Permisos +x"
    echo "  q)  Salir"
    echo
}

menu_loop()
{
    local o
    while true; do
        print_header
        echo -e "Asistente EX00 · Test + Train histograms (skills × knight)"
        echo -e "Entrega: ${BOLD}Histogram.*${RESET} (este menú no sustituye la entrega)"
        echo
        show_menu
        read -r -p "Opción → " o
        case "${o:-}" in
            1) status_env; pause ;;
            2) sync_csv_here; pause ;;
            3) run_histogram; pause ;;
            4) check_delivery; pause ;;
            5) show_docs; pause ;;
            6) eval_reminder; pause ;;
            7) fix_permissions; pause ;;
            q|Q) echo "Hasta luego."; exit 0 ;;
            *) warn "Opción no válida"; pause ;;
        esac
    done
}

# --- main ---
print_header
echo -e "Asistente ${BOLD}EX00 Histogram${RESET} (Module 3)."
echo -e "Busca ${BOLD}Train_knight.csv${RESET} y ${BOLD}Test_knight.csv${RESET} en el sistema si hace falta."
echo
info "Localizando CSV…"
locate_knight_csvs
if [[ -n "$TRAIN_CSV" && -n "$TEST_CSV" ]]; then
    ok "Train: $TRAIN_CSV"
    ok "Test : $TEST_CSV"
    # Si están en el sistema pero no junto a Histogram.py, ofrecer copia
    if [[ ! -f "$SCRIPT_DIR/$TRAIN_NAME" || ! -f "$SCRIPT_DIR/$TEST_NAME" ]]; then
        echo
        warn "Están fuera de ex00/ (Histogram.py los busca aquí o en ../data/)."
        if ask_yes_no "¿Copiar ahora a ex00/ y a data/?" "s"; then
            sync_csv_here
        fi
    fi
else
    warn "CSV incompletos → opción 2 del menú"
fi
echo
if ask_yes_no "¿Ver estado al arrancar?" "s"; then
    status_env
    pause
fi
menu_loop
