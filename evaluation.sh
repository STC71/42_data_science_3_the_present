#!/usr/bin/env bash
###############################################################################
#  DATA SCIENCE 3 – The present · evaluation.sh
#
#  Guía interactiva de defensa basada en:
#    · en.subject.pdf  (Training Piscine datascience - 3 · The present)
#    · evaluation_en_3.pdf  (hoja /PROJECTS/DATA-SCIENCE-3)
#
#  Este fichero NO es entregable del subject ni forma parte de la nota.
#  Solo ayuda a prepararse y a recorrer la defensa paso a paso.
#
#  Uso (desde la raíz del repo del evaluado):
#    chmod +x evaluation.sh
#    ./evaluation.sh
#
#  sternero – 42 Málaga – Octubre 2026
###############################################################################

set -u
# no set -e: un fallo de comprobación no debe abortar toda la defensa

# ============================================================================
# COLORES Y FORMATO
# ============================================================================
readonly RED=$'\033[0;31m'
readonly GREEN=$'\033[0;32m'
readonly YELLOW=$'\033[1;33m'
readonly BLUE=$'\033[0;34m'
readonly CYAN=$'\033[0;36m'
readonly MAGENTA=$'\033[0;35m'
readonly BOLD=$'\033[1m'
readonly DIM=$'\033[2m'
readonly RESET=$'\033[0m'

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

declare -A RESULT
PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0
LAST_KIND="info"
LAST_TEXT="Evaluación iniciada"

# ============================================================================
# SALIDA
# ============================================================================
header() {
  clear 2>/dev/null || true
  echo -e "${BOLD}${YELLOW}"
  echo "╔══════════════════════════════════════════════════════════════════╗"
  echo "║  DATA SCIENCE 3 – The present · DEFENSA / EVALUACIÓN             ║"
  echo "║  Hoja: /PROJECTS/DATA-SCIENCE-3                                  ║"
  echo "║  Guía: evaluation.sh (NO es entregable ni parte de la nota)      ║"
  echo "║  sternero – 42 Málaga – Octubre 2026                             ║"
  echo "╚══════════════════════════════════════════════════════════════════╝"
  echo -e "${RESET}"
  echo -e "  ${DIM}Repo: ${SCRIPT_DIR}${RESET}"
  echo -e "  ${DIM}Login: $(id -un 2>/dev/null || whoami) · $(date '+%Y-%m-%d %H:%M')${RESET}"
  if [[ -n "${LAST_TEXT:-}" ]]; then
    case "${LAST_KIND:-info}" in
      ok)   echo -e "  ${GREEN}✅ Último: ${LAST_TEXT}${RESET}" ;;
      fail) echo -e "  ${RED}❌ Último: ${LAST_TEXT}${RESET}" ;;
      warn) echo -e "  ${YELLOW}⚠ Último: ${LAST_TEXT}${RESET}" ;;
      *)    echo -e "  ${DIM}→ ${LAST_TEXT}${RESET}" ;;
    esac
  fi
  echo -e "  ${DIM}Acumulado: OK=${PASS_COUNT} · Errores=${FAIL_COUNT} · Avisos=${WARN_COUNT}${RESET}"
  echo
}

section() {
  echo
  echo
  echo -e "${BOLD}${CYAN}▶ $1${RESET}"
  echo -e "${DIM}────────────────────────────────────────────────────────────────${RESET}"
}

subsection() { echo -e "  ${MAGENTA}├─ $1${RESET}"; }

ok() {
  echo -e "    ${GREEN}✓${RESET} $1"
  PASS_COUNT=$((PASS_COUNT + 1))
  LAST_KIND="ok"
  LAST_TEXT="$1"
}

fail() {
  echo -e "    ${RED}✗${RESET} $1"
  FAIL_COUNT=$((FAIL_COUNT + 1))
  LAST_KIND="fail"
  LAST_TEXT="$1"
}

warn() {
  echo -e "    ${YELLOW}⚠${RESET} $1"
  WARN_COUNT=$((WARN_COUNT + 1))
  LAST_KIND="warn"
  LAST_TEXT="$1"
}

note()  { echo -e "    ${DIM}→ $1${RESET}"; }
ctx()   { echo -e "  ${DIM}$1${RESET}"; }
ctx_blank() { echo; }

