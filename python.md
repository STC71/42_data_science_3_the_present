# 🐍 Python en el Module 3 – The present

<p align="center">
  <img src="./imgs/banner_00.jpg" alt="Piscine Data Science – Module 3 – Guía Python" width="100%">
</p>

[← README](./README.md) · [🐼 pandas.md](./pandas.md) · [🔢 numpy.md](./numpy.md) · [📈 matplotlib.md](./matplotlib.md) · [📐 mates.md](./mates.md)

---

Guía **hub** de Python para el Module 3.  
No sustituye al subject ni a los scripts de cada ejercicio.

Para el **detalle de un ejercicio concreto** usa siempre:

| Ejercicio | Guía local | Entrega |
|-----------|------------|---------|
| EX00 | [`ex00/python.md`](./ex00/python.md) | `Histogram.*` |
| EX01 | [`ex01/python.md`](./ex01/python.md) | `Correlation.*` |
| EX02 | [`ex02/python.md`](./ex02/python.md) | `points.*` |
| EX03 | [`ex03/python.md`](./ex03/python.md) | `standardization.*` |
| EX04 | [`ex04/python.md`](./ex04/python.md) | `Normalization.*` |
| EX05 | [`ex05/python.md`](./ex05/python.md) | `split.*` |

Este documento orienta el **mapa del módulo** y enlaza las piezas transversales  
(pandas, NumPy, matplotlib, mates).  
**No** hay PostgreSQL ni scikit-learn en este módulo: todo parte de CSV.

---

## 📑 Índice

1. [De qué va el Module 3 en una frase](#frase)
2. [Flujo típico de un script](#flujo)
3. [Librerías que verás](#libs)
4. [pandas (pieza central)](#pandas)
5. [NumPy](#numpy)
6. [Matplotlib](#matplotlib)
7. [Argumentos, rutas y CSV](#rutas)
8. [Cómo ejecutar en 42](#ejecutar)
9. [Puente hacia Module 4](#puente)
10. [Lectura para procesos selectivos](#selectivos)
11. [Guías relacionadas](#relacionado)

---

<a id="frase"></a>
## 1. De qué va el Module 3 en una frase

Abres fichas de caballeros (CSV), **exploras** skills, mides **correlación** con Jedi/Sith,  
**reescalas** números y **partes** Train en training/validation — preparando el terreno al predicción del Module 4.

[↑ Índice](#indice)

---

<a id="flujo"></a>
## 2. Flujo típico de un script

```text
1. Localizar Train_knight.csv / Test_knight.csv
2. pd.read_csv(...)
3. Separar o codificar knight si hace falta
4. Calcular (hist, corr, z-score, min-max, split…)
5. Imprimir números y/o guardar PNG con matplotlib
```

**Analogía:** abrir el archivador (CSV), subrayar columnas (pandas), hacer cuentas (NumPy), colgar el cartel (matplotlib).

[↑ Índice](#indice)

---

<a id="libs"></a>
## 3. Librerías que verás

| Librería | Rol en Module 3 |
|----------|-----------------|
| **pandas** | Leer CSV, filtrar, corr, split |
| **numpy** | Medias, std, matrices, escalas en bloque |
| **matplotlib** | Histogramas y dispersiones |
| `pathlib` | Rutas portables |
| *(no)* `psycopg2` | No hay warehouse en este módulo |
| *(no)* `sklearn` | Clustering/modelos → M2 (k-means) / M4 |

```bash
python3 -m pip install --user pandas numpy matplotlib
```

[↑ Índice](#indice)

---

<a id="pandas"></a>
## 4. pandas (pieza central)

Guía completa desde cero: **[pandas.md](./pandas.md)**

Ideas mínimas:

```python
import pandas as pd
train = pd.read_csv("../data/Train_knight.csv")
X = train.drop(columns=["knight"])
y = train["knight"]
```

[↑ Índice](#indice)

---

<a id="numpy"></a>
## 5. NumPy

Guía completa: **[numpy.md](./numpy.md)**

```python
import numpy as np
X_np = X.to_numpy(dtype=float)
Z = (X_np - X_np.mean(axis=0)) / X_np.std(axis=0)
```

[↑ Índice](#indice)

---

<a id="matplotlib"></a>
## 6. Matplotlib

Guía completa: **[matplotlib.md](./matplotlib.md)**

```python
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
# ... hist / scatter ...
plt.savefig("figura.png", dpi=140, bbox_inches="tight")
```

[↑ Índice](#indice)

---

<a id="rutas"></a>
## 7. Argumentos, rutas y CSV

Patrones del repo:

- Buscar en `data/`, luego `ex0N/`, luego variables `KNIGHT_TRAIN_CSV` / `KNIGHT_TEST_CSV`.
- El `start.sh` de la raíz puede **localizar y copiar** los CSV.

```python
from pathlib import Path
root = Path(__file__).resolve().parent
candidates = [
    root / "Train_knight.csv",
    root.parent / "data" / "Train_knight.csv",
]
```

[↑ Índice](#indice)

---

<a id="ejecutar"></a>
## 8. Cómo ejecutar en 42

```bash
cd data_science_3_the_present/ex00
python3 Histogram.py
# o
chmod +x Histogram.py && ./Histogram.py
```

Si matplotlib se queja del cache:

```bash
export MPLCONFIGDIR="$HOME/goinfre/.cache/matplotlib"
mkdir -p "$MPLCONFIGDIR"
```

[↑ Índice](#indice)

---

<a id="puente"></a>
## 9. Puente hacia Module 4

| Module 3 | Module 4 |
|----------|----------|
| Explorar y escalar skills | Predecir Jedi/Sith |
| Correlación con target | Métricas (F1, matriz) |
| Split train/validation | Modelos (árbol, KNN, voting) |

Lo que aprendes de **no filtrar el solucionario en X** y de **escalar con cuidado** se reutiliza tal cual.

[↑ Índice](#indice)

---

<a id="selectivos"></a>
## 10. Lectura para procesos selectivos

Si alguien revisa el repo como carta de presentación:

1. [README.md](./README.md) — mapa y checklist.  
2. [mates.md](./mates.md) — cuentas del ejercicio que demuestres.  
3. [pandas.md](./pandas.md) / [numpy.md](./numpy.md) / [matplotlib.md](./matplotlib.md) — *por qué* esas piezas.  
4. `ex0N/python.md` — recorrido del **código entregable**.

Hilo: **CSV → tabla pandas → números NumPy → gráfico matplotlib → (M4) modelo**.

[↑ Índice](#indice)

---

<a id="relacionado"></a>
## 11. Guías relacionadas

| Recurso | Contenido |
|---------|-----------|
| [`README.md`](./README.md) | Visión del módulo, start.sh, evaluation |
| [`pandas.md`](./pandas.md) | DataFrame, Train/Test, corr, split |
| [`numpy.md`](./numpy.md) | Arrays, axis, z-score/min-max en bloque |
| [`matplotlib.md`](./matplotlib.md) | Hist, scatter, PNG, defensa visual |
| [`mates.md`](./mates.md) | Fórmulas Pearson, escalas, split |
| [`evaluation.sh`](./evaluation.sh) | Defensa guiada |
| `ex0N/python.md` | Código de **ese** ejercicio |

---

*python.md · Module 3 The present · hub · no sustituye en.subject.pdf ni a los python.md de cada ex*  
*sternero – 42 Málaga – 2026*
