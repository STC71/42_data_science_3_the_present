#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
EX04 – Normalization.py
Module 3 – The present – Piscine Data Science

================================================================================
SUBJECT (Normalization)
================================================================================
  Turn-in directory : ex04/
  Files to turn in  : Normalization.*
  Allowed functions : All

  • Normalize and print your data
  • Display the other graphs from exercise 02 with the normalized data
  • It must work with Train_knight.csv and Test_knight.csv

  Ejemplo del PDF: valores originales y, debajo, valores en ~[0, 1].

================================================================================
NORMALIZACIÓN (min-max) vs ESTANDARIZACIÓN (EX03)
================================================================================
  Min-max:
      x' = (x - min) / (max - min)     → suele quedar en [0, 1]

  Z-score (EX03):
      z  = (x - mean) / std            → media ≈ 0, std ≈ 1

  EX03 mostró *uno* de los gráficos de EX02 (par que separa) con z-score.
  EX04 muestra los *otros* (par que mezcla + mismos ejes en Test) con min-max.

  knight (texto) no se normaliza.
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
PREVIEW_ROWS = 5

# EX02: SEPARATE se usó en EX03 → aquí los “otros”: MIX (+ Test)
PAIR_MIX = ("Push", "Mass")
PAIR_SEPARATE = ("Awareness", "Strength")  # Test (no se dibujó en EX03)


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


def normalize_features(df: pd.DataFrame) -> pd.DataFrame:
    """Min-max por columna numérica → aproximadamente [0, 1]."""
    out = df.copy()
    for col in feature_columns(df):
        s = pd.to_numeric(out[col], errors="coerce")
        lo = float(s.min())
        hi = float(s.max())
        span = hi - lo
        if span == 0 or np.isnan(span):
            out[col] = 0.0
        else:
            out[col] = (s - lo) / span
    return out


def print_block(df: pd.DataFrame, n: int = PREVIEW_ROWS) -> None:
    cols = list(df.columns)
    print(" ".join(str(c) for c in cols))
    for _, row in df.head(n).iterrows():
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


def scatter_train(ax, df: pd.DataFrame, x_col: str, y_col: str, title: str) -> None:
    colors = {"Jedi": "#4C78A8", "Sith": "#E45756"}
    for label in sorted(df[TARGET_COL].dropna().astype(str).unique()):
        sub = df.loc[df[TARGET_COL].astype(str) == label]
        ax.scatter(
            pd.to_numeric(sub[x_col], errors="coerce"),
            pd.to_numeric(sub[y_col], errors="coerce"),
            s=18,
            alpha=0.65,
            c=colors.get(label, "#999999"),
            label=label,
            edgecolors="none",
        )
    ax.set_xlabel(f"{x_col} (normalized)")
    ax.set_ylabel(f"{y_col} (normalized)")
    ax.set_title(title, fontsize=10)
    ax.legend(fontsize=8, loc="best")
    ax.grid(True, alpha=0.25)


def scatter_test(ax, df: pd.DataFrame, x_col: str, y_col: str, title: str) -> None:
    ax.scatter(
        pd.to_numeric(df[x_col], errors="coerce"),
        pd.to_numeric(df[y_col], errors="coerce"),
        s=18,
        alpha=0.65,
        c="#54A24B",
        label="knight",
        edgecolors="none",
    )
    ax.set_xlabel(f"{x_col} (normalized)")
    ax.set_ylabel(f"{y_col} (normalized)")
    ax.set_title(title, fontsize=10)
    ax.legend(fontsize=8, loc="best")
    ax.grid(True, alpha=0.25)


def plot_other_ex02_graphs(train_n: pd.DataFrame, test_n: pd.DataFrame, out: Path) -> None:
    """
    ‘Other graphs’ respecto a EX03:
      EX03 → un scatter Train del par que SEPARABA.
      EX04 → par que MEZCLA (Train + Test) y par SEPARACIÓN en Test.
    """
    fig, axes = plt.subplots(2, 2, figsize=(10, 8), layout="constrained")

    scatter_train(
        axes[0, 0],
        train_n,
        *PAIR_MIX,
        title="Train – MIX pair (normalized)",
    )
    scatter_test(
        axes[0, 1],
        test_n,
        *PAIR_MIX,
        title="Test – MIX pair (normalized)",
    )
    scatter_test(
        axes[1, 0],
        test_n,
        *PAIR_SEPARATE,
        title="Test – SEPARATE pair (normalized)",
    )
    # Cuarto panel: Train mix ya está; reforzamos con Train en ejes mix
    # (alternativa: vacío). Repetimos Train separate solo como referencia
    # de escala [0,1] — el subject pide los *otros* que no eran el de EX03.
    scatter_train(
        axes[1, 1],
        train_n,
        *PAIR_MIX,
        title="Train – MIX (normalized, detail)",
    )

    fig.suptitle(
        "EX04 – Normalization: other EX02 graphs (min-max [0,1])",
        fontsize=12,
    )
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
    print_block(df)
    print()
    df_n = normalize_features(df)
    print(f"--- {label} (normalized min-max, primeras {PREVIEW_ROWS} filas) ---")
    print_block(df_n)
    print()
    feats = feature_columns(df_n)
    print(
        f"Comprobación: valores en skills ≈ [0, 1] "
        f"(min global={df_n[feats].min().min():.4f}, "
        f"max global={df_n[feats].max().max():.4f})"
    )
    print()
    return df_n


def main() -> None:
    print("EX04 – Normalization (Module 3 – The present)")
    print()
    print("Min-max: x' = (x - min) / (max - min)  por cada skill.")
    print(f"Gráficos EX02 ‘otros’: MIX {PAIR_MIX[0]}×{PAIR_MIX[1]} (+ Test)")
    print()

    train_path = find_csv("Train_knight.csv")
    test_path = find_csv("Test_knight.csv")

    train_n = process_file("Train", train_path)
    test_n = process_file("Test", test_path)

    out = SCRIPT_DIR / "normalization_scatter.png"
    print("=" * 72)
    print("Gráficos (otros de EX02) con datos normalizados")
    plot_other_ex02_graphs(train_n, test_n, out)
    print(f"→ Guardado: {out}")
    print("Proceso terminado.")


if __name__ == "__main__":
    main()
