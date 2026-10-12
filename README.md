# ⚔️ Piscine Data Science – Module 3 – The present

<p align="center">
  <img src="./imgs/banner_00.jpg" alt="Piscine Data Science – Module 3 – Exploración · correlación · escalas · train/validation" width="100%">
</p>

<p align="center">
  <strong>Exploración · correlación · escalas · train/validation</strong><br>
</p>

---

<a id="indice"></a>
## 📑 Índice

1. [¿De qué trata?](#proyecto)
2. [Los datos (caballeros)](#datos)
3. [Estructura del repositorio](#estructura)
4. [Orden de trabajo (subject)](#orden)
5. [Qué entrega cada ejercicio](#entregas)
6. [Asistente global (`./start.sh`)](#asistente-global)
7. [Prerrequisitos técnicos](#prereq)
8. [Evaluación guiada (`evaluation.sh`)](#evaluacion)
9. [Matemáticas del módulo (`mates.md`)](#mates)
10. [Python del módulo (`python.md`)](#python-hub)
11. [pandas del módulo (`pandas.md`)](#pandas)
12. [NumPy del módulo (`numpy.md`)](#numpy)
13. [Matplotlib del módulo (`matplotlib.md`)](#matplotlib)
14. [Checklist subject](#checklist)
15. [Navegación](#navegacion)

---

<a id="proyecto"></a>
## 🎯 ¿De qué trata?

El subject **The present** trabaja un dataset tabular de “skills” de caballeros y un target **`knight`** (Jedi / Sith):

| Idea | Ejercicios |
|------|------------|
| Ver distribuciones | EX00 Histogram |
| Qué features se relacionan con el target | EX01 Correlation |
| Separar / mezclar grupos en el plano | EX02 points |
| Estandarizar (z-score) | EX03 standardization |
| Normalizar (p. ej. [0, 1]) | EX04 Normalization |
| Partir Train en Training + Validation | EX05 Split |

**No** depende de PostgreSQL ni del warehouse: todo parte de CSV.

[↑ Volver al índice](#indice)

---

<a id="datos"></a>
## 📦 Los datos (caballeros)

| Fichero | Filas × cols | Contenido |
|---------|-------------:|-----------|
| [`data/Train_knight.csv`](data/Train_knight.csv) | **398 × 31** | 30 skills + **`knight`** (Jedi / Sith) |
| [`data/Test_knight.csv`](data/Test_knight.csv) | **171 × 30** | 30 skills (**sin** target) |

En Train, el balance típico es del orden de **Sith ~246 / Jedi ~152**.

Conviene tener copia de los CSV en `data/` y, si ejecutas un ejercicio aislado, también en `ex0N/`.

[↑ Volver al índice](#indice)

---

<a id="estructura"></a>
## 📁 Estructura del repositorio

```text
data_science_3_the_present/
├── README.md
├── mates.md              ← matemáticas del módulo (apoyo didáctico)
├── python.md             ← hub Python del módulo
├── pandas.md             ← guía pandas desde cero (pieza central)
├── numpy.md              ← guía NumPy desde cero
├── matplotlib.md         ← guía matplotlib desde cero
├── evaluation.sh         ← guía interactiva de defensa (NO es nota)
├── start.sh              ← asistente GLOBAL
├── data/
│   ├── Train_knight.csv
│   └── Test_knight.csv
├── ex00/  Histogram.*
├── ex01/  Correlation.*
├── ex02/  points.*
├── ex03/  standardization.*
├── ex04/  Normalization.*
└── ex05/  split.*
```

Cada ejercicio, cuando esté listo, incluye `README.md`, guía (`python.md`) y `start.sh` local.

[↑ Volver al índice](#indice)

---

<a id="orden"></a>
## 🧭 Orden de trabajo (subject)

```text
EX00 Histogram  →  EX01 Correlation  →  EX02 points
                                              ↓
                         EX03 standardization · EX04 Normalization
                                              ↓
                                        EX05 Split (Training / Validation)
```

EX03 y EX04 reutilizan la idea de gráficos de EX02 sobre datos **escalados**.

[↑ Volver al índice](#indice)

---

<a id="entregas"></a>
## 📦 Qué entrega cada ejercicio

| Carpeta | Subject | Entrega | Estado |
|---------|---------|---------|--------|
| [`ex00/`](ex00/README.md) | Histogram | **`Histogram.*`** | ✅ |
| `ex01/` | Correlation | **`Correlation.*`** | ⏳ |
| `ex02/` | points | **`points.*`** | ⏳ |
| `ex03/` | standardization | **`standardization.*`** | ⏳ |
| `ex04/` | Normalization | **`Normalization.*`** | ⏳ |
| `ex05/` | Split | **`split.*`** | ⏳ |

[↑ Volver al índice](#indice)

---

<a id="asistente-global"></a>
## 🖥️ Asistente global (`./start.sh`)

```bash
cd data_science_3_the_present
./start.sh
```

- Estado de CSV y entregas  
- Ejecutar los ejercicios disponibles (ventana o solo PNG)  
- Recordatorio de nombres del subject  

No sustituye `Histogram.*` / … / `split.*`.

[↑ Volver al índice](#indice)

---

<a id="prereq"></a>
## ⚙️ Prerrequisitos técnicos

| Pieza | Uso |
|-------|-----|
| Python 3 | Scripts |
| `pandas`, `matplotlib`, `numpy` | Tablas y gráficos |
| `scikit-learn` (opcional en EX03–04) | StandardScaler / MinMaxScaler |

[↑ Volver al índice](#indice)

---


<a id="evaluacion"></a>
## 🧪 Evaluación guiada (`evaluation.sh`)

Guía interactiva alineada con **`en.subject.pdf`** y **`evaluation_en_3.pdf`**
(`/PROJECTS/DATA-SCIENCE-3`). **No** sustituye la defensa oficial ni forma parte de la nota.

```bash
cd data_science_3_the_present
chmod +x evaluation.sh
./evaluation.sh
```

Recorre, con confirmación y opción auto/manual/saltar:

| Bloque hoja | Qué comprueba la guía |
|-------------|------------------------|
| EX00 Histogram | Código, ejecución, histogramas Train/Test |
| EX01 Correlation | Lista de factores, `knight = 1`, explicación oral de r |
| EX02 points | Gráficos de dispersión (subject: 4 paneles) |
| EX03 Standardization | Print + scatter con escala z-score |
| EX04 Normalization | Print + scatter con escala min-max |
| EX03–04 | Diferencia standardization vs normalization |
| EX05 Split | % Training/Validation, ficheros generados |

Los CSV se buscan en `data/` y en `ex0N/`. Matplotlib usa caché en goinfre cuando hace falta (cuota en 42).

[↑ Volver al índice](#indice)

---

<a id="mates"></a>
## 📐 Matemáticas del módulo (`mates.md`)

Guía didáctica de las **cuentas** del Module 3 (histogramas, Pearson, z-score, min-max, split),
con fórmulas, ejemplos y analogías, sin asumir estadística previa.

| Tema | Ejercicios |
|------|------------|
| Distribuciones / bins | EX00 |
| Correlación de Pearson | EX01 |
| Nubes de puntos | EX02 |
| Estandarización z = (x−μ)/σ | EX03 |
| Normalización min-max | EX04 |
| Diferencia EX03 vs EX04 | Hoja de evaluación |
| Split 80/20 (u otro ratio justificado) | EX05 |

📖 **[mates.md](./mates.md)** — material de apoyo. **No** sustituye al subject ni a `Histogram.*` … `split.*`.

[↑ Volver al índice](#indice)

---


---

<a id="python-hub"></a>
## 🐍 Python del módulo (`python.md`)

Hub didáctico de **Python** a nivel Module 3: flujo típico (CSV → cuentas → gráfico),
librerías (`pandas`, `numpy`, `matplotlib`), rutas de `Train_knight.csv` / `Test_knight.csv`,
puente hacia Module 4, y enlaces a cada `ex0N/python.md`.

**No** hay PostgreSQL ni scikit-learn en este módulo.

📖 **[python.md](./python.md)** — material de apoyo. **No** sustituye a `en.subject.pdf` ni a los entregables.

[↑ Volver al índice](#indice)

---

<a id="pandas"></a>
## 🐼 pandas del módulo (`pandas.md`)

Guía **desde cero** de pandas orientada a este módulo: DataFrame, `read_csv`, Train vs Test
(con/sin `knight`), separar `X`/`y`, filtrar Jedi/Sith, codificar el target a 0/1, `.corr()`,
z-score y min-max con tablas, split 80/20 y errores típicos en 42.

Es la pieza **central**: aquí no hay warehouse; todo parte de CSV.

📖 **[pandas.md](./pandas.md)** — material de apoyo. **No** sustituye a `en.subject.pdf` ni a los entregables.

[↑ Volver al índice](#indice)

---

<a id="numpy"></a>
## 🔢 NumPy del módulo (`numpy.md`)

Guía **desde cero** de NumPy: arrays frente a listas, `shape`, `axis`, estadísticas,
paso desde pandas, z-score/min-max en bloque y frases útiles para defensa.

📖 **[numpy.md](./numpy.md)** — material de apoyo. **No** sustituye a `en.subject.pdf` ni a los entregables.

[↑ Volver al índice](#indice)

---

<a id="matplotlib"></a>
## 📈 Matplotlib del módulo (`matplotlib.md`)

Guía **desde cero** de matplotlib para Module 3: backend Agg vs ventana, histogramas (EX00),
dispersiones (EX02–EX04), `subplots`, títulos/pies en español, PNG en cluster y cómo
**comentar** un gráfico en evaluación.

📖 **[matplotlib.md](./matplotlib.md)** — material de apoyo. **No** sustituye a `en.subject.pdf` ni a los entregables.

[↑ Volver al índice](#indice)

<a id="checklist"></a>
## ✅ Checklist subject

| Ítem | ☐ |
|------|---|
| EX00 `Histogram.*` | ☐ |
| EX01 `Correlation.*` | ☐ |
| EX02 `points.*` | ☐ |
| EX03 `standardization.*` | ☐ |
| EX04 `Normalization.*` | ☐ |
| EX05 `split.*` | ☐ |
| CSV Train + Test accesibles | ☐ |

[↑ Volver al índice](#indice)

---

<a id="navegacion"></a>
## 🔗 Navegación

- [🧪 evaluation.sh – guía de defensa](./evaluation.sh)
- [📐 mates.md – matemáticas del módulo](./mates.md)
- [🐍 python.md – hub Python](./python.md)
- [🐼 pandas.md – pandas desde cero](./pandas.md)
- [🔢 numpy.md – NumPy desde cero](./numpy.md)
- [📈 matplotlib.md – gráficos desde cero](./matplotlib.md)
- [← Module 2 Data Viz](../data_science_2_data_viz/README.md)
- [Monorepo](../README.md)

---

<a id="csv-auto"></a>
## 🔍 Localización automática de CSV

El asistente global (`./start.sh`) **busca** `Train_knight.csv` y `Test_knight.csv` en:

1. `data/` y cada `ex0N/` del módulo  
2. Directorio de trabajo actual  
3. Rutas típicas bajo `sgoinfre` / monorepo  
4. `find` limitado (maxdepth) si aún no aparecen  

**Opción 2 del menú:** copia los ficheros encontrados a `data/` y a cada ejercicio.  
Los scripts pueden usar también las variables `KNIGHT_TRAIN_CSV` y `KNIGHT_TEST_CSV`.

[↑ Volver al índice](#indice)

---

*sternero – 42 Málaga – Module 3 – The present – Octubre 2026*
