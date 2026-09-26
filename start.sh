#!/usr/bin/env bash
# ============================================================
# PISCINE PEDAGO - DATA SCIENCE
# Data Science 3 - The present — ASISTENTE GLOBAL (raíz)
#
# INDEPENDIENTE de ex00…ex05/start.sh
#   • Localizar Train_knight.csv / Test_knight.csv en el sistema
#   • Estado de datos, entregas y dependencias Python
#   • Enlazar/copiar CSV a data/ y a cada ex0N/
#   • Ejecutar Histogram (y el resto cuando existan)
#   • Atajos a menús locales, docs, permisos +x
#
# Uso:
#   ./start.sh
#   /ruta/a/data_science_3_the_present/start.sh
#
# Este menú es AYUDA. Las entregas del subject son:
#   Histogram.*  Correlation.*  points.*
#   standardization.*  Normalization.*  split.*
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
DATA_DIR="$PROJECT_DIR/data"

TRAIN_NAME="Train_knight.csv"
TEST_NAME="Test_knight.csv"

# Rutas resueltas (rellenadas por locate_knight_csvs)
TRAIN_CSV=""
TEST_CSV=""

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

# ------------------------------------------------------------
# Búsqueda automática de Train_knight.csv / Test_knight.csv
# ------------------------------------------------------------
# Orden: data/ del módulo → cada ex0N/ → cwd → monorepo → sgoinfre
# → find limitado bajo HOME/sgoinfre (máx. unos segundos).

_candidate_roots() {
    local login
    login="$(id -un 2>/dev/null || whoami)"
    echo "$PROJECT_DIR/data"
    echo "$PROJECT_DIR"
    local n
    for n in 00 01 02 03 04 05; do
        echo "$PROJECT_DIR/ex${n}"
    done
    echo "$(pwd)"
    echo "$(pwd)/data"
    echo "$PROJECT_DIR/../data_science_3_the_present/data"
    echo "$PROJECT_DIR/../data"
    echo "$HOME/sgoinfre/42_outer_core/piscine_pedago_data_science/data_science_3_the_present/data"
    echo "$HOME/sgoinfre/students/${login}/42_outer_core/piscine_pedago_data_science/data_science_3_the_present/data"
    echo "$HOME/sgoinfre/42_outer_core/piscine_pedago_data_science"
    echo "$HOME/sgoinfre/students/${login}/42_outer_core/piscine_pedago_data_science"
    echo "$HOME/sgoinfre"
    echo "$HOME"
}

