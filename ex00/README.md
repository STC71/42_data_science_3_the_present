# 📊 Ejercicio 00 – Histogram

<p align="center">
  <img src="../imgs/banner_30.jpg" alt="Piscine Data Science – Module 3 – Histogram" width="100%">
</p>

[← README Module 3](../README.md)

---

## 🎯 ¿Qué se pide?

| Requisito | Detalle |
|-----------|---------|
| Directorio | `ex00/` |
| Entrega | **`Histogram.*`** |
| Test | Histograma(s) de las skills en `Test_knight.csv` |
| Train | Misma idea con `Train_knight.csv` mostrando **interacción** skills × **`knight`** |

## 📁 Archivos

| Archivo | Rol |
|---------|-----|
| [`Histogram.py`](./Histogram.py) | Entrega |
| [`python.md`](./python.md) | Guía |
| [`start.sh`](./start.sh) | Menú opcional |
| `Train_knight.csv` / `Test_knight.csv` | Datos (o en `../data/`) |


PNG:

| Fichero | Contenido |
|---------|-----------|
| [`histogram_test.png`](./histogram_test.png) | Features (Test) |
| [`histogram_train.png`](./histogram_train.png) | Features × Jedi/Sith (Train) |

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

## ▶️ Ejecutar

```bash
cd data_science_3_the_present/ex00
MPLBACKEND=Agg python3 Histogram.py
./start.sh
```

## 🎤 Defensa

> “En Test miro la distribución de cada skill. En Train superpongo Jedi y Sith por feature para ver qué habilidades separan mejor los bandos.”

## ✅ Checklist

| Ítem | ☐ |
|------|---|
| Entrega `Histogram.*` | ☐ |
| Gráfico Test | ☐ |
| Gráfico Train con target `knight` | ☐ |

---

*Module 3 – EX00 – sternero – 42 Málaga – Octubre 2026*