requirement() {
  echo -e "    ${BLUE}▸ Criterio (hoja de evaluación):${RESET} $1"
}

show_cmd() {
  echo -e "    ${DIM}\$${RESET} ${BOLD}$1${RESET}"
}

pause() {
  echo
  read -r -p "  Pulsa Enter para continuar… " _
  header
  note "Continuación de la defensa (no es un reinicio)."
}

# ============================================================================
# PREGUNTAS
# ============================================================================
ask_yes_no() {
  # Uso: ask_yes_no "pregunta"  →  s/n  (default n)
  local prompt="$1"
  local ans
  read -r -p "  ${prompt} [s/N] → " ans || true
  ans="${ans:-n}"
  case "${ans}" in
    s|S|y|Y|si|sí|Si|Sí) return 0 ;;
    *) return 1 ;;
  esac
}

ask_scale() {
  # Pregunta de la hoja: s = Yes, n = No, k = omitir
  local key="$1"
  local question="$2"
  local ans
  echo
  echo -e "  ${BOLD}${question}${RESET}"
  read -r -p "  s/n  (k=omitir) → " ans || true
  ans="${ans:-}"
  case "${ans}" in
    s|S|y|Y)
      RESULT["$key"]="yes"
      ok "Marcado Yes en hoja: $key"
      ;;
    n|N)
      RESULT["$key"]="no"
      fail "Marcado No en hoja: $key"
      ;;
    k|K|"")
      RESULT["$key"]="skip"
      warn "Omitido: $key"
      ;;
    *)
      RESULT["$key"]="skip"
      warn "Respuesta no reconocida; omitido: $key"
      ;;
  esac
}

# ============================================================================
# MATPLOTLIB / ENTORNO 42
# ============================================================================
matplotlib_env() {
  local cache
  if [[ -d "${HOME}/goinfre" ]]; then
    cache="${HOME}/goinfre/.cache/matplotlib"
  elif [[ -d "${HOME}/sgoinfre" ]]; then
    cache="${HOME}/sgoinfre/.cache/matplotlib"
  else
    cache="/tmp/matplotlib-$(id -un 2>/dev/null || whoami)"
  fi
  mkdir -p "$cache" 2>/dev/null || true
  export MPLCONFIGDIR="$cache"
  export MPLBACKEND="${MPLBACKEND:-Agg}"
}

# ============================================================================
# DATOS CSV
# ============================================================================
find_csv() {
  # find_csv Train|Test → imprime ruta o vacío
  local kind="$1"
  local name
  if [[ "$kind" == "Train" ]]; then
    name="Train_knight.csv"
  else
    name="Test_knight.csv"
  fi
  local candidates=(
    "$SCRIPT_DIR/data/$name"
    "$SCRIPT_DIR/$name"
    "$SCRIPT_DIR/ex00/$name"
    "$SCRIPT_DIR/ex01/$name"
    "$SCRIPT_DIR/ex02/$name"
    "$SCRIPT_DIR/ex03/$name"
    "$SCRIPT_DIR/ex04/$name"
    "$SCRIPT_DIR/ex05/$name"
  )
  local c
  for c in "${candidates[@]}"; do
    if [[ -f "$c" ]]; then
      echo "$c"
      return 0
    fi
  done
  return 1
}

check_data_files() {
  section "1 · Datos (Train_knight / Test_knight)"

  ctx "Analogía: Train es el cuaderno con la respuesta (Jedi/Sith); Test es el examen sin solución."
  ctx "La hoja adjunta ambos CSV; el subject los usa en EX00–EX05."
  ctx_blank

  local train test
  train="$(find_csv Train || true)"
  test="$(find_csv Test || true)"

  subsection "Train_knight.csv"
  if [[ -n "$train" ]]; then
    ok "Encontrado: $train"
    show_cmd "head -n 2 \"$train\""
    note "Debe incluir columna knight (target)."
  else
    fail "No se encontró Train_knight.csv (data/ o ex0N/)"
  fi

  subsection "Test_knight.csv"
  if [[ -n "$test" ]]; then
    ok "Encontrado: $test"
    show_cmd "head -n 2 \"$test\""
    note "Test no lleva target knight (solo skills)."
  else
    fail "No se encontró Test_knight.csv"
  fi

  pause
}