_first_existing() {
    local name="$1" root path login
    login="$(id -un 2>/dev/null || whoami)"
    local roots=(
        "$PROJECT_DIR/data"
        "$PROJECT_DIR"
        "$PROJECT_DIR/ex00"
        "$PROJECT_DIR/ex01"
        "$PROJECT_DIR/ex02"
        "$PROJECT_DIR/ex03"
        "$PROJECT_DIR/ex04"
        "$PROJECT_DIR/ex05"
        "$(pwd)"
        "$(pwd)/data"
        "$PROJECT_DIR/../data_science_3_the_present/data"
        "$HOME/sgoinfre/42_outer_core/piscine_pedago_data_science/data_science_3_the_present/data"
        "$HOME/sgoinfre/students/${login}/42_outer_core/piscine_pedago_data_science/data_science_3_the_present/data"
        "$HOME/sgoinfre/42_outer_core/piscine_pedago_data_science"
        "$HOME/sgoinfre/students/${login}/42_outer_core/piscine_pedago_data_science"
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
    # Búsqueda profunda controlada (timeout-ish: maxdepth + paths acotados)
    local name="$1"
    local found=""
    local login
    login="$(id -un 2>/dev/null || whoami)"
    local search_roots=(
        "$PROJECT_DIR"
        "$HOME/sgoinfre/42_outer_core/piscine_pedago_data_science"
        "$HOME/sgoinfre/students/${login}/42_outer_core/piscine_pedago_data_science"
        "$HOME/sgoinfre"
    )
    local r
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

locate_knight_csvs() {
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
    # Exportar por si un script hijo las usa
    export KNIGHT_TRAIN_CSV="${TRAIN_CSV:-}"
    export KNIGHT_TEST_CSV="${TEST_CSV:-}"
}

ensure_data_dir() {
    mkdir -p "$DATA_DIR"
}

# Copia o enlaza los CSV encontrados a data/ y a ex00…ex05 (si existen)
sync_csv_into_project() {
    section "📂  Sincronizar CSV en el módulo"
    locate_knight_csvs
    ensure_data_dir

    if [[ -z "$TRAIN_CSV" || -z "$TEST_CSV" ]]; then
        err "No se localizaron ambos CSV en el sistema."
        [[ -z "$TRAIN_CSV" ]] && warn "Falta $TRAIN_NAME"
        [[ -z "$TEST_CSV" ]] && warn "Falta $TEST_NAME"
        echo
        info "Colócalos en data/ o en cualquier ex0N/ y vuelve a intentar."
        return 1
    fi

    ok "Train: $TRAIN_CSV"
    ok "Test : $TEST_CSV"
    echo

    local dest_train="$DATA_DIR/$TRAIN_NAME"
    local dest_test="$DATA_DIR/$TEST_NAME"

    if [[ "$(cd -- "$(dirname -- "$TRAIN_CSV")" && pwd)/$(basename -- "$TRAIN_CSV")" != "$dest_train" ]]; then
        cp -f "$TRAIN_CSV" "$dest_train"
        ok "Copiado → data/$TRAIN_NAME"
    else
        ok "data/$TRAIN_NAME ya es la fuente"
    fi
    if [[ "$(cd -- "$(dirname -- "$TEST_CSV")" && pwd)/$(basename -- "$TEST_CSV")" != "$dest_test" ]]; then
        cp -f "$TEST_CSV" "$dest_test"
        ok "Copiado → data/$TEST_NAME"
    else
        ok "data/$TEST_NAME ya es la fuente"
    fi

    # Actualizar rutas canónicas
    TRAIN_CSV="$dest_train"
    TEST_CSV="$dest_test"
    export KNIGHT_TRAIN_CSV="$TRAIN_CSV"
    export KNIGHT_TEST_CSV="$TEST_CSV"

    # Propagar a cada ejercicio presente (scripts buscan junto a sí o en ../data)
    local n dir
    for n in 00 01 02 03 04 05; do
        dir="$PROJECT_DIR/ex${n}"
        [[ -d "$dir" ]] || continue
        cp -f "$TRAIN_CSV" "$dir/$TRAIN_NAME"
        cp -f "$TEST_CSV" "$dir/$TEST_NAME"
        ok "ex${n}/ ← CSV"
    done
    echo
    info "Histogram.py y el resto pueden usar ex0N/*.csv o ../data/"
}

# ------------------------------------------------------------
# Estado
# ------------------------------------------------------------
status_python() {
    echo -e "${BOLD}Python / paquetes${RESET}"
    if command -v python3 >/dev/null 2>&1; then
        ok "python3: $(python3 --version 2>&1)"
    else
        err "python3 no está en el PATH"
        return
    fi
    local mod
    for mod in pandas matplotlib numpy; do
        if python3 -c "import $mod" 2>/dev/null; then
            ok "import $mod"
        else
            warn "Falta módulo $mod (pip install --user $mod)"
        fi
    done
    if python3 -c "import sklearn" 2>/dev/null; then
        ok "import sklearn (útil EX03–EX04)"
    else
        warn "sklearn opcional (EX03–EX04): pip install --user scikit-learn"
    fi
}

status_csvs() {
    echo -e "${BOLD}Datos (CSV)${RESET}"
    locate_knight_csvs
    if [[ -n "$TRAIN_CSV" ]]; then
        ok "Train: $TRAIN_CSV"
        local rows
        rows="$(wc -l < "$TRAIN_CSV" 2>/dev/null | tr -d ' ')"
        info "líneas (header+filas) ≈ $rows"
    else
        warn "No se encontró $TRAIN_NAME"
    fi
    if [[ -n "$TEST_CSV" ]]; then
        ok "Test : $TEST_CSV"
        local rows
        rows="$(wc -l < "$TEST_CSV" 2>/dev/null | tr -d ' ')"
        info "líneas (header+filas) ≈ $rows"
    else
        warn "No se encontró $TEST_NAME"
    fi
    if [[ -f "$DATA_DIR/$TRAIN_NAME" ]]; then
        ok "data/$TRAIN_NAME presente"
    else
        warn "data/$TRAIN_NAME aún no sincronizado"
    fi
    if [[ -f "$DATA_DIR/$TEST_NAME" ]]; then
        ok "data/$TEST_NAME presente"
    else
        warn "data/$TEST_NAME aún no sincronizado"
    fi
}

status_deliveries() {
    echo -e "${BOLD}Entregas (subject)${RESET}"
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
        dir="${p%%:*}"
        file="${p##*:}"
        if [[ -f "$PROJECT_DIR/$dir/$file" ]]; then
            ok "$dir/$file"
        else
            warn "Pendiente $dir/$file"
        fi
    done
    echo
    info "Este menú NO sustituye Histogram.* / … / split.*"
}

status_environment() {
    section "📊  Estado del Module 3"
    status_csvs
    echo
    status_python
    echo
    status_deliveries
}

# ------------------------------------------------------------
# Permisos +x
# ------------------------------------------------------------
fix_executable_permissions() {
    section "🔑  Permisos de ejecución (+x)"
    local f
    for f in \
        "$PROJECT_DIR/start.sh" \
        "$PROJECT_DIR"/ex*/start.sh \
        "$PROJECT_DIR"/ex*/*.py
    do
        [[ -f "$f" ]] || continue
        chmod +x "$f" 2>/dev/null && ok "+x $(basename "$(dirname "$f")")/$(basename "$f")" \
            || warn "No se pudo chmod $f"
    done
}

# ------------------------------------------------------------
# Ejecutar ejercicios
# ------------------------------------------------------------
run_exercise() {
    local num="$1"
    local script="$2"
    local title="$3"
    local dir="$PROJECT_DIR/ex${num}"
    section "▶️  EX${num} – ${title}"

    if [[ ! -f "$dir/$script" ]]; then
        err "No está $dir/$script"
        info "Cuando implementes el ejercicio, reaparece aquí."
        return 1
    fi

    # Asegurar CSV junto al script si ya los tenemos
    locate_knight_csvs
    if [[ -n "$TRAIN_CSV" && -n "$TEST_CSV" ]]; then
        cp -f "$TRAIN_CSV" "$dir/$TRAIN_NAME" 2>/dev/null || true
        cp -f "$TEST_CSV" "$dir/$TEST_NAME" 2>/dev/null || true
        # Preferir data/ del módulo si existe
        if [[ -f "$DATA_DIR/$TRAIN_NAME" ]]; then
            cp -f "$DATA_DIR/$TRAIN_NAME" "$dir/$TRAIN_NAME"
            cp -f "$DATA_DIR/$TEST_NAME" "$dir/$TEST_NAME"
        fi
    else
        warn "CSV no localizados: el script puede fallar al abrir datos."
        if ask_yes_no "¿Intentar búsqueda y sincronización ahora?" "s"; then
            sync_csv_into_project || true
        fi
    fi

    echo "  1) ventana (DISPLAY)   2) solo PNG / consola (Agg)"
    local m
    read -r -p "[1/2] → " m
    echo
    if [[ "${m:-1}" == "2" ]]; then
        info "MPLBACKEND=Agg python3 $script"
        ( cd "$dir" && MPLBACKEND=Agg python3 "$script" )
    else
        info "python3 $script"
        ( cd "$dir" && python3 "$script" )
    fi
    echo
    ok "Fin EX${num}"
}

optional_ex_start() {
    local num="$1"
    local dir="$PROJECT_DIR/ex${num}"
    local sh="$dir/start.sh"
    section "▶  Menú local EX${num}"
    if [[ ! -f "$sh" ]]; then
        warn "No hay $sh"
        return 1
    fi
    chmod +x "$sh" 2>/dev/null || true
    info "Lanzando $sh"
    ( cd "$dir" && bash "./start.sh" )
}

# ------------------------------------------------------------
# Documentación y defensa
# ------------------------------------------------------------
show_docs() {
    section "📘  Documentación"
    echo "  Módulo:     $PROJECT_DIR/README.md"
    local n
    for n in 00 01 02 03 04 05; do
        local d="$PROJECT_DIR/ex${n}"
        [[ -d "$d" ]] || continue
        [[ -f "$d/README.md" ]] && echo "  EX${n}:      $d/README.md"
        [[ -f "$d/python.md" ]] && echo "             $d/python.md"
    done
    echo
    echo -e "${BOLD}Subject (entregas)${RESET}"
    echo "  Histogram.*  Correlation.*  points.*"
    echo "  standardization.*  Normalization.*  split.*"
}

eval_reminder() {
    section "🎓  Recordatorio de defensa"
    echo "  • Enseñar Train vs Test (con / sin columna knight)."
    echo "  • EX00: histogramas Test + Train con Jedi/Sith."
    echo "  • EX01: correlación features ↔ target."
    echo "  • EX02: 4 gráficos (separan / mezclan)."
    echo "  • EX03 / EX04: estandarizar y normalizar + gráficos."
    echo "  • EX05: % Training / Validation y porqué."
    echo
    info "Solo se evalúa lo que esté en el git del módulo."
}

# ------------------------------------------------------------
# Menú
# ------------------------------------------------------------
main_menu() {
    while true; do
        print_header
        echo -e "  ${BOLD}MENÚ GLOBAL – Module 3 The present${RESET}"
        echo
        echo -e "  ${CYAN}── Datos y entorno ──${RESET}"
        echo "  1)  Estado (CSV, Python, entregas)"
        echo "  2)  Buscar y sincronizar Train/Test_knight.csv"
        echo "  3)  Permisos +x (start.sh y scripts)"
        echo
        echo -e "  ${CYAN}── Ejecutar ejercicios ──${RESET}"
        echo "  4)  EX00  Histogram.py"
        echo "  5)  EX01  Correlation.py"
        echo "  6)  EX02  points.py"
        echo "  7)  EX03  standardization.py"
        echo "  8)  EX04  Normalization.py"
        echo "  9)  EX05  split.py"
        echo
        echo -e "  ${CYAN}── Atajos y docs ──${RESET}"
        echo "  a)  Menú local EX00 (si existe)"
        echo "  d)  Documentación"
        echo "  e)  Recordatorio de defensa"
        echo "  q)  Salir"
        echo
        local o
        read -r -p "Opción → " o
        case "${o:-}" in
            1) status_environment; pause ;;
            2) sync_csv_into_project; pause ;;
            3) fix_executable_permissions; pause ;;
            4) run_exercise "00" "Histogram.py" "Histogram"; pause ;;
            5) run_exercise "01" "Correlation.py" "Correlation"; pause ;;
            6) run_exercise "02" "points.py" "points"; pause ;;
            7) run_exercise "03" "standardization.py" "standardization"; pause ;;
            8) run_exercise "04" "Normalization.py" "Normalization"; pause ;;
            9) run_exercise "05" "split.py" "Split"; pause ;;
            a|A) optional_ex_start "00"; pause ;;
            d|D) show_docs; pause ;;
            e|E) eval_reminder; pause ;;
            q|Q) echo "Hasta luego."; exit 0 ;;
            *) warn "Opción no válida"; pause ;;
        esac
    done
}

# ------------------------------------------------------------
# Arranque
# ------------------------------------------------------------
print_header
echo -e "Asistente ${BOLD}GLOBAL${RESET} del Module 3 (CSV · sin PostgreSQL)."
echo -e "Los menús ${BOLD}ex0N/start.sh${RESET} siguen disponibles cuando existan."
echo
info "Localizando CSV al arrancar…"
locate_knight_csvs
if [[ -n "$TRAIN_CSV" && -n "$TEST_CSV" ]]; then
    ok "Train: $TRAIN_CSV"
    ok "Test : $TEST_CSV"
else
    warn "CSV incompletos. Usa la opción 2 para buscar y sincronizar."
fi
echo
if ask_yes_no "¿Ver estado al arrancar?" "s"; then
    status_environment
    pause
fi
main_menu
