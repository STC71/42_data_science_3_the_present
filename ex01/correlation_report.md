# Informe de correlación – EX01

*Generado por `Correlation.py` · 2026-09-27 11:30 UTC*

## 1. Datos

| Campo | Valor |
|-------|-------|
| Fichero | `/sgoinfre/students/sternero/42_outer_core/piscine_pedago_data_science/data_science_3_the_present/data/Train_knight.csv` |
| Forma | 398 filas × 31 columnas |
| Target | `knight` (Jedi / Sith) |
| Conteo `Sith` | 246 |
| Conteo `Jedi` | 152 |

## 2. Qué se ha calculado

La **correlación de Pearson** entre cada **feature** (skill numérica) y el **target** `knight`. El target se codifica en números porque Pearson solo trabaja con valores numéricos:

- `Sith` → **0**
- `Jedi` → **1**

El coeficiente **r** está entre −1 y +1: cerca de ±1 hay relación lineal fuerte; cerca de 0, poca relación lineal.

## 3. Tabla completa (orden del subject: de mayor a menor r)

| Columna | r (Pearson) | Lectura breve |
|---------|------------:|---------------|
| knight | 1.000000 | target consigo mismo (siempre 1) |
| Empowered | 0.793652 | fuerte; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Prescience | 0.790066 | fuerte; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Stims | 0.786797 | fuerte; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Recovery | 0.777633 | fuerte; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Sprint | 0.739672 | fuerte; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Strength | 0.737403 | fuerte; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Sensitivity | 0.721566 | fuerte; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Power | 0.700709 | fuerte; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Awareness | 0.699662 | moderada; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Attunement | 0.648893 | moderada; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Dexterity | 0.631987 | moderada; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Delay | 0.598072 | moderada; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Slash | 0.550663 | moderada; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Pull | 0.537800 | moderada; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Lightsaber | 0.515340 | moderada; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Evade | 0.465605 | moderada; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Hability | 0.446632 | moderada; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Burst | 0.445847 | moderada; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Combo | 0.445223 | moderada; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Blocking | 0.421950 | moderada; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Agility | 0.397458 | débil; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Reactivity | 0.375103 | débil; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Grasping | 0.350105 | débil; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Repulse | 0.324399 | débil; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Friendship | 0.236633 | débil; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Mass | 0.113185 | muy débil / casi nula; positiva (cuando la skill sube, el código del bando tiende a subir) |
| Midi-chlorien | 0.008132 | muy débil / casi nula; sin dirección clara |
| Push | -0.019446 | muy débil / casi nula; sin dirección clara |
| Deflection | -0.026489 | muy débil / casi nula; sin dirección clara |
| Survival | -0.043099 | muy débil / casi nula; sin dirección clara |

## 4. Conclusiones

### Más correlacionadas con el bando

- **Empowered** (`r = 0.7937`): fuerte; positiva (cuando la skill sube, el código del bando tiende a subir).
- **Prescience** (`r = 0.7901`): fuerte; positiva (cuando la skill sube, el código del bando tiende a subir).
- **Stims** (`r = 0.7868`): fuerte; positiva (cuando la skill sube, el código del bando tiende a subir).
- **Recovery** (`r = 0.7776`): fuerte; positiva (cuando la skill sube, el código del bando tiende a subir).
- **Sprint** (`r = 0.7397`): fuerte; positiva (cuando la skill sube, el código del bando tiende a subir).
- **Strength** (`r = 0.7374`): fuerte; positiva (cuando la skill sube, el código del bando tiende a subir).
- **Sensitivity** (`r = 0.7216`): fuerte; positiva (cuando la skill sube, el código del bando tiende a subir).
- **Power** (`r = 0.7007`): fuerte; positiva (cuando la skill sube, el código del bando tiende a subir).

Estas skills son las que, en EX00, suelen mostrar histogramas Jedi/Sith más separados. Son las primeras candidatas si más adelante se construye un modelo o se eligen variables.

### Poco relacionadas (|r| bajo)

- **Midi-chlorien** (`r = 0.0081`): muy débil / casi nula; sin dirección clara.
- **Push** (`r = -0.0194`): muy débil / casi nula; sin dirección clara.
- **Deflection** (`r = -0.0265`): muy débil / casi nula; sin dirección clara.
- **Survival** (`r = -0.0431`): muy débil / casi nula; sin dirección clara.
- **Mass** (`r = 0.1132`): muy débil / casi nula; positiva (cuando la skill sube, el código del bando tiende a subir).

Un valor cercano a 0 no significa que la skill sea “inútil” para todo; solo que **no hay una relación lineal clara** con el bando en este Train.

### Limitaciones

- Solo se usa **Train** (Test no tiene `knight`).
- Pearson mide relación **lineal**; patrones no lineales pueden no verse.
- La codificación 0/1 del target fija el **signo** de r; el orden por |r| es el que importa para “qué tan fuerte” es la asociación.
- Los nombres del ejemplo del PDF pueden diferir del CSV (p. ej. Force vs Pull).

## 5. Cómo reproducir

```bash
cd ex01
python3 Correlation.py
```

---

*Module 3 – EX01 – Correlation · sternero – 42 Málaga*
