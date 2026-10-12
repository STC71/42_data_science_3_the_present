# 🔢 NumPy en el Module 3 – The present

<p align="center">
  <img src="./imgs/banner_00.jpg" alt="Piscine Data Science – Module 3 – Guía NumPy" width="100%">
</p>

[← README](./README.md) · [🐍 python.md](./python.md) · [🐼 pandas.md](./pandas.md) · [📈 matplotlib.md](./matplotlib.md) · [📐 mates.md](./mates.md)

---

Guía **didáctica de NumPy** para este módulo (CSV de caballeros, **sin** warehouse).  
Pensada para quien **no ha visto nunca** un array.

No sustituye al subject ni a los scripts.  
No sustituye los `ex0N/python.md`.

> **Analogía global:** una lista de Python es una fila de cajas sueltas.  
> Un **array NumPy** es una bandeja de huevos: mismos tipos, operaciones **de golpe**.

En Module 3, NumPy aparece cuando:

- calculas medias, desviaciones o matrices de correlación,
- aplicas z-score / min-max a **todas** las columnas,
- matplotlib recibe coordenadas X/Y.

---

## 📑 Índice

1. [Lee esto primero](#lee)
2. [Instalar e importar](#instalar)
3. [Lista vs array](#lista)
4. [Crear arrays](#crear)
5. [shape y dtype](#shape)
6. [Operaciones vectorizadas](#vector)
7. [Estadística útil aquí](#stats)
8. [Axis: por filas o por columnas](#axis)
9. [De pandas a NumPy](#pandas)
10. [Z-score y min-max en bloque](#escalas)
11. [Mapa por ejercicio](#mapa)
12. [Errores frecuentes](#errores)
13. [Defensa / entrevistas](#defensa)
14. [Glosario](#glosario)
15. [Relacionado](#relacionado)

---

<a id="lee"></a>
## 1. Lee esto primero

| Pregunta | Respuesta |
|----------|-----------|
| ¿Obligatorio? | No; pandas + listas bastan a veces. NumPy acelera y aclara. |
| ¿Hace falta ser matemático? | No. Piensa en “tablas de números”. |
| ¿Dónde brilla? | EX01 (corr), EX03–EX04 (escalas), ejes de gráficos. |

[↑ Índice](#indice)

---

<a id="instalar"></a>
## 2. Instalar e importar

```bash
python3 -m pip install --user numpy
```

```python
import numpy as np
```

[↑ Índice](#indice)

---

<a id="lista"></a>
## 3. Lista vs array

```python
xs_list = [1.0, 2.0, 3.0]
xs = np.array([1.0, 2.0, 3.0])
print(xs * 2)   # [2. 4. 6.]  de golpe
```

| Lista | Array |
|-------|-------|
| Tipos mezclados posibles | Homogéneo (casi siempre float) |
| Bucles `for` | Operaciones vectorizadas |

[↑ Índice](#indice)

---

<a id="crear"></a>
## 4. Crear arrays

```python
np.array([1.0, 2.0, 3.0])
np.zeros(5)
np.ones((3, 2))
np.arange(0, 1.1, 0.1)
```

Desde una columna pandas:

```python
a = train["Strength"].to_numpy()
```

[↑ Índice](#indice)

---

<a id="shape"></a>
## 5. shape y dtype

```python
X = train.drop(columns=["knight"]).to_numpy()
print(X.shape)   # (398, 30) → 398 caballeros × 30 skills
print(X.dtype)   # float64
```

**Analogía:** el cartel del envase: “398 filas, 30 skills”.

[↑ Índice](#indice)

---

<a id="vector"></a>
## 6. Operaciones vectorizadas

```python
x = np.array([10.0, 20.0, 30.0])
print(x - x.mean())
print(x / x.std())
```

Más rápido y legible que un `for` manual sobre 30 columnas.

[↑ Índice](#indice)

---

<a id="stats"></a>
## 7. Estadística útil aquí

```python
np.mean(x)
np.std(x)          # cuidado con ddof=0 vs 1
np.min(x), np.max(x)
np.percentile(x, [25, 50, 75])
np.corrcoef(a, b)  # correlación entre dos vectores
```

Pearson detallado: [`mates.md`](./mates.md).

[↑ Índice](#indice)

---

<a id="axis"></a>
## 8. Axis: por filas o por columnas

```python
X.mean(axis=0)  # media de cada skill (a lo largo de los caballeros)
X.mean(axis=1)  # media de cada caballero (poco habitual aquí)
```

| axis | Idea |
|------|------|
| `0` | “Baja por la columna” |
| `1` | “Avanza por la fila” |

**Analogía:** axis=0 = calcular la nota media de cada asignatura (columna) mirando a todos los alumnos.

[↑ Índice](#indice)

---

<a id="pandas"></a>
## 9. De pandas a NumPy

```python
X = train.drop(columns=["knight"]).to_numpy(dtype=float)
y = (train["knight"] == "Jedi").to_numpy().astype(int)
```

matplotlib acepta listas, Series o arrays; por debajo suele acabar en NumPy.

[↑ Índice](#indice)

---

<a id="escalas"></a>
## 10. Z-score y min-max en bloque

```python
# Z-score por columna
mu = X.mean(axis=0)
sigma = X.std(axis=0)
sigma[sigma == 0] = 1.0          # evitar dividir por 0
Z = (X - mu) / sigma

# Min-max por columna
lo, hi = X.min(axis=0), X.max(axis=0)
span = hi - lo
span[span == 0] = 1.0
N = (X - lo) / span
```

[↑ Índice](#indice)

---

<a id="mapa"></a>
## 11. Mapa por ejercicio

| EX | Rol de NumPy |
|----|----------------|
| EX00 | Bins / conteos auxiliares (a veces solo matplotlib) |
| EX01 | Vectores para corrcoef o soporte de `.corr()` |
| EX02 | Coordenadas X/Y |
| EX03–04 | Matrices de skills transformadas |
| EX05 | Opcional (el split puede ser solo pandas) |

[↑ Índice](#indice)

---

<a id="errores"></a>
## 12. Errores frecuentes

| Síntoma | Qué mirar |
|---------|-----------|
| `No module named numpy` | `pip install --user numpy` |
| División por cero en std/max-min | Columna constante → proteger |
| `nan` en correlaciones | Constantes o huecos |
| Choque NumPy 1.x / 2.x con matplotlib | Reinstalar en `~/.local` o fijar versiones |

[↑ Índice](#indice)

---

<a id="defensa"></a>
## 13. Defensa / entrevistas

1. **“`shape (398, 30)` son caballeros × skills.”**  
2. **“`axis=0` resume cada columna (cada skill).”**  
3. **“Escalo en bloque para no escribir 30 bucles.”**  
4. **“pandas organiza la tabla; NumPy hace la aritmética rápida.”**

[↑ Índice](#indice)

---

<a id="glosario"></a>
## 14. Glosario

| Término | Significado |
|---------|-------------|
| **array** | Bloque homogéneo de números |
| **shape** | Dimensiones |
| **axis** | Dirección del resumen |
| **vectorizado** | Operar todo el bloque de una vez |

[↑ Índice](#indice)

---

<a id="relacionado"></a>
## 15. Relacionado

| Recurso | Contenido |
|---------|-----------|
| [`pandas.md`](./pandas.md) | CSV, DataFrame, train/test |
| [`matplotlib.md`](./matplotlib.md) | Dibujar arrays |
| [`python.md`](./python.md) | Hub del módulo |
| [`mates.md`](./mates.md) | Fórmulas |
| `ex0N/python.md` | Script de cada EX |

---

*numpy.md · Module 3 The present · guía desde cero · no sustituye en.subject.pdf*  
*sternero – 42 Málaga – 2026*
