# 🐼 pandas en el Module 3 – The present

<p align="center">
  <img src="./imgs/banner_00.jpg" alt="Piscine Data Science – Module 3 – Guía pandas" width="100%">
</p>

[← README del módulo](./README.md) · [🐍 python.md](./python.md) · [🔢 numpy.md](./numpy.md) · [📈 matplotlib.md](./matplotlib.md) · [📐 mates.md](./mates.md)

---

Guía **didáctica de pandas** para este módulo.  
Pensada para quien **no ha abierto nunca** un CSV con código.

No sustituye al subject ni a los scripts (`Histogram.*`, `Correlation.*`, `points.*`, `standardization.*`, `Normalization.*`, `split.*`).  
No sustituye los `ex0N/python.md` (ahí está el detalle de **cada** entrega).

> **Analogía global:** un **DataFrame** es una hoja de cálculo dentro de Python.  
> Cada **fila** es la ficha de un caballero. Cada **columna** es un skill (o el bando `knight`).  
> pandas sirve para **abrir el CSV, mirar, filtrar, codificar el target y pasar números** a NumPy/matplotlib.

En Module 3, pandas aparece en **casi todos** los ejercicios: no hay PostgreSQL; la fuente de verdad son los CSV.

---

## 📑 Índice

1. [Lee esto primero](#lee)
2. [Instalar e importar](#instalar)
3. [Qué es un DataFrame (y una Series)](#dataframe)
4. [Leer los CSV del módulo](#read)
5. [Mirar sin miedo: head, shape, columns, dtypes](#mirar)
6. [Train vs Test: con y sin `knight`](#traintest)
7. [Seleccionar y quitar columnas](#columnas)
8. [Separar features (`X`) y target (`y`)](#xy)
9. [Filtrar filas (Jedi / Sith)](#filtrar)
10. [Codificar `knight` a 0/1 para correlaciones](#codificar)
11. [Estadísticos rápidos](#stats)
12. [Correlación (EX01)](#corr)
13. [Valores faltantes](#na)
14. [Estandarizar y normalizar con pandas + NumPy](#escalas)
15. [Split Training / Validation (EX05)](#split)
16. [Escribir CSV de salida](#escribir)
17. [Mapa: pandas en cada ejercicio](#mapa)
18. [Errores frecuentes en 42](#errores)
19. [Frases útiles en defensa / entrevistas](#defensa)
20. [Mini ejercicios](#ejercicios)
21. [Glosario](#glosario)
22. [Relacionado](#relacionado)

---

<a id="lee"></a>
## 1. Lee esto primero

| Pregunta | Respuesta corta |
|----------|-----------------|
| ¿Obliga el subject a pandas? | No; es la forma **cómoda** de este repo. |
| ¿Hace falta Excel? | No. `read_csv` abre el fichero solo. |
| ¿Dónde más se usa? | EX00–EX05 (en EX01 incluso sin gráfico). |
| ¿Y NumPy? | pandas y NumPy se complementan; ver [`numpy.md`](./numpy.md). |

[↑ Índice](#indice)

---

<a id="instalar"></a>
## 2. Instalar e importar

```bash
python3 -m pip install --user pandas
```

```python
import pandas as pd
```

Por convención se importa como `pd`.

[↑ Índice](#indice)

---

<a id="dataframe"></a>
## 3. Qué es un DataFrame (y una Series)

```text
   Sensitivity  Strength  ...  knight
0         12.1      18.0  ...    Jedi
1          8.4      22.3  ...    Sith
```

| Pieza | Analogía |
|-------|----------|
| **DataFrame** | Toda la hoja |
| **Series** | Una sola columna |
| **Fila** | Un caballero |
| **Columna** | Un skill o el bando |
| **Índice** | Número de fila (0, 1, 2, …) |

```python
type(df)              # pandas.DataFrame
type(df["Strength"])  # pandas.Series
```

[↑ Índice](#indice)

---

<a id="read"></a>
## 4. Leer los CSV del módulo

```python
from pathlib import Path

train = pd.read_csv(Path("../data/Train_knight.csv"))
test  = pd.read_csv(Path("../data/Test_knight.csv"))
```

| Detalle | Nota |
|---------|------|
| Primera fila del fichero | Cabecera (nombres de columnas) |
| Separador | `,` por defecto |
| Ruta | Mejor `data/` del módulo; los `start.sh` pueden sincronizar a `ex0N/` |

**Analogía:** “Abrir el Excel”, pero el resultado vive en la variable `train`.

[↑ Índice](#indice)

---

<a id="mirar"></a>
## 5. Mirar sin miedo: head, shape, columns, dtypes

```python
train.head()                 # primeras 5 filas
train.shape                  # (398, 31) → 398 caballeros, 31 columnas
train.columns.tolist()       # nombres
train.dtypes                 # tipos (float64, object, …)
train["knight"].value_counts()  # cuántos Jedi / Sith
train.describe()             # media, min, max de columnas numéricas
```

| Comando | Pregunta que responde |
|---------|------------------------|
| `head()` | ¿Se cargó bien? |
| `shape` | ¿Cuántos caballeros y columnas? |
| `value_counts()` | ¿Están equilibrados los bandos? |
| `describe()` | ¿Hay escalas muy distintas entre skills? |

[↑ Índice](#indice)

---

<a id="traintest"></a>
## 6. Train vs Test: con y sin `knight`

| Fichero | Columnas típicas | Target |
|---------|------------------|--------|
| `Train_knight.csv` | 30 skills + **`knight`** | Sí (Jedi / Sith) |
| `Test_knight.csv` | 30 skills | **No** |

```python
assert "knight" in train.columns
assert "knight" not in test.columns
```

**Analogía:** Train es el examen con solucionario (para estudiar). Test es el examen en blanco (mismas preguntas, sin respuestas).

[↑ Índice](#indice)

---

<a id="columnas"></a>
## 7. Seleccionar y quitar columnas

```python
s = train["Strength"]                    # una Series
skills = train[["Strength", "Awareness"]]  # varias
X = train.drop(columns=["knight"])       # todas menos el target
```

```python
num = train.select_dtypes(include="number")  # solo numéricas
```

[↑ Índice](#indice)

---

<a id="xy"></a>
## 8. Separar features (`X`) y target (`y`)

```python
y = train["knight"]
X = train.drop(columns=["knight"])
```

| Variable | Contenido |
|----------|-----------|
| `X` | Skills (números) |
| `y` | Jedi / Sith (texto) |

Nunca dejes `knight` dentro de `X` si más adelante entrenas un modelo (Module 4): sería copiar del solucionario.

[↑ Índice](#indice)

---

<a id="filtrar"></a>
## 9. Filtrar filas (Jedi / Sith)

```python
jedi = train[train["knight"] == "Jedi"]
sith = train[train["knight"] == "Sith"]
```

Útil en histogramas y dispersiones con dos colores (EX00, EX02).

**Analogía:** dos montones de fichas según el color del sello.

[↑ Índice](#indice)

---

<a id="codificar"></a>
## 10. Codificar `knight` a 0/1 para correlaciones

Pearson necesita números. El texto “Jedi”/“Sith” no entra en la fórmula.

```python
df = train.copy()
df["knight_num"] = (df["knight"] == "Jedi").astype(int)
# Jedi → 1,  Sith → 0   (u otro mapeo coherente y documentado)
```

Luego puedes correlacionar cada skill con `knight_num`.

Detalle de la fórmula: [`mates.md`](./mates.md).

[↑ Índice](#indice)

---

<a id="stats"></a>
## 11. Estadísticos rápidos

```python
train["Strength"].mean()
train["Strength"].std()
train["Strength"].min(), train["Strength"].max()
train.groupby("knight")["Strength"].mean()  # media por bando
```

[↑ Índice](#indice)

---

<a id="corr"></a>
## 12. Correlación (EX01)

```python
df = train.copy()
df["knight"] = (df["knight"] == "Jedi").astype(int)
corr = df.corr(numeric_only=True)           # matriz completa
vs_target = corr["knight"].drop("knight")   # solo respecto al target
print(vs_target.abs().sort_values(ascending=False))
```

| Resultado | Lectura |
|-----------|---------|
| \(r\) cerca de +1 | Sube la skill → más probable el lado “1” |
| \(r\) cerca de −1 | Sube la skill → más probable el lado “0” |
| \(r\) cerca de 0 | Poca relación lineal |

[↑ Índice](#indice)

---

<a id="na"></a>
## 13. Valores faltantes

```python
train.isna().sum()
# train = train.dropna()  # opción dura
```

En los CSV del subject suele haber pocos (o ningún) huecos; conviene comprobarlo en defensa.

[↑ Índice](#indice)

---

<a id="escalas"></a>
## 14. Estandarizar y normalizar con pandas + NumPy

### Z-score (EX03) — media 0, desviación 1

```python
X = train.drop(columns=["knight"])
Z = (X - X.mean()) / X.std(ddof=0)   # o ddof=1; sé coherente y explícalo
```

### Min-max (EX04) — típico [0, 1]

```python
X = train.drop(columns=["knight"])
N = (X - X.min()) / (X.max() - X.min())
```

**Cuidado:** si `max == min` en una columna, división por cero → filtrar o saltar esa skill.

Fórmulas y diferencia EX03 vs EX04: [`mates.md`](./mates.md).

[↑ Índice](#indice)

---

<a id="split"></a>
## 15. Split Training / Validation (EX05)

```python
from pathlib import Path

train = pd.read_csv("../data/Train_knight.csv")
# barajar (reproducible)
train = train.sample(frac=1, random_state=42).reset_index(drop=True)

n = len(train)
n_tr = int(0.8 * n)   # 80 % training (ajusta si justificas otro ratio)
training = train.iloc[:n_tr]
validation = train.iloc[n_tr:]

training.to_csv("Training_knight.csv", index=False)
validation.to_csv("Validation_knight.csv", index=False)
print(len(training) / n, len(validation) / n)
```

**Analogía:** separar apuntes de estudio (training) y simulacro de examen (validation) **antes** de mirar el test oficial.

[↑ Índice](#indice)

---

<a id="escribir"></a>
## 16. Escribir CSV de salida

```python
df.to_csv("salida.csv", index=False)  # sin columna de índice 0,1,2…
```

[↑ Índice](#indice)

---

<a id="mapa"></a>
## 17. Mapa: pandas en cada ejercicio

| EX | Uso típico de pandas |
|----|----------------------|
| EX00 | `read_csv`, filtrar Jedi/Sith, columnas de skills |
| EX01 | `read_csv`, codificar target, `.corr()`, ordenar factores |
| EX02 | `read_csv`, dos colores en scatter |
| EX03 | `read_csv`, media/std por columna, z-score |
| EX04 | `read_csv`, min/max, min-max |
| EX05 | `read_csv`, `sample` / trocear, `to_csv` |

[↑ Índice](#indice)

---

<a id="errores"></a>
## 18. Errores frecuentes en 42

| Síntoma | Causa probable | Qué hacer |
|---------|----------------|-----------|
| `FileNotFoundError` | Ruta mal | Comprueba `data/` o variables `KNIGHT_*_CSV` |
| `KeyError: 'knight'` | Estás en Test | Normal: Test no tiene target |
| `could not convert string to float` | `knight` sigue en X | `drop(columns=["knight"])` |
| Correlación “rara” | No codificaste el target | Mapeo 0/1 documentado |
| Split no reproducible | Sin `random_state` | Fija semilla en `sample` |

[↑ Índice](#indice)

---

<a id="defensa"></a>
## 19. Frases útiles en defensa / entrevistas

1. **“Train trae la etiqueta `knight`; Test solo skills.”**  
2. **“Codifico Jedi/Sith a 0/1 solo para poder aplicar Pearson.”**  
3. **“Z-score centra en 0 y escala por σ; min-max comprime al rango [0,1].”**  
4. **“El split 80/20 baraja con semilla para poder repetir el experimento.”**  
5. **“pandas es la mesa de trabajo; matplotlib es el cartel en la pared.”**

[↑ Índice](#indice)

---

<a id="ejercicios"></a>
## 20. Mini ejercicios

1. Si `train.shape == (398, 31)`, ¿cuántas skills hay (sin contar `knight`)?  
2. ¿Por qué `Test_knight.csv` no sirve para calcular correlación con el target?  
3. ¿Qué hace `index=False` en `to_csv`?

(1→30; 2→no hay columna `knight`; 3→no escribe 0,1,2… como columna extra.)

[↑ Índice](#indice)

---

<a id="glosario"></a>
## 21. Glosario

| Término | Significado llano |
|---------|-------------------|
| **DataFrame** | Tabla filas × columnas |
| **Series** | Una columna |
| **Feature** | Columna predictora (skill) |
| **Target** | Columna respuesta (`knight`) |
| **drop** | Quitar filas o columnas |
| **corr** | Matriz de correlaciones |

[↑ Índice](#indice)

---

<a id="relacionado"></a>
## 22. Relacionado

| Recurso | Contenido |
|---------|-----------|
| [`python.md`](./python.md) | Hub Python del Module 3 |
| [`numpy.md`](./numpy.md) | Arrays detrás de corr y escalas |
| [`matplotlib.md`](./matplotlib.md) | Histogramas y dispersiones |
| [`mates.md`](./mates.md) | Pearson, z-score, min-max, split |
| [`evaluation.sh`](./evaluation.sh) | Defensa guiada |
| `ex0N/python.md` | Código de **ese** ejercicio |

---

*pandas.md · Module 3 The present · guía desde cero · no sustituye en.subject.pdf*  
*sternero – 42 Málaga – 2026*
