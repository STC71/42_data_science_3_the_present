# ✂️ Ejercicio 05 – Split

<p align="center">
  <img src="../imgs/banner_35.jpg" alt="Piscine Data Science – Module 3 – Split" width="100%">
</p>

[← README Module 3](../README.md) · [Guía Python](./python.md)

---

## 🎯 Objetivo

Partir **aleatoriamente** `Train_knight.csv` en dos ficheros:

| Fichero | Rol | % por defecto |
|---------|-----|----------------|
| `Training_knight.csv` | Aprender / ajustar | **~80 %** |
| `Validation_knight.csv` | Estimar calidad sin usar esos puntos al ajustar | **~20 %** |

---

## 📜 Subject

| Campo | Valor |
|-------|--------|
| Directorio | `ex05/` |
| Entrega | **`split.*`** |

```text
$> ./split.* Train_knight.csv
$> ls
./split.* Train_knight.csv Training_knight.csv Validation_knight.csv
```

Debes **poder explicar** qué % va a cada parte y **por qué**.

---

## ▶️ Ejecutar

```bash
cd data_science_3_the_present/ex05
# Copia o enlaza Train (o usa el de data/)
cp ../data/Train_knight.csv .
python3 split.py Train_knight.csv
ls Training_knight.csv Validation_knight.csv
```

---

## 🎤 Defensa (porcentajes)

> “Uso **80 % Training / 20 % Validation**. El training necesita la mayoría de ejemplos; el 20 % sirve para medir generalización. Con ~400 filas es un reparto habitual. Semilla fija (42) para que el split sea reproducible. Estratifico por `knight` para no desequilibrar Jedi/Sith.”

---

## ✅ Checklist

| Ítem | ☐ |
|------|---|
| `split.*` | ☐ |
| Genera `Training_knight.csv` y `Validation_knight.csv` | ☐ |
| Split aleatorio (y reproducible) | ☐ |
| Explicas el % y el motivo | ☐ |

---

*Module 3 – EX05 – sternero – 42 Málaga – Octubre 2026*