# ============================================================================
# REVISIÓN DINÁMICA DE CÓDIGO (solo líneas no comentario)
# ============================================================================
dynamic_check() {
  local file="$1"
  local what="$2"
  shift 2
  local patterns=("$@")
  local path="$SCRIPT_DIR/$file"

  if [[ ! -f "$path" ]]; then
    fail "Falta $file"
    return 1
  fi
  ok "Archivo: $file"
  note "Qué buscamos: $what"

  local pat line_no line code_hits=0
  for pat in "${patterns[@]}"; do
    while IFS= read -r hit; do
      line_no="${hit%%:*}"
      line="${hit#*:}"
      # Ignorar líneas que son solo comentario
      if [[ "$line" =~ ^[[:space:]]*# ]]; then
        continue
      fi
      # Ignorar docstrings obvios de una línea
      if [[ "$line" =~ ^[[:space:]]*\"\"\" ]] || [[ "$line" =~ ^[[:space:]]*\'\'\' ]]; then
        continue
      fi
      echo -e "      ${DIM}línea ${line_no}:${RESET} ${line:0:100}"
      code_hits=$((code_hits + 1))
    done < <(grep -nE "$pat" "$path" 2>/dev/null | head -5)
  done

  if [[ "$code_hits" -gt 0 ]]; then
    ok "El código contiene lógica alineada con el criterio"
  else
    warn "No se localizaron patrones claros (revisad el código juntos a mano)"
  fi
}

# ============================================================================
# EJECUCIÓN PYTHON
# ============================================================================
offer_run() {
  local prompt="$1"
  local choice
  echo
  echo -e "  ${BOLD}${prompt}${RESET}"
  echo "  a) Automático: evaluation.sh intenta lanzarlo ahora"
  echo "  m) Manual: se muestran los comandos; el evaluado (o tú) los ejecuta"
  echo "  s) Saltar ejecución"
  read -r -p "  → " choice || true
  choice="${choice:-s}"
  case "$choice" in
    a|A) echo "auto" ;;
    m|M) echo "manual" ;;
    *)   echo "skip" ;;
  esac
}

run_python_exercise() {
  local key="$1"
  local rel="$2"          # ej. ex00/Histogram.py
  local outputs_csv="${3:-}"  # pngs o csvs separados por coma
  local extra_args="${4:-}"   # args extra (split)

  local dir base
  dir="$(dirname "$rel")"
  base="$(basename "$rel")"

  if [[ ! -f "$SCRIPT_DIR/$rel" ]]; then
    # buscar variantes de mayúsculas
    local alt
    alt="$(find "$SCRIPT_DIR/$dir" -maxdepth 1 -type f \( -iname "$base" -o -iname "${base%.*}.*" \) 2>/dev/null | head -1)"
    if [[ -n "$alt" ]]; then
      rel="${alt#"$SCRIPT_DIR"/}"
      dir="$(dirname "$rel")"
      base="$(basename "$rel")"
      note "Usando: $rel"
    else
      fail "No existe $rel"
      return 1
    fi
  fi

  local mode
  mode="$(offer_run "¿Cómo ejecutamos $key ($base)?")"

  case "$mode" in
    auto)
      clear 2>/dev/null || true
      header
      section "Ejecución automática · $key"
      matplotlib_env
      note "MPLCONFIGDIR=${MPLCONFIGDIR:-} (evita llenar ~/.cache en 42)"
      show_cmd "cd $SCRIPT_DIR/$dir && MPLBACKEND=Agg python3 $base $extra_args"
      if (cd "$SCRIPT_DIR/$dir" && matplotlib_env && MPLBACKEND=Agg python3 "$base" $extra_args); then
        ok "Ejecución de $base terminó con código 0"
      else
        fail "Ejecución de $base falló (código ≠ 0)"
      fi
      explain_exercise_artifacts "$outputs_csv" "$dir"
      ;;
    manual)
      subsection "Instrucciones manuales"
      show_cmd "cd $SCRIPT_DIR/$dir"
      if [[ -n "$extra_args" ]]; then
        show_cmd "python3 $base $extra_args"
      else
        show_cmd "python3 $base"
      fi
      note "Si quieres solo PNG (sin ventana) y evitar errores de caché:"
      show_cmd "export MPLCONFIGDIR=\$HOME/goinfre/.cache/matplotlib; mkdir -p \"\$MPLCONFIGDIR\""
      show_cmd "MPLBACKEND=Agg python3 $base $extra_args"
      explain_exercise_artifacts "$outputs_csv" "$dir"
      echo
      note "Cuando hayáis ejecutado y visto la salida, Enter…"
      read -r -p "  " _
      if ask_yes_no "¿La ejecución manual de $key fue correcta?"; then
        ok "$key marcado como ejecutado OK"
      else
        fail "$key: ejecución manual no confirmada"
      fi
      ;;
    *)
      warn "Ejecución de $key omitida"
      ;;
  esac
}

