# 📈 Matplotlib en el Module 3 – The present

<p align="center">
  <img src="./imgs/banner_00.jpg" alt="Piscine Data Science – Module 3 – Guía Matplotlib" width="100%">
</p>

[← README](./README.md) · [🐍 python.md](./python.md) · [🐼 pandas.md](./pandas.md) · [🔢 numpy.md](./numpy.md) · [📐 mates.md](./mates.md)

---

Guía **didáctica de matplotlib** para histogramas, dispersiones y comparaciones de escala.  
Pensada para quien **no ha dibujado nunca** un gráfico con código.

No sustituye al subject ni a los entregables.  
No sustituye los `ex0N/python.md`.

> **Analogía global:** matplotlib es el **cuaderno de dibujo**.  
> pandas/NumPy preparan los números; matplotlib los **pinta** para la defensa y el PDF del subject.

---

## 📑 Índice

1. [Lee esto primero](#lee)
2. [¿Qué problema resuelve aquí?](#problema)
3. [Instalar e importar](#instalar)
4. [Backend: ventana vs PNG (campus 42)](#backend)
5. [Figure y Axes](#figure)
6. [Histograma (EX00)](#hist)
7. [Dispersión / puntos (EX02, EX03, EX04)](#scatter)
8. [Varios paneles (`subplots`)](#subplots)
9. [Títulos, etiquetas, leyenda en español](#estilo)
10. [Guardar y mostrar](#guardar)
11. [Avisos típicos (cache, Axes3D, Agg)](#avisos)
12. [Mapa por ejercicio](#mapa)
13. [Errores frecuentes](#errores)
14. [Defensa: cómo comentar un gráfico](#defensa)
15. [Glosario](#glosario)
16. [Relacionado](#relacionado)

---

<a id="lee"></a>
## 1. Lee esto primero

| Pregunta | Respuesta |
|----------|-----------|
| ¿Obliga el subject a matplotlib? | Pide **gráficos**; matplotlib es la librería de este repo. |
| ¿Siempre hay que abrir ventana? | En cluster suele bastar **PNG** + visor. |
| ¿EX01 dibuja? | Puede ser solo ranking numérico; el resto sí visualiza. |

[↑ Índice](#indice)

---

<a id="problema"></a>
## 2. ¿Qué problema resuelve aquí?

| Pregunta | Tipo de gráfico |
|----------|-----------------|
| ¿Cómo se reparte cada skill? ¿Se separan los bandos? | Histograma |
| ¿Dos skills separan Jedi/Sith en el plano? | Dispersión (scatter) |
| ¿Cómo cambia el plano tras z-score o min-max? | Scatter antes/después |

**Analogía:** no lees 398 filas en voz alta; enseñas el mapa.

[↑ Índice](#indice)

---

<a id="instalar"></a>
## 3. Instalar e importar

```bash
python3 -m pip install --user matplotlib
```

```python
import matplotlib
matplotlib.use("Agg")  # opcional: solo fichero, sin ventana
import matplotlib.pyplot as plt
```

[↑ Índice](#indice)

---

<a id="backend"></a>
## 4. Backend: ventana vs PNG (campus 42)

| Situación | Enfoque |
|-----------|---------|
| Hay `DISPLAY` y quieres ver al vuelo | `plt.show()` |
| Cluster / evaluación headless | `Agg` + `savefig` |

```bash
export MPLCONFIGDIR="$HOME/goinfre/.cache/matplotlib"
mkdir -p "$MPLCONFIGDIR"
```

Evita errores de cuota en `~/.cache`.

[↑ Índice](#indice)

---

<a id="figure"></a>
## 5. Figure y Axes

- **Figure** = la página completa.  
- **Axes** = un gráfico dentro de la página.

```python
fig, ax = plt.subplots(figsize=(8, 5))
ax.hist(...)
ax.set_title("...")
fig.savefig("hist.png", dpi=140, bbox_inches="tight")
plt.close(fig)
```

[↑ Índice](#indice)

---

<a id="hist"></a>
## 6. Histograma (EX00)

```python
fig, ax = plt.subplots()
ax.hist(jedi["Strength"], bins=20, alpha=0.6, label="Jedi")
ax.hist(sith["Strength"], bins=20, alpha=0.6, label="Sith")
ax.set_xlabel("Valor de la skill")
ax.set_ylabel("Número de caballeros")
ax.set_title("Train – Strength separa (o no) los bandos")
ax.legend()
```

| Eje | Significado |
|-----|-------------|
| X | Valor de la skill |
| Y | **Cuántos** caballeros en ese tramo |

Más detalle: [`mates.md`](./mates.md) § histogramas.

[↑ Índice](#indice)

---

<a id="scatter"></a>
## 7. Dispersión / puntos (EX02, EX03, EX04)

```python
ax.scatter(jedi["A"], jedi["B"], label="Jedi", alpha=0.7)
ax.scatter(sith["A"], sith["B"], label="Sith", alpha=0.7)
ax.set_xlabel("Skill A")
ax.set_ylabel("Skill B")
ax.legend()
```

**Qué mirar en defensa:**

- ¿Los dos colores forman nubes distintas o se mezclan?  
- Tras estandarizar/normalizar, ¿cambia la **forma** relativa o solo la escala de los ejes?

[↑ Índice](#indice)

---

<a id="subplots"></a>
## 8. Varios paneles (`subplots`)

El subject de EX02 habla de varios paneles (p. ej. 4):

```python
fig, axes = plt.subplots(2, 2, figsize=(10, 8))
axes = axes.ravel()
# axes[0].scatter(...)
# axes[1].scatter(...)
fig.suptitle("Comparación de pares de skills")
fig.tight_layout()
```

[↑ Índice](#indice)

---

<a id="estilo"></a>
## 9. Títulos, etiquetas, leyenda en español

Buen reporting (también de cara a selectivos):

```python
ax.set_title("Train – dos skills que SÍ separan los bandos")
ax.set_xlabel("Skill A (unidades del CSV)")
ax.set_ylabel("Skill B")
ax.legend(title="Bando")
fig.text(0.5, 0.01,
         "Cada punto es un caballero. Colores = Jedi / Sith.",
         ha="center", fontsize=9)
```

[↑ Índice](#indice)

---

<a id="guardar"></a>
## 10. Guardar y mostrar

```python
fig.savefig("histogram_train.png", dpi=140, bbox_inches="tight")
plt.show()   # si hay display; con Agg puede avisar y no abrir ventana
plt.close(fig)
```

[↑ Índice](#indice)

---

<a id="avisos"></a>
## 11. Avisos típicos (cache, Axes3D, Agg)

| Aviso | Qué hacer |
|-------|-----------|
| No space in `~/.cache/matplotlib` | `MPLCONFIGDIR` en goinfre |
| Unable to import Axes3D | Varias installs; no bloquea 2D |
| FigureCanvasAgg is non-interactive | Normal con `Agg`; confía en el PNG |

[↑ Índice](#indice)

---

<a id="mapa"></a>
## 12. Mapa por ejercicio

| EX | Gráficos típicos |
|----|------------------|
| EX00 | Histogramas Train (2 bandos) y Test |
| EX01 | A menudo solo texto/ranking (sin figura) |
| EX02 | Varios scatter |
| EX03 | Scatter tras z-score (+ print de valores) |
| EX04 | Scatter tras min-max (+ print) |
| EX05 | Sin gráfico obligatorio (CSV de split) |

[↑ Índice](#indice)

---

<a id="errores"></a>
## 13. Errores frecuentes

| Síntoma | Qué mirar |
|---------|-----------|
| Gráfico en blanco | Series vacías / filtro mal |
| Leyenda confusa | `label=` en cada `hist`/`scatter` |
| Ejes sin nombre | `set_xlabel` / `set_ylabel` |
| PNG no aparece | Ruta de `savefig` y directorio de trabajo |

[↑ Índice](#indice)

---

<a id="defensa"></a>
## 14. Defensa: cómo comentar un gráfico

1. **Qué datos** (Train/Test, skills, filtro Jedi/Sith).  
2. **Cómo se ve** (histograma vs nube de puntos).  
3. **Por qué ese tipo** (distribución vs separación en el plano).  
4. **Qué se debería notar** (solape de bandos, cambio de escala tras EX03/04).

[↑ Índice](#indice)

---

<a id="glosario"></a>
## 15. Glosario

| Término | Significado |
|---------|-------------|
| **Figure** | Página del gráfico |
| **Axes** | Un dibujo dentro de la página |
| **bins** | Cajones del histograma |
| **savefig** | Guardar PNG |
| **alpha** | Transparencia (0–1) |

[↑ Índice](#indice)

---

<a id="relacionado"></a>
## 16. Relacionado

| Recurso | Contenido |
|---------|-----------|
| [`pandas.md`](./pandas.md) | De dónde salen las Series |
| [`numpy.md`](./numpy.md) | Arrays de coordenadas |
| [`python.md`](./python.md) | Hub del módulo |
| [`mates.md`](./mates.md) | Lectura de ejes y escalas |
| [`evaluation.sh`](./evaluation.sh) | Abrir PNG y comentarlos |
| `ex0N/python.md` | Cómo **ese** script dibuja |

---

*matplotlib.md · Module 3 The present · guía desde cero · no sustituye en.subject.pdf*  
*sternero – 42 Málaga – 2026*
