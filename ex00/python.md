# 🐍 Guía Python – EX00 Histogram

[← README EX00](./README.md)

## Datos

- **Train** (398×31): 30 skills + columna `knight` ∈ {Jedi, Sith}.
- **Test** (171×30): solo skills (sin etiqueta).

## Qué hace el script

1. Localiza los CSV (`ex00/` o `../data/`).
2. **Test:** rejilla de histogramas (una barra de frecuencia por skill).
3. **Train:** misma rejilla; en cada panel, histograma de **Jedi** y de **Sith** superpuestos (alpha).

## Analogía

Sin etiquetas = ver el reparto de notas de toda la clase.  
Con `knight` = colorear por equipo y ver quién destaca en cada asignatura.

## Lectura rápida

Si en una skill las curvas Jedi y Sith casi no se solapan, esa feature **discrimina** bien el target (útil más adelante en correlación / modelos).

---

*Module 3 – EX00 – Guía Python · sternero – 42 Málaga – 2026*