explain_artifact() {
  local png="$1"
  local base
  base="$(basename "$png")"
  echo
  echo -e "  ${BOLD}${CYAN}📐 Contenido de este artefacto → ${base}${RESET}"
  case "$base" in
    histogram_test.png|histogram_train.png)
      ctx "Histograma(s) de skills: eje X = valor de la skill, eje Y = cuántos caballeros."
      ctx "Train: colores por knight (Jedi/Sith) para ver solapes."
      ctx "Test: sin target; solo forma de cada distribución."
      ;;
    *correlation*|*Correlation*)
      ctx "Lista de factores feature ↔ target; knight debe ser 1.0 consigo mismo."
      ctx "Valores cerca de ±1 = relación fuerte; cerca de 0 = poca relación lineal."
      ;;
    *point*|*scatter*)
      ctx "Scatter de dos skills: cada punto = un caballero."
      ctx "Train: colores por bando. Un par separa nubes; otro las mezcla."
      ctx "Test: mismo plano, un solo color (sin etiqueta)."
      ;;
    *standard*)
      ctx "Tras z-score: ejes en unidades de desviación (≈ media 0)."
      ctx "La forma relativa de los puntos se conserva; cambia la escala."
      ;;
    *normal*)
      ctx "Tras min-max: valores típicamente en [0, 1]."
      ctx "Otra escala distinta a la estandarización; proporciones relativas distintas."
      ;;
    Training_knight.csv|Validation_knight.csv)
      ctx "Partición aleatoria de Train: una parte para ajustar, otra para validar."
      ;;
    *)
      ctx "Abrid el fichero y contrastad con el subject / la hoja."
      ;;
  esac
  if [[ -f "$png" ]]; then
    show_cmd "xdg-open \"$png\"  # o cat / less si es texto"
    note "Ruta: $png"
  fi
}

explain_exercise_artifacts() {
  local outputs_csv="$1"
  local dir="$2"
  [[ -z "$outputs_csv" ]] && return 0
  echo
  echo -e "  ${BOLD}${CYAN}📚 Explicación de los artefactos${RESET}"
  ctx "Ideal: leerlo en voz alta con el evaluado mientras se mira la imagen/salida."
  local out
  IFS=',' read -r -a outs <<< "$outputs_csv"
  for out in "${outs[@]}"; do
    if [[ -f "$SCRIPT_DIR/$out" ]]; then
      explain_artifact "$SCRIPT_DIR/$out"
    elif [[ -f "$SCRIPT_DIR/$dir/$out" ]]; then
      explain_artifact "$SCRIPT_DIR/$dir/$out"
    else
      note "Aún no existe: $out (puede generarse al ejecutar)"
      explain_artifact "$out"
    fi
  done
}

confirm_visual() {
  local key="$1"
  local outputs_csv="$2"
  local question="$3"
  echo
  subsection "Demostración visual / salida (obligatoria en la hoja)"
  ctx "Un PNG en disco o un print no basta: hay que ABRIRLO o mostrarlo y comentar."
  IFS=',' read -r -a outs <<< "$outputs_csv"
  local out
  for out in "${outs[@]}"; do
    if [[ -f "$SCRIPT_DIR/$out" ]]; then
      ok "Existe: $out"
      show_cmd "xdg-open \"$SCRIPT_DIR/$out\""
    else
      # buscar por nombre en el árbol
      local found
      found="$(find "$SCRIPT_DIR" -name "$(basename "$out")" 2>/dev/null | head -1)"
      if [[ -n "$found" ]]; then
        ok "Existe: $found"
        show_cmd "xdg-open \"$found\""
      else
        warn "Aún no existe: $out"
      fi
    fi
  done
  note "La explicación detallada ya se mostró al ejecutar (si se eligió auto/manual)."
  ask_scale "$key" "$question"
}

