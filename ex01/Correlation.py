#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
EX01 – Correlation.py
Module 3 – The present – Piscine Data Science

SUBJECT
  Correlation factor between target "knight" and each feature.
  Turn-in: Correlation.*  ·  Allowed: All

Además de la tabla (subject), imprime explicación en consola y escribe
correlation_report.md para lectura humana (no sustituye la entrega).
"""

from __future__ import annotations

import os
import sys
import warnings
from datetime import datetime, timezone
from pathlib import Path

warnings.filterwarnings("ignore", message=r"Unable to import Axes3D.*")
warnings.filterwarnings("ignore", category=UserWarning, module=r"matplotlib(\..*)?")


def ensure_dependencies() -> None:
    import importlib.util
    import subprocess

    needed = {"pandas": "pandas", "numpy": "numpy"}
    missing = [
        pkg
        for mod, pkg in needed.items()
        if importlib.util.find_spec(mod) is None
    ]
    if missing:
        print("Instalando:", ", ".join(missing), "...")
        subprocess.check_call(
            [sys.executable, "-m", "pip", "install", "--user", *missing]
        )


ensure_dependencies()

import numpy as np
import pandas as pd

SCRIPT_DIR = Path(__file__).resolve().parent
MODULE3_DIR = SCRIPT_DIR.parent
TARGET_COL = "knight"
REPORT_NAME = "correlation_report.md"


def find_csv(name: str) -> Path:
    """
    Fuente preferida: carpeta compartida del módulo ``data/``
    (la misma que rellena EX00 / el menú de sincronización).

    No hace falta copiar el CSV a ex01/; se lee desde data/ si existe.
    Fallbacks: env del menú, raíz del módulo, cwd.
    """
    env_map = {
        "Train_knight.csv": os.environ.get("KNIGHT_TRAIN_CSV", ""),
        "Test_knight.csv": os.environ.get("KNIGHT_TEST_CSV", ""),
    }
    candidates: list[Path] = []
    # 1) Canónico del módulo
    candidates.append(MODULE3_DIR / "data" / name)
    # 2) Ruta exportada por start.sh (si apunta a data/, coincide)
    env_path = env_map.get(name, "")
    if env_path:
        candidates.append(Path(env_path))
    # 3) Fallbacks
    candidates.extend(
        [
            MODULE3_DIR / name,
            SCRIPT_DIR / name,
            Path.cwd() / "data" / name,
            Path.cwd() / name,
        ]
    )
    seen: set[str] = set()
    for path in candidates:
        try:
            key = str(path.resolve()) if path.exists() else str(path)
        except OSError:
            key = str(path)
        if key in seen:
            continue
        seen.add(key)
        try:
            if path.is_file():
                return path.resolve()
        except OSError:
            continue
    raise FileNotFoundError(
        f"No se encuentra {name}. Debe estar en "
        f"{MODULE3_DIR / 'data' / name} "
        f"(sincróniza con el start.sh de ex00/ex01 o copia el CSV a data/)."
    )


def choose_encoding(df: pd.DataFrame) -> tuple[pd.Series, dict[str, float]]:
    """
    Codifica knight → 0/1 eligiendo el mapa que alinea el signo con el
    ejemplo del subject (Empowered positivo alto cuando es posible).
    Devuelve (serie numérica, mapa etiqueta→código).
    """
    labels = sorted(df[TARGET_COL].dropna().astype(str).unique())
    if len(labels) != 2:
        codes, uniques = pd.factorize(df[TARGET_COL].astype(str))
        mapping = {str(u): float(i) for i, u in enumerate(uniques)}
        return pd.Series(codes, index=df.index, dtype=float), mapping

    a, b = labels[0], labels[1]
    feats = [c for c in df.columns if c != TARGET_COL]

    def score(mapping: dict) -> tuple[float, float]:
        y = df[TARGET_COL].astype(str).map(mapping).astype(float)
        corrs = []
        for c in feats:
            x = pd.to_numeric(df[c], errors="coerce")
            pair = pd.concat([x, y], axis=1).dropna()
            if len(pair) < 3:
                continue
            corrs.append(float(pair.iloc[:, 0].corr(pair.iloc[:, 1])))
        emp = 0.0
        if "Empowered" in df.columns:
            x = pd.to_numeric(df["Empowered"], errors="coerce")
            pair = pd.concat([x, y], axis=1).dropna()
            if len(pair) >= 3:
                emp = float(pair.iloc[:, 0].corr(pair.iloc[:, 1]))
        mean_abs = float(np.mean(np.abs(corrs))) if corrs else 0.0
        return (emp, mean_abs)

    m1 = {a: 0.0, b: 1.0}
    m2 = {a: 1.0, b: 0.0}
    best = m1 if score(m1) >= score(m2) else m2
    return df[TARGET_COL].astype(str).map(best).astype(float), best


def correlation_with_target(
    df: pd.DataFrame,
) -> tuple[pd.Series, dict[str, float]]:
    if TARGET_COL not in df.columns:
        raise ValueError(
            f"Hace falta la columna '{TARGET_COL}' (usa Train_knight.csv)."
        )
    y, mapping = choose_encoding(df)
    work = df.drop(columns=[TARGET_COL]).apply(pd.to_numeric, errors="coerce")
    work[TARGET_COL] = y
    corr = work.corr(method="pearson")[TARGET_COL]
    corr = corr.sort_values(ascending=False)
    return corr, mapping


def interpret_r(r: float) -> str:
    ar = abs(r)
    if ar >= 0.7:
        strength = "fuerte"
    elif ar >= 0.4:
        strength = "moderada"
    elif ar >= 0.2:
        strength = "débil"
    else:
        strength = "muy débil / casi nula"
    if r > 0.05:
        direction = "positiva (cuando la skill sube, el código del bando tiende a subir)"
    elif r < -0.05:
        direction = "negativa (cuando la skill sube, el código del bando tiende a bajar)"
    else:
        direction = "sin dirección clara"
    return f"{strength}; {direction}"


def print_correlation_table(corr: pd.Series) -> None:
    name_width = max(len(str(i)) for i in corr.index)
    name_width = max(name_width, len(TARGET_COL))
    for name, value in corr.items():
        print(f"{str(name):<{name_width}}  {value: .6f}")


def console_explanation(
    corr: pd.Series,
    mapping: dict[str, float],
    n_rows: int,
) -> None:
    print()
    print("=" * 60)
    print("QUÉ SIGNIFICA ESTA TABLA")
    print("=" * 60)
    print(
        "Cada número es la correlación de Pearson entre esa columna y el"
        " target 'knight' (Jedi/Sith convertidos a 0/1)."
    )
    print(f"Filas usadas (Train): {n_rows}")
    print("Codificación del target:")
    for lab, code in sorted(mapping.items(), key=lambda x: x[1]):
        print(f"  {lab!r:8} → {code:g}")
    print()
    print("Escala orientativa de |r|:")
    print("  |r| ≥ 0.7  → relación fuerte")
    print("  |r| ≥ 0.4  → moderada")
    print("  |r| ≥ 0.2  → débil")
    print("  |r| <  0.2  → muy débil")
    print()

    # Sin la fila knight consigo misma
    feats = corr.drop(labels=[TARGET_COL], errors="ignore")
    top = feats.head(5)
    bottom = feats.tail(3)

    print("CONCLUSIONES (sobre este Train)")
    print("-" * 60)
    print("Skills más ligadas al bando (arriba de la lista):")
    for name, value in top.items():
        print(f"  • {name}: r = {value:.4f} → {interpret_r(float(value))}")
    print()
    print("Skills poco informativas en sentido lineal (cerca de 0):")
    for name, value in bottom.items():
        print(f"  • {name}: r = {value:.4f} → {interpret_r(float(value))}")
    print()
    print(
        "Interpretación práctica: las skills con |r| alto son candidatas"
        " a separar Jedi y Sith (como intuías en los histogramas de EX00)."
    )
    print(
        "Test_knight.csv no se usa aquí: no tiene columna knight, no hay"
        " target con el que correlacionar."
    )
    print(
        "Nota: el ejemplo del PDF puede nombrar columnas (p. ej. Force) que"
        " en tu CSV se llaman distinto (p. ej. Pull); se correlacionan las"
        " columnas reales del fichero."
    )
    print("=" * 60)


def write_report(
    corr: pd.Series,
    mapping: dict[str, float],
    train_path: Path,
    n_rows: int,
    n_cols: int,
    counts: pd.Series,
) -> Path:
    feats = corr.drop(labels=[TARGET_COL], errors="ignore")
    top = feats.head(8)
    weak = feats.reindex(feats.abs().sort_values().index).head(5)

    lines: list[str] = []
    lines.append("# Informe de correlación – EX01")
    lines.append("")
    lines.append(f"*Generado por `Correlation.py` · {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')}*")
    lines.append("")
    lines.append("## 1. Datos")
    lines.append("")
    lines.append(f"| Campo | Valor |")
    lines.append(f"|-------|-------|")
    lines.append(f"| Fichero | `{train_path}` |")
    lines.append(f"| Forma | {n_rows} filas × {n_cols} columnas |")
    lines.append(f"| Target | `{TARGET_COL}` (Jedi / Sith) |")
    for lab, n in counts.items():
        lines.append(f"| Conteo `{lab}` | {int(n)} |")
    lines.append("")
    lines.append("## 2. Qué se ha calculado")
    lines.append("")
    lines.append(
        "La **correlación de Pearson** entre cada **feature** (skill numérica) "
        "y el **target** `knight`. El target se codifica en números porque "
        "Pearson solo trabaja con valores numéricos:"
    )
    lines.append("")
    for lab, code in sorted(mapping.items(), key=lambda x: x[1]):
        lines.append(f"- `{lab}` → **{code:g}**")
    lines.append("")
    lines.append(
        "El coeficiente **r** está entre −1 y +1: cerca de ±1 hay relación "
        "lineal fuerte; cerca de 0, poca relación lineal."
    )
    lines.append("")
    lines.append("## 3. Tabla completa (orden del subject: de mayor a menor r)")
    lines.append("")
    lines.append("| Columna | r (Pearson) | Lectura breve |")
    lines.append("|---------|------------:|---------------|")
    for name, value in corr.items():
        v = float(value)
        if str(name) == TARGET_COL:
            note = "target consigo mismo (siempre 1)"
        else:
            note = interpret_r(v)
        lines.append(f"| {name} | {v:.6f} | {note} |")
    lines.append("")
    lines.append("## 4. Conclusiones")
    lines.append("")
    lines.append("### Más correlacionadas con el bando")
    lines.append("")
    for name, value in top.items():
        lines.append(
            f"- **{name}** (`r = {float(value):.4f}`): {interpret_r(float(value))}."
        )
    lines.append("")
    lines.append(
        "Estas skills son las que, en EX00, suelen mostrar histogramas Jedi/Sith "
        "más separados. Son las primeras candidatas si más adelante se construye "
        "un modelo o se eligen variables."
    )
    lines.append("")
    lines.append("### Poco relacionadas (|r| bajo)")
    lines.append("")
    for name, value in weak.items():
        lines.append(
            f"- **{name}** (`r = {float(value):.4f}`): {interpret_r(float(value))}."
        )
    lines.append("")
    lines.append(
        "Un valor cercano a 0 no significa que la skill sea “inútil” para todo; "
        "solo que **no hay una relación lineal clara** con el bando en este Train."
    )
    lines.append("")
    lines.append("### Limitaciones")
    lines.append("")
    lines.append(
        "- Solo se usa **Train** (Test no tiene `knight`).\n"
        "- Pearson mide relación **lineal**; patrones no lineales pueden no verse.\n"
        "- La codificación 0/1 del target fija el **signo** de r; el orden por "
        "|r| es el que importa para “qué tan fuerte” es la asociación.\n"
        "- Los nombres del ejemplo del PDF pueden diferir del CSV (p. ej. Force vs Pull)."
    )
    lines.append("")
    lines.append("## 5. Cómo reproducir")
    lines.append("")
    lines.append("```bash")
    lines.append("cd ex01")
    lines.append("python3 Correlation.py")
    lines.append("```")
    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append("*Module 3 – EX01 – Correlation · sternero – 42 Málaga*")
    lines.append("")

    out = SCRIPT_DIR / REPORT_NAME
    out.write_text("\n".join(lines), encoding="utf-8")
    return out


def main() -> None:
    print("EX01 – Correlation (Module 3 – The present)")
    print()

    train_path = find_csv("Train_knight.csv")
    print(f"→ Train: {train_path}")
    df = pd.read_csv(train_path)
    print(f"  shape={df.shape}")
    counts = pd.Series(dtype=int)
    if TARGET_COL in df.columns:
        counts = df[TARGET_COL].value_counts()
        print("  knight:")
        print(counts.to_string())
    print()

    corr, mapping = correlation_with_target(df)

    print("--- Tabla de correlación (subject) ---")
    print_correlation_table(corr)

    console_explanation(corr, mapping, n_rows=len(df))

    report_path = write_report(
        corr,
        mapping,
        train_path=train_path,
        n_rows=len(df),
        n_cols=df.shape[1],
        counts=counts,
    )
    print()
    print(f"→ Informe escrito: {report_path}")
    print("  (markdown con tabla, explicación y conclusiones)")
    print()
    print("Proceso terminado.")


if __name__ == "__main__":
    main()
