# 🐍 Guía Python – EX02 points

<p align="center">
  <img src="./imgs/banner_python.jpg" alt="Piscine Data Science – Module 3 – ex02 – Guía Python" width="100%">
</p>

[← README EX02](./README.md)

---

## 1. ¿Qué es un gráfico de puntos (scatter)?

Cada **fila** del CSV es un punto en el plano:

- **Eje X** = valor de una skill  
- **Eje Y** = valor de otra skill  

Si en Train coloreamos por `knight`, vemos si Jedi y Sith forman **grupos** o se **mezclan**.

## 2. Qué pide el subject

| Pieza | Significado |
|-------|-------------|
| **4 gráficos** | 2 pares × 2 ficheros (Train y Test) |
| **Separar clusters** | Elegir skills donde los bandos se ven aparte |
| **Mezclar** | Elegir skills donde se pisan |

Test **no** tiene `knight` → todos los puntos del mismo color (como el PDF en verde).

## 3. Por qué esos pares en nuestro código

| Par | Rol | Motivo |
|-----|-----|--------|
| **Awareness × Strength** | Separación | Muy relacionadas con el bando (EX01); nubes distintas |
| **Push × Mass** | Mezcla | Correlación baja con `knight`; se solapan |

Puedes cambiar los nombres en `PAIR_SEPARATE` / `PAIR_MIX` si en defensa quieres otro ejemplo, siempre que se vea claro separar vs mezclar.

## 4. Datos desde `data/`

Igual que EX01: no hace falta copiar CSV a `ex02/`.  
`find_csv` mira primero `../data/`.

## 5. Cómo ejecutar

```bash
cd ex02
MPLBACKEND=Agg python3 points.py
```

Salida: `points.png` con la rejilla 2×2.

## 6. Defensa (4 frases)

1. “Scatter: cada caballero es un punto (skill X, skill Y).”  
2. “Un par separa Jedi/Sith; el otro los mezcla.”  
3. “Train lleva color por bando; Test no tiene etiqueta.”  
4. “Así se ve en el plano lo que EX01 midió con números.”

---

*Module 3 – EX02 – Guía Python · sternero – 42 Málaga – 2026*