# ============================================================================
# ENTREGABLES
# ============================================================================
check_structure() {
  section "0 · Estructura y entregables del subject"

  ctx "Solo se evalúa lo que está en el Git del evaluado."
  ctx "evaluation.sh y mates.md son apoyo: NO sustituyen Histogram.* … split.*"
  ctx_blank

  local items=(
    "ex00:Histogram.py:Histogram.*"
    "ex01:Correlation.py:Correlation.*"
    "ex02:points.py:points.*"
    "ex03:standardization.py:standardization.*"
    "ex04:Normalization.py:Normalization.*"
    "ex05:split.py:split.*"
  )
  local item dir file label found
  for item in "${items[@]}"; do
    IFS=':' read -r dir file label <<< "$item"
    found="$(find "$SCRIPT_DIR/$dir" -maxdepth 1 -type f -iname "${file%.*}.*" 2>/dev/null | head -1)"
    if [[ -n "$found" ]]; then
      ok "$label → ${found#"$SCRIPT_DIR"/}"
    else
      fail "Falta $label en $dir/"
    fi
  done
  pause
}

# ============================================================================
# EJERCICIOS (criterios de evaluation_en_3.pdf)
# ============================================================================
check_ex00() {
  section "2 · EX00 – Histogram"

  ctx "Analogía: un histograma es un edificio por rangos de altura de cada skill."
  ctx "Train pinta Jedi/Sith; Test solo muestra la forma de cada skill."
  ctx_blank
  requirement "Read the code, Run the code and histogram as in the subject must appear"
  ctx_blank

  subsection "Código"
  dynamic_check "ex00/Histogram.py" \
    "Lectura CSV + histograma matplotlib" \
    "read_csv|pd\.read" \
    "hist\(|histplot|plt\.hist" \
    "Train_knight|Test_knight" \
    "savefig|show\("

  subsection "Ejecución"
  run_python_exercise "EX00" "ex00/Histogram.py" \
    "ex00/histogram_train.png,ex00/histogram_test.png"

  confirm_visual "EX00" "ex00/histogram_train.png,ex00/histogram_test.png" \
    "EX00 – ¿Aparece el histograma como en el subject?"
  pause
}

check_ex01() {
  section "3 · EX01 – Correlation"

  ctx "Analogía: el factor dice si dos listas ‘suben y bajan juntas’ (−1…+1)."
  ctx "knight consigo mismo = 1. El estudiante debe explicar qué es un factor de correlación."
  ctx_blank
  requirement "Read the code, Run the code and a Correlation Factors list must appear"
  requirement "Knight must be equal to 1; student must explain a correlation factor"
  ctx_blank

  subsection "Código"
  dynamic_check "ex01/Correlation.py" \
    "Pearson / corr con target knight + orden" \
    "corr|pearson|correlation" \
    "knight" \
    "read_csv|pd\.read" \
    "sort|sorted"

  subsection "Ejecución"
  run_python_exercise "EX01" "ex01/Correlation.py" "ex01/correlation_report.md"

  subsection "Defensa oral (hoja)"
  ctx "Pedid: «¿Qué significa un factor de correlación?»"
  ctx "Pedid: «¿Por qué knight = 1.0 en la lista?»"
  note "Respuesta guía: mide relación lineal; |r|≈1 fuerte, ≈0 débil; una variable consigo misma es 1."

  ask_scale "EX01" \
    "EX01 – ¿Lista de factores visible y knight=1, con explicación del factor?"
  pause
}

