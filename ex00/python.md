# 🐍 Guía Python – EX00 Histogram

<p align="center">
  <img src="./imgs/banner_python.jpg" alt="Piscine Data Science – Module 3 – ex00 – Guía Python" width="100%">
</p>

[← README EX00](./README.md)

---

<a id="indice"></a>
## 📑 Índice

1. [Lee esto primero (sin prisas)](#lee-primero)
2. [¿De qué va este ejercicio, en una frase?](#una-frase)
3. [El cuento de los caballeros (por qué Jedi y Sith)](#cuento)
4. [Palabras que usarás todo el módulo](#palabras)
5. [Los dos ficheros de datos](#ficheros)
6. [Qué es un histograma (con dibujo en texto)](#histograma)
7. [Qué pide el subject (traducido)](#subject)
8. [Qué hace nuestro programa, paso a paso](#programa)
9. [Recorrido de `Histogram.py` (sin miedo)](#codigo)
10. [Cómo ejecutarlo en el campus](#ejecutar)
11. [Cómo mirar los PNG resultantes](#png)
12. [Si algo falla](#fallos)
13. [Checklist antes de la evaluación](#checklist)
14. [Qué decir en la defensa](#defensa)

---

<a id="lee-primero"></a>
## 1. Lee esto primero (sin prisas)

Esta guía **no asume** que sepas estadística, machine learning ni el vocabulario de “data science”.

Sí asume que:

- sabes abrir una carpeta en la terminal,
- has oído que un **CSV** es una tabla guardada como texto (filas y columnas separadas por comas).

Si una palabra sale en **negrita** la primera vez, más abajo se explica. No hace falta memorizar nada: sirve para no perderse en el código ni en la defensa.

[↑ Índice](#indice)

---

<a id="una-frase"></a>
## 2. ¿De qué va este ejercicio, en una frase?

> **Dibujar cómo se reparten los números de cada columna** en dos tablas de caballeros: una **sin** saber de qué bando son, y otra **sabiéndolo**.

Eso es EX00. El resto del documento solo detalla el *cómo*.

[↑ Índice](#indice)

---

<a id="cuento"></a>
## 3. El cuento de los caballeros (por qué Jedi y Sith)

En la piscine no trabajamos con un Excel de la vida real con nombres de clientes. El subject inventa un mundo de **caballeros** inspirado en *Star Wars*:

| En el cuento | En los datos |
|--------------|--------------|
| Un caballero | **Una fila** de la tabla |
| Sus habilidades (fuerza, agilidad…) | **Columnas numéricas** |
| El bando de la Fuerza | Columna de texto **`knight`**: valor `Jedi` o `Sith` |

**¿Por qué Jedi y Sith?**  
Solo son **dos etiquetas** (dos grupos). Podrían haberse llamado “A” y “B”, “benigno” y “maligno”, o “equipo azul” y “equipo rojo”. El PDF del módulo eligió nombres de película para que sea más memorable. **No hace falta conocer Star Wars** para hacer el ejercicio.

Idea útil para más adelante: en problemas reales a menudo quieres predecir un grupo (¿comprará / no comprará?, ¿enfermo / sano?). Aquí el “grupo” es Jedi o Sith.

[↑ Índice](#indice)

---

<a id="palabras"></a>
## 4. Palabras que usarás todo el módulo

### Columna / variable / feature / “skill” (Habilidades)

- **Columna**: un vertical de la tabla (ej. `Strength`, `Empowered`).  
- **Feature** (características): una columna que **describe** al caballero, casi siempre un **número**.  
- En este dataset las features tienen nombres de “habilidades”; por eso a veces decimos **skill**.  
  **Skill = feature = columna numérica de habilidad.** Tres nombres, misma cosa.

### Target / etiqueta / `knight` (Caballero)

- **Target** (objetivo): la columna que indica **a qué grupo pertenece** cada fila.  
- Aquí el target se llama **`knight`** y solo puede ser `Jedi` o `Sith`.  
- También se dice **etiqueta** (label): es la “respuesta correcta” si más adelante entrenaras un modelo.

En EX00 **no entrenamos ningún modelo**. Solo **miramos** los números y, cuando hay target, coloreamos por grupo.

### Train y Test (entrenamiento y prueba)

| Nombre | Idea sencilla |
|--------|----------------|
| **Train** | Tabla con la que **aprendes** cómo es el mundo (incluye la respuesta `knight`) |
| **Test** | Tabla **parecida** pero **sin** la respuesta (para probar modelos más adelante) |

En EX00 no “entrenamos” nada: usamos Train para ver la diferencia entre Jedi y Sith, y Test para ver solo las distribuciones.

[↑ Índice](#indice)

---

<a id="ficheros"></a>
## 5. Los dos ficheros de datos

Se guardan en la carpeta `ex00/data/` del módulo:

| Fichero | ¿Qué trae? | ¿Trae `knight`? |
|---------|------------|-----------------|
| `Train_knight.csv` | Unas **400** filas × **30** habilidades + bando | **Sí** |
| `Test_knight.csv` | Unas **170** filas × **30** habilidades | **No** |

Misma “lista de asignaturas” (mismos nombres de columnas numéricas).  
La diferencia importante: **solo Train te dice si cada fila es Jedi o Sith**.

Analogía casera:

- Train = lista de alumnos **con** la columna “equipo”.  
- Test = lista de notas **sin** decir el equipo.

[↑ Índice](#indice)

---

<a id="histograma"></a>
## 6. Qué es un histograma

Un **histograma** responde: *“¿cuántas filas tienen un valor entre X e Y?”*

1. Se parte el eje de números en trozos (se llaman **bins** o intervalos).  
2. Se cuenta cuántos caballeros caen en cada trozo.  
3. Se dibuja una barra: más alta = más gente en ese rango.

```text
Valores de una skill:   1.1   1.4   2.0   2.2   4.8

Intervalos:            [1–2)  [2–3)  …  [4–5)
Personas en cada uno:    2      2         1

Barras:
   ██
   ██   ██
   ██   ██     ██
 [1-2][2-3]  [4-5]
```

No es un gráfico de categorías (“lunes, martes…”): resume la **forma** de una columna de números (¿todos juntos?, ¿hay valores muy altos raros?).

Cada panel es una skill distinta, y matplotlib (la biblioteca de Python diseñada para crear gráficos y visualizaciones de datos de forma sencilla) ajusta los ejes a los datos de ese panel. No hay un único eje X/Y para todo el mural.

Eje X (horizontal) — **“¿en qué rango viven los números de esta columna?”**

- El histograma de **Power** no puede compartir el mismo X que **Agility**: si lo forzásemos, una de las dos se vería aplastada o invisible. Por eso en el PNG cada subplot tiene su propio mínimo/máximo en X (el de sus valores).
- En resumen: cada skill(habilidad) usa unidades y rangos distintos

Eje Y (vertical) — **“¿cuántas filas caen en cada trozo?”**

- Es un conteo (cuántos caballeros en cada bin), no la skill en sí.
- Bin: contenedor, intervalo o trozo

Cambia de un panel a otro porque:

- Forma de la distribución — si casi todos se amontonan en pocos bins, la barra más alta es muy grande; si se reparten, las barras son más bajas.
- En Train, dos series — Jedi + Sith; a veces un bando domina un rango y el pico del eje Y sube (ej. Friendship en rojo).
- Mismo número de bins (20), distinto reparto — 20 trozos sobre un rango estrecho ≠ 20 trozos sobre un rango ancho.
- Por defecto no se usa sharey=True: cada panel escala el Y a su máximo local para que se lea bien.

| Eje | Qué representa | Unidades |
| - | - | - |
| X (horizontal) | El valor de esa skill  | "Las de esa columna (p. ej. Strength ~40–180, Agility ~0.07–0.14)" |
| Y (vertical) | Cuántos caballeros tienen un valor de esa skill en ese trozo del eje X | "Personas (conteo), no “puntos de habilidad” |

## Ejemplo concreto

Panel Strength en Test:

- X = 80 → “skill Strength alrededor de 80”
- Y = 25 → “unas 25 filas del CSV caen en ese intervalo de Strength”

Panel Agility:

- X = 0.10 → “Agility alrededor de 0.10” (otra magnitud)
- Y = 25 → otra vez “número de caballeros en ese trozo”, no el valor de Agility


En Train (dos colores)

- X sigue siendo el valor de la skill.
- Y sigue siendo cuántos hay en ese trozo.
- Azul / rojo = de esos, cuántos son Jedi o Sith.

[↑ Índice](#indice)

---

<a id="subject"></a>
## 7. Qué pide el subject (traducido)

El PDF dice, en resumen:

1. Crear un programa entregable llamado **`Histogram.*`** (nosotros: `Histogram.py`).  
2. Un gráfico a partir de **`Test_knight.csv`**.  
3. Un gráfico a partir de **`Train_knight.csv`** que deje ver la **relación** entre las habilidades y la columna **`knight`**.

Nosotros lo resolvemos así (válido y claro):

| Fichero | Qué dibujamos |
|---------|----------------|
| Test | Una **rejilla** de histogramas: **un panel por skill**, un solo color |
| Train | **La misma idea**, pero en cada panel **dos** histogramas semi-transparentes: uno Jedi, uno Sith |

Así, en Train, si en una skill el montón azul y el rojo casi no se pisan, esa skill **separa** bien los bandos. Si se pisan del todo, esa skill **no** informa mucho del bando.

[↑ Índice](#indice)

---

<a id="programa"></a>
## 8. Qué hace nuestro programa, paso a paso

Imagina un robot con instrucciones en español:

1. **Buscar** en el disco los ficheros `Train_knight.csv` y `Test_knight.csv`.  
2. **Leerlos** como tablas (pandas).  
3. **Test:** para cada columna numérica, dibujar un histograma y guardar la foto `histogram_test.png`.  
4. **Train:** igual, pero partiendo las filas en Jedi y Sith y dibujando ambos; guardar `histogram_train.png`.  
5. Mostrar un poco de texto en consola (tamaños, cuántos Jedi/Sith) para que veas que todo cuadra.

No hay base de datos ni Docker en este ejercicio: **solo CSV + Python + gráficos**.

[↑ Índice](#indice)

---

<a id="codigo"></a>
## 9. Recorrido de `Histogram.py` (sin miedo)

No hace falta saberse el archivo de memoria. Basta reconocer **quién hace qué**:

| Parte del código | Trabajo en cristiano |
|------------------|----------------------|
| `ensure_dependencies` | Si faltan librerías (`pandas`, `matplotlib`…), intenta instalarlas |
| `find_csv` | Encuentra cada CSV (carpeta del ejercicio, `data/`, o rutas que dejó el menú `start.sh`) |
| `feature_columns` | Lista las columnas que **no** se llaman `knight` (solo números de skills) |
| `grid_shape` | Calcula cuántas filas y columnas de paneles hacen falta (p. ej. 5 columnas) |
| `plot_test_histograms` | Dibuja y guarda el PNG de Test |
| `plot_train_histograms` | Dibuja y guarda el PNG de Train (dos colores) |
| `main` | Ordena: buscar → leer → imprimir resumen → llamar a los dos dibujos |

Flujo visual:

```text
  Test_knight.csv  →  tabla  →  muchos histogramas (1 color)  →  histogram_test.png
  Train_knight.csv →  tabla  →  muchos histogramas (2 colores) →  histogram_train.png
```

### Detalle útil: “rejilla”

En lugar de 30 ventanas, se crea **una figura** con muchos huecos (como un mural de fotos). Cada hueco es el histograma de **una** skill. Eso es `plt.subplots(...)`.

### Detalle útil: transparencia (`alpha`)

En Train, las barras de Jedi y Sith se dibujan un poco transparentes para que, si se solapan, **se vean las dos**.

[↑ Índice](#indice)

---

<a id="ejecutar"></a>
## 10. Cómo ejecutarlo en el campus

```bash
cd .../data_science_3_the_present/ex00

# Si los CSV no están aquí, el menú puede buscarlos y copiarlos:
chmod +x start.sh
./start.sh          # opción 2 = sincronizar CSV; opción 3 = ejecutar

# O a mano (sin ventana gráfica, solo genera PNG):
MPLBACKEND=Agg python3 Histogram.py
```

Si falta `pandas`:

```bash
pip install --user pandas matplotlib numpy
```

[↑ Índice](#indice)

---

<a id="png"></a>
## 11. Cómo mirar los PNG resultantes

| Archivo | Qué deberías reconocer |
|---------|-------------------------|
| `histogram_test.png` | Muchos paneles; **un** color; títulos = nombres de skills |
| `histogram_train.png` | Misma estructura; **dos** colores y leyenda Jedi / Sith |

Preguntas buenas al mirar Train:

- ¿Hay skills donde un color está casi solo a la izquierda y el otro a la derecha?  
- ¿Hay skills donde los dos colores son casi el mismo dibujo?

Eso prepara el terreno para **EX01 (correlación)**: medir con un número lo que aquí solo se intuye a ojo.

[↑ Índice](#indice)

---

<a id="fallos"></a>
## 12. Si algo falla

| Mensaje o síntoma | Significado sencillo | Qué hacer |
|-------------------|---------------------|-----------|
| No encuentra el CSV | El archivo no está donde el script mira | `./start.sh` opción 2, o copia los CSV a `ex00/` |
| `No module named pandas` | Python no tiene esa librería | `pip install --user pandas` |
| No se crean los PNG | El programa se detuvo antes de guardar | Lee el error en rojo en la terminal |
| Train sale de un solo color | Falta la columna `knight` o el CSV es el de Test | Abre el CSV y mira la primera línea (cabecera) |

[↑ Índice](#indice)

---

<a id="checklist"></a>
## 13. Checklist antes de la evaluación

| Pregunta | ☐ |
|----------|---|
| ¿Está `Histogram.py` en `ex00/`? | ☐ |
| ¿Puedo generar el gráfico de **Test**? | ☐ |
| ¿Puedo generar el de **Train** con Jedi y Sith visibles? | ☐ |
| ¿Sé explicar con mis palabras qué es Train, Test y `knight`? | ☐ |

[↑ Índice](#indice)

---

<a id="defensa"></a>
## 14. Qué decir en la defensa (guion corto)

Puedes usar algo así, con tus palabras:

1. “Tenemos caballeros descritos por muchas columnas numéricas; el bando es Jedi o Sith.”  
2. “Test no trae el bando: solo muestro cómo se reparten los números.”  
3. “Train sí trae el bando: superpongo dos histogramas para ver qué habilidades separan los grupos.”  
4. “El programa lee los CSV, dibuja una rejilla con matplotlib y guarda dos PNG.”

Si preguntan *qué es el target*: “La columna que indica el grupo, aquí `knight`.”  
Si preguntan *qué es una feature*: “Cada columna numérica que describe al caballero.”

[↑ Índice](#indice)

---

*Module 3 – EX00 – Guía Python · sternero – 42 Málaga – Octubre 2026*
