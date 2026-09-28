# 📐 Ejercicio 04 – Normalization

<p align="center">
  <img src="../imgs/banner_34.jpg" alt="Piscine Data Science – Module 3 – Normalization" width="100%">
</p>

[← README Module 3](../README.md) · [Guía Python](./python.md)

---

## 🎯 Objetivo

Llevar cada skill al intervalo **[0, 1]** (normalización min-max), imprimir antes/después y redibujar los **otros** gráficos de EX02 (los que no se usaron en EX03) con esos valores.

| | EX03 standardization | **EX04 Normalization** |
|--|----------------------|-------------------------|
| Fórmula | \(z = (x-\mu)/\sigma\) | \(x' = (x-\min)/(\max-\min)\) |
| Escala típica | media ≈ 0, std ≈ 1 | **[0, 1]** |
| Gráfico EX02 | **Uno** (par que separa, Train) | **Los otros** (par que mezcla + Test) |

---

## 📜 Subject

| Campo | Valor |
|-------|--------|
| Directorio | `ex04/` |
| Entrega | **`Normalization.*`** |
| Datos | Train **y** Test desde `../data/` |

1. Normalize and **print** your data.  
2. Display **the other graphs** from exercise 02 with the normalized data.  
3. Works with both CSV files.

---

## ▶️ Ejecutar

```bash
cd data_science_3_the_present/ex04
python3 Normalization.py
# MPLBACKEND=Agg python3 Normalization.py
```

Salida: tablas original + [0,1] y `normalization_scatter.png`.

---

## 🎤 Defensa

> “Normalizo min-max cada skill a [0, 1]. Imprimo original y normalizado. EX03 ya mostró el scatter que separa con z-score; aquí muestro los otros de EX02 (mezcla y Test) con datos en [0, 1].”

---

## ✅ Checklist

| Ítem | ☐ |
|------|---|
| `Normalization.*` | ☐ |
| Print original + normalizado (Train y Test) | ☐ |
| Otros gráficos de EX02 con datos normalizados | ☐ |
| CSV desde `data/` | ☐ |

---

*Module 3 – EX04 – sternero – 42 Málaga – 2026*
