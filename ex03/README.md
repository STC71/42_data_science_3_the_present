# 📏 Ejercicio 03 – standardization

<p align="center">
  <img src="../imgs/banner_33.jpg" alt="Piscine Data Science – Module 3 – standardization" width="100%">
</p>

[← README Module 3](../README.md) · [Guía Python](./python.md)

---

## 🎯 Objetivo

Poner todas las skills en la **misma escala** (media ≈ 0, desviación ≈ 1) para poder compararlas y volver a dibujar un scatter de EX02 con esos valores.

---

## 📜 Subject

| Campo | Valor |
|-------|--------|
| Directorio | `ex03/` |
| Entrega | **`standardization.*`** |
| Datos | Train **y** Test (desde `../data/`) |

1. **Estandarizar e imprimir** los datos (original + transformado).  
2. **Mostrar uno** de los gráficos de EX02 con datos ya estandarizados.  
3. Debe funcionar con ambos CSV.

---

## 📐 Fórmula (z-score)

Para cada skill numérica:

\[
z = \frac{x - \mu}{\sigma}
\]

- \(\mu\) = media de esa columna en el fichero  
- \(\sigma\) = desviación típica de esa columna  

`knight` (texto) **no** se transforma.

---

## ▶️ Ejecutar

```bash
cd data_science_3_the_present/ex03
python3 standardization.py
# MPLBACKEND=Agg python3 standardization.py
```

Salida:

- Tabla original y tabla z-score (Train y Test), estilo subject.  
- `standardization_scatter.png` (par Awareness × Strength de EX02, Train coloreado).

---

## 🎤 Defensa

> “Estandarizo cada skill con (x − media) / std. Así todas quedan centradas en 0 y con escala 1. Imprimo antes/después y repito el scatter de separación de EX02 con los valores z.”

---

## ✅ Checklist

| Ítem | ☐ |
|------|---|
| `standardization.*` | ☐ |
| Print original + estandarizado (Train y Test) | ☐ |
| Un gráfico de EX02 con datos z-score | ☐ |
| CSV desde `data/` | ☐ |

---

*Module 3 – EX03 – sternero – 42 Málaga – Octubre 2026*
