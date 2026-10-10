#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
EX03 – standardization.py
Module 3 – The present – Piscine Data Science

================================================================================
SUBJECT (standardization)
================================================================================
  Turn-in directory : ex03/
  Files to turn in  : standardization.*
  Allowed functions : All

  • Standardize and print your data
  • Display one of the graphs from the previous exercise with the standardized data
  • It must work with Train_knight.csv and Test_knight.csv

  Ejemplo del PDF: imprime cabecera + filas originales y, debajo, las mismas
  columnas ya estandarizadas (valores centrados ~0 y escala ~1).

================================================================================
QUÉ ES ESTANDARIZAR (z-score)
================================================================================
  Por cada columna numérica:
      z = (x - media) / desviación_típica

  Tras eso, cada skill tiene media ≈ 0 y desviación ≈ 1.
  Así se pueden comparar skills que antes tenían rangos muy distintos
  (p. ej. Power en miles vs Agility en 0.0x).

  • La columna knight (texto) no se estandariza.
  • Train y Test se estandarizan cada uno con SU media y SU std
    (el subject pide “print your data” por fichero).
"""

from __future__ import annotations

import os
import sys
import warnings
from pathlib import Path

warnings.filterwarnings("ignore", message=r"Unable to import Axes3D.*")
warnings.filterwarnings("ignore", category=UserWarning, module=r"matplotlib(\..*)?")


def ensure_dependencies() -> None:
    import importlib.util
    import subprocess

    needed = {"pandas": "pandas", "numpy": "numpy", "matplotlib": "matplotlib"}
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

import matplotlib

if os.environ.get("DISPLAY", "") == "":
    matplotlib.use("Agg")

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

SCRIPT_DIR = Path(__file__).resolve().parent
MODULE3_DIR = SCRIPT_DIR.parent
TARGET_COL = "knight"

# Mismo par “separación” que EX02 (uno de los gráficos del ejercicio anterior)
PAIR_SEPARATE = ("Awareness", "Strength")
PREVIEW_ROWS = 5


def find_csv(name: str) -> Path:
    env_map = {
        "Train_knight.csv": os.environ.get("KNIGHT_TRAIN_CSV", ""),
        "Test_knight.csv": os.environ.get("KNIGHT_TEST_CSV", ""),
    }
    candidates: list[Path] = [MODULE3_DIR / "data" / name]
    env_path = env_map.get(name, "")
    if env_path:
        candidates.append(Path(env_path))
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
        f"No se encuentra {name}. Debe estar en {MODULE3_DIR / 'data' / name}."
    )


def feature_columns(df: pd.DataFrame) -> list[str]:
    return [c for c in df.columns if c != TARGET_COL]


def standardize_features(df: pd.DataFrame) -> pd.DataFrame:
    """
    Z-score por columna numérica. knight se copia tal cual si existe.
    std=0 → z=0 para evitar división por cero.
    """
    out = df.copy()
    for col in feature_columns(df):
        s = pd.to_numeric(out[col], errors="coerce")
        mean = float(s.mean())
        std = float(s.std(ddof=0))  # población; estable con N del CSV
        if std == 0 or np.isnan(std):
            out[col] = 0.0
        else:
            out[col] = (s - mean) / std
    return out


def print_block(title: str, df: pd.DataFrame, n: int = PREVIEW_ROWS) -> None:
    """Imprime cabeceras + primeras filas (estilo subject)."""
    cols = list(df.columns)
    # Línea de nombres (todas las columnas; el PDF resume con ...)
    print(" ".join(str(c) for c in cols))
    preview = df.head(n)
    for _, row in preview.iterrows():
        parts = []
        for c in cols:
            val = row[c]
            if c == TARGET_COL:
                parts.append(str(val))
            else:
                try:
                    parts.append(f"{float(val):.2f}")
                except (TypeError, ValueError):
                    parts.append(str(val))
        print(" ".join(parts))
    if len(df) > n:
        print("...")


def plot_standardized_train(df_std: pd.DataFrame, out: Path) -> None:
    """Uno de los gráficos de EX02 (par que separa) con datos ya z-score."""
    x_col, y_col = PAIR_SEPARATE
    if TARGET_COL not in df_std.columns:
        raise ValueError("Hace falta knight en Train para colorear.")

    fig, ax = plt.subplots(figsize=(7, 5), layout="constrained")
    colors = {"Jedi": "#4C78A8", "Sith": "#E45756"}
    for label in sorted(df_std[TARGET_COL].dropna().astype(str).unique()):
        sub = df_std.loc[df_std[TARGET_COL].astype(str) == label]
        ax.scatter(
            pd.to_numeric(sub[x_col], errors="coerce"),
            pd.to_numeric(sub[y_col], errors="coerce"),
            s=22,
            alpha=0.7,
            c=colors.get(label, "#999999"),
            label=label,
            edgecolors="none",
        )
    ax.set_xlabel(f"{x_col} (standardized)")
    ax.set_ylabel(f"{y_col} (standardized)")
    ax.set_title("EX03 – Train scatter after standardization (EX02 separate pair)")
    ax.legend(loc="best")
    ax.grid(True, alpha=0.3)
    ax.axhline(0, color="gray", lw=0.8, alpha=0.5)
    ax.axvline(0, color="gray", lw=0.8, alpha=0.5)
    fig.savefig(out, dpi=140, bbox_inches="tight", pad_inches=0.15, facecolor="white")
    plt.show()
    plt.close(fig)


def process_file(label: str, path: Path) -> pd.DataFrame:
    print("=" * 72)
    print(f"{label}: {path}")
    df = pd.read_csv(path)
    print(f"shape={df.shape}")
    print()
    print(f"--- {label} (original, primeras {PREVIEW_ROWS} filas) ---")
    print_block(label, df)
    print()
    df_std = standardize_features(df)
    print(f"--- {label} (standardized z-score, primeras {PREVIEW_ROWS} filas) ---")
    # No imprimir knight como número; si existe, dejarlo
    print_block(label, df_std)
    print()
    # Resumen rápido
    feats = feature_columns(df_std)
    means = df_std[feats].mean()
    stds = df_std[feats].std(ddof=0)
    print(
        f"Comprobación: media de skills ≈ 0 "
        f"(promedio |media|={means.abs().mean():.4f}); "
        f"std ≈ 1 (promedio std={stds.mean():.4f})"
    )
    print()
    return df_std


def main() -> None:
    print("EX03 – standardization (Module 3 – The present)")
    print()
    print("Z-score: z = (x - mean) / std  por cada skill numérica.")
    print(f"Gráfico EX02 reutilizado: {PAIR_SEPARATE[0]} × {PAIR_SEPARATE[1]}")
    print()

    train_path = find_csv("Train_knight.csv")
    test_path = find_csv("Test_knight.csv")

    train_std = process_file("Train", train_path)
    test_std = process_file("Test", test_path)

    out = SCRIPT_DIR / "standardization_scatter.png"
    print("=" * 72)
    print("Gráfico (uno de EX02) con datos estandarizados – Train")
    plot_standardized_train(train_std, out)
    print(f"→ Guardado: {out}")
    print()
    print(
        "Nota: Test también se estandariza e imprime arriba; "
        "el scatter coloreado requiere knight (solo Train)."
    )
    print("Proceso terminado.")


if __name__ == "__main__":
    main()