check_ex02() {
  section "4 · EX02 – points (it's raining cats no points!)"

  ctx "Analogía: cada caballero es un punto en un mapa de dos skills."
  ctx "Subject: 4 gráficos (Train/Test × par que separa / par que mezcla)."
  ctx "La hoja resume «2 graphs as in the subject»; el PDF del subject muestra 4 paneles."
  ctx_blank
  requirement "Read the code, Run the code and graphs appear as in the subject"
  ctx_blank

  subsection "Código"
  dynamic_check "ex02/points.py" \
    "Scatter Train+Test, pares separar/mezclar" \
    "scatter|plt\.scatter" \
    "Train_knight|Test_knight" \
    "savefig|show\("

  subsection "Ejecución"
  # nombres de PNG pueden variar; el script busca lo que exista
  run_python_exercise "EX02" "ex02/points.py" ""

  subsection "Qué debe verse"
  ctx "• Un par de ejes que SEPARA visualmente Jedi/Sith en Train."
  ctx "• Un par que los MEZCLA en Train."
  ctx "• Los mismos ejes en Test (sin color de bando)."

  ask_scale "EX02" \
    "EX02 – ¿Se han mostrado los gráficos de puntos como en el subject?"
  pause
}

check_ex03() {
  section "5 · EX03 – Standardization"

  ctx "Analogía: pasar de «cm y kg» a una regla común (media 0, std 1)."
  ctx "La forma de las nubes se parece; cambian los números de los ejes."
  ctx_blank
  requirement "Read the code, Run the code and a graph of previous exercise appears"
  requirement "The scale must be changed on the graph, but the proportions must have been agreed"
  ctx_blank

  subsection "Código"
  dynamic_check "ex03/standardization.py" \
    "z-score + print + scatter estandarizado" \
    "mean|std|StandardScaler|z.?score" \
    "print\(" \
    "scatter|savefig|show\("

  subsection "Ejecución"
  run_python_exercise "EX03" "ex03/standardization.py" ""

  subsection "Defensa"
  ctx "Comparad ejes con EX02: ¿siguen en unidades originales o en z-scores?"
  note "Fórmula: z = (x − μ) / σ"

  ask_scale "EX03" \
    "EX03 – ¿Datos estandarizados impresos y gráfico del ejercicio anterior con escala cambiada?"
  pause
}

check_ex04() {
  section "6 · EX04 – Normalization"

  ctx "Analogía: comprimir cada skill al tramo 0…1 (o similar), como volumen 0–100 %."
  ctx "No es lo mismo que estandarizar: aquí mandan min y max, no media y std."
  ctx_blank
  requirement "Read the code, Run the code and a graph of previous exercise appears"
  requirement "The scale must be changed on the graph, but the proportions must have been agreed"
  ctx_blank

  subsection "Código"
  dynamic_check "ex04/Normalization.py" \
    "min-max (o equivalente) + print + gráfico" \
    "min|max|normalize|MinMax" \
    "print\(" \
    "scatter|savefig|show\("

  subsection "Ejecución"
  run_python_exercise "EX04" "ex04/Normalization.py" ""

  subsection "Defensa"
  note "Fórmula típica: x' = (x − xmin) / (xmax − xmin)  →  valores en [0, 1]"

  ask_scale "EX04" \
    "EX04 – ¿Datos normalizados impresos y gráfico con escala cambiada?"
  pause
}

check_ex03_04_diff() {
  section "7 · EX03–04 – Standardization vs Normalization"

  ctx "La hoja exige preguntar la diferencia. Podéis contrastar con mates.md."
  ctx_blank
  requirement "Ask the student the difference between Normalization and Standardization"
  ctx_blank

  echo -e "  ${BOLD}Guion sugerido para el evaluado:${RESET}"
  ctx "• Estandarización (z-score): resta la media y divide por la std → centro 0, dispersión 1."
  ctx "• Normalización (min-max): reescala al intervalo [0,1] (o similar) usando min y max."
  ctx "• Misma nube de puntos, distinta «regla» en los ejes; útil para algoritmos distintos."
  ctx_blank

  if ask_yes_no "¿El evaluado ha explicado la diferencia de forma correcta?"; then
    RESULT["EX03_04"]="yes"
    ok "Diferencia standardization vs normalization OK"
  else
    RESULT["EX03_04"]="no"
    fail "No se demostró la diferencia con claridad"
  fi
  # también como ítem de hoja
  ask_scale "EX03_04_scale" \
    "EX03-04 – ¿Diferencia Normalization vs Standardization explicada?"
  pause
}

