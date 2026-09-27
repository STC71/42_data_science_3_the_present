# 📍 Ejercicio 02 – points

<p align="center">
  <img src="../imgs/banner_3.jpg" alt="Piscine Data Science – Module 3 – points" width="100%">
</p>

[← README Module 3](../README.md)

---

## 🎯 ¿Qué se pide?

| Requisito | Detalle |
|-----------|---------|
| Directorio | `ex02/` |
| Entrega | **`points.*`** |
| Datos | `Train_knight.csv` **y** `Test_knight.csv` (desde **`../data/`**) |
| Salida | **4** gráficos de puntos (scatter) |

Reglas del subject:

1. Dos gráficos con **Train** y dos con **Test**.  
2. En cada fichero: un par de skills que **separe** clusters y otro que los **mezcle**.

| Panel | Fichero | Idea |
|-------|---------|------|
| Separación + color Jedi/Sith | Train | Clusters visibles |
| Mezcla + color Jedi/Sith | Train | Nubes solapadas |
| Mismos ejes, un color | Test | Sin etiqueta `knight` |
| Mismos ejes, un color | Test | Idem |

## ▶️ Ejecutar

```bash
cd data_science_3_the_present/ex02
python3 points.py
# o ./start.sh
```

Genera `points.png` (y ventana si hay DISPLAY).

## 🎤 Defensa

> “Elijo un par de skills muy ligadas al bando (separación) y un par casi independientes (mezcla). En Train coloreo Jedi/Sith; en Test no hay etiqueta, mismo plano en verde.”

## ✅ Checklist

| Ítem | ☐ |
|------|---|
| `points.*` en `ex02/` | ☐ |
| 4 gráficos (2 Train + 2 Test) | ☐ |
| Un par separa, otro mezcla | ☐ |
| CSV leídos desde `data/` | ☐ |

---

*Module 3 – EX02 – sternero – 42 Málaga – 2026*
