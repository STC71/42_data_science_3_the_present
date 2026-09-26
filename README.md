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
8. [Checklist subject](#checklist)
9. [Navegación](#navegacion)

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