check_ex05() {
  section "8 · EX05 – Split"

  ctx "Analogía: no estudias con el mismo examen con el que te evalúan."
  ctx "Training = practicar; Validation = comprobar sin «hacer trampa»."
  ctx_blank
  requirement "Ask how many % in each file and why"
  requirement "Run → Training_knight.csv y Validation_knight.csv aparecen"
  ctx_blank

  subsection "Código"
  dynamic_check "ex05/split.py" \
    "Partición aleatoria Train → Training + Validation" \
    "split|sample|train_test|random" \
    "Training_knight|Validation_knight" \
    "to_csv|read_csv"

  subsection "Ejecución"
  local train
  train="$(find_csv Train || true)"
  if [[ -z "$train" ]]; then
    warn "Sin Train_knight.csv no se puede demostrar el split automáticamente"
  else
    # copiar train a ex05 si hace falta
    if [[ ! -f "$SCRIPT_DIR/ex05/Train_knight.csv" ]]; then
      note "Copiando Train a ex05/ para el comando del subject"
      show_cmd "cp \"$train\" \"$SCRIPT_DIR/ex05/Train_knight.csv\""
      cp "$train" "$SCRIPT_DIR/ex05/Train_knight.csv" 2>/dev/null || true
    fi
    run_python_exercise "EX05" "ex05/split.py" \
      "ex05/Training_knight.csv,ex05/Validation_knight.csv" \
      "Train_knight.csv"
  fi

  subsection "% y por qué (hoja)"
  ctx "Ejemplo habitual: ~80 % Training / ~20 % Validation (u otro ratio justificado)."
  ctx "Por qué: validar generalización; si validas con los mismos datos del ajuste, engañas."
  if ask_yes_no "¿El evaluado ha justificado los % Training / Validation?"; then
    ok "Justificación de porcentajes OK"
  else
    fail "Falta justificación de porcentajes"
  fi

  subsection "Comprobar ficheros"
  show_cmd "ls -la $SCRIPT_DIR/ex05/"
  if [[ -f "$SCRIPT_DIR/ex05/Training_knight.csv" && -f "$SCRIPT_DIR/ex05/Validation_knight.csv" ]]; then
    ok "Training_knight.csv y Validation_knight.csv presentes"
  else
    warn "No se ven ambos CSV de salida en ex05/ (pueden haberse generado en otro cwd)"
  fi

  ask_scale "EX05" \
    "EX05 – ¿Split ejecutado, ficheros generados y % explicados?"
  pause
}

# ============================================================================
# RESUMEN
# ============================================================================
summary() {
  section "9 · Resumen (orientativo)"

  ctx "Los Yes/No de la hoja los marca el evaluador oficial."
  ctx "Este resumen solo ayuda a no olvidar ningún bloque."
  ctx_blank

  local k
  for k in EX00 EX01 EX02 EX03 EX04 EX03_04_scale EX05; do
    local v="${RESULT[$k]:-—}"
    case "$v" in
      yes) echo -e "  ${GREEN}✓${RESET} $k → Yes" ;;
      no)  echo -e "  ${RED}✗${RESET} $k → No" ;;
      skip) echo -e "  ${YELLOW}○${RESET} $k → omitido" ;;
      *)   echo -e "  ${DIM}·${RESET} $k → $v" ;;
    esac
  done

  echo
  echo -e "  ${DIM}OK=${PASS_COUNT}  Errores=${FAIL_COUNT}  Avisos=${WARN_COUNT}${RESET}"
  echo
  note "evaluation.sh no forma parte de la nota (solo guía de defensa)."
  note "Material de apoyo: mates.md (fórmulas) · python.md por ejercicio."
  echo
}

# ============================================================================
# MAIN
# ============================================================================
main() {
  header
  note "Basado en en.subject.pdf y evaluation_en_3.pdf"
  note "No sustituye la defensa oficial ni la decisión de la hoja."
  echo
  if ! ask_yes_no "¿Empezar el recorrido de defensa Module 3?"; then
    echo "Hasta luego."
    exit 0
  fi

  header
  check_structure
  check_data_files
  check_ex00
  check_ex01
  check_ex02
  check_ex03
  check_ex04
  check_ex03_04_diff
  check_ex05
  summary

  echo -e "  ${GREEN}Fin de la guía de evaluación Module 3.${RESET}"
  echo
}

main "$@"
