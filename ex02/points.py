#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
EX02 – points.py
Module 3 – The present – Piscine Data Science

================================================================================
SUBJECT (it's raining cats no points!)
================================================================================
  Turn-in directory : ex02/
  Files to turn in  : points.*
  Allowed functions : All

  • Display 4 graphs (Train_knight.csv and Test_knight.csv).
  • For each file: one plot that visually SEPARATES the clusters,
    and one that MIXES them.

  En el PDF: scatter 2D. Train coloreado Jedi/Sith; Test un solo color
  (no hay etiqueta).

================================================================================
ENFOQUE
================================================================================
  Pares de skills (ejes X/Y):
    • Separación: skills con alta correlación con knight (p. ej. Awareness
      × Strength), como en el ejemplo del subject.
    • Mezcla: skills casi independientes del bando (p. ej. Push × Mass).

  Fuente de datos: carpeta compartida data/ del módulo (no hace falta
  copiar CSV a ex02/).
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

    needed = {"pandas": "pandas", "matplotlib": "matplotlib", "numpy": "numpy"}
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

# Pares alineados con el espíritu del PDF (separar vs mezclar)
PAIR_SEPARATE = ("Awareness", "Strength")  # clusters visibles en Train
PAIR_MIX = ("Push", "Mass")  # nubes solapadas


def find_csv(name: str) -> Path:
    """Fuente preferida: data/ del módulo."""
    env_map = {
        "Train_knight.csv": os.environ.get("KNIGHT_TRAIN_CSV", ""),
        "Test_knight.csv": os.environ.get("KNIGHT_TEST_CSV", ""),
    }
    candidates: list[Path] = [
        MODULE3_DIR / "data" / name,
    ]
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
        f"No se encuentra {name}. Debe estar en "
        f"{MODULE3_DIR / 'data' / name}."
    )


def scatter_train(
    ax: plt.Axes,
    df: pd.DataFrame,
    x_col: str,
    y_col: str,
    title: str,
) -> None:
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
    ax.set_xlabel(x_col, fontsize=9)
    ax.set_ylabel(y_col, fontsize=9)
    ax.set_title(title, fontsize=10)
    ax.legend(fontsize=8, loc="best", framealpha=0.9)
    ax.grid(True, alpha=0.25)


def scatter_test(
    ax: plt.Axes,
    df: pd.DataFrame,
    x_col: str,
    y_col: str,
    title: str,
) -> None:
    ax.scatter(
        pd.to_numeric(df[x_col], errors="coerce"),
        pd.to_numeric(df[y_col], errors="coerce"),
        s=18,
        alpha=0.65,
        c="#54A24B",
        label="knight",
        edgecolors="none",
    )
    ax.set_xlabel(x_col, fontsize=9)
    ax.set_ylabel(y_col, fontsize=9)
    ax.set_title(title, fontsize=10)
    ax.legend(fontsize=8, loc="best", framealpha=0.9)
    ax.grid(True, alpha=0.25)


def main() -> None:
    print("EX02 – points (Module 3 – The present)")
    print()

    train_path = find_csv("Train_knight.csv")
    test_path = find_csv("Test_knight.csv")
    print(f"→ Train: {train_path}")
    print(f"→ Test : {test_path}")

    train = pd.read_csv(train_path)
    test = pd.read_csv(test_path)
    print(f"  Train shape={train.shape}")
    print(f"  Test  shape={test.shape}")

    for col in (*PAIR_SEPARATE, *PAIR_MIX):
        if col not in train.columns or col not in test.columns:
            raise KeyError(f"Falta la columna {col!r} en Train o Test")

    if TARGET_COL not in train.columns:
        raise ValueError("Train debe incluir la columna 'knight'")

    print()
    print(f"  Par SEPARACIÓN: {PAIR_SEPARATE[0]} × {PAIR_SEPARATE[1]}")
    print(f"  Par MEZCLA    : {PAIR_MIX[0]} × {PAIR_MIX[1]}")
    print()

    fig, axes = plt.subplots(2, 2, figsize=(10, 8), layout="constrained")

    # Fila 0: Train (colores por bando)
    scatter_train(
        axes[0, 0],
        train,
        *PAIR_SEPARATE,
        title="Train – clusters separated",
    )
    scatter_train(
        axes[0, 1],
        train,
        *PAIR_MIX,
        title="Train – clusters mixed",
    )

    # Fila 1: Test (un color; mismos ejes)
    scatter_test(
        axes[1, 0],
        test,
        *PAIR_SEPARATE,
        title="Test – same axes (no labels)",
    )
    scatter_test(
        axes[1, 1],
        test,
        *PAIR_MIX,
        title="Test – same axes (no labels)",
    )

    fig.suptitle(
        "EX02 – points: separate vs mixed feature pairs",
        fontsize=12,
    )
    out = SCRIPT_DIR / "points.png"
    fig.savefig(out, dpi=140, bbox_inches="tight", pad_inches=0.15, facecolor="white")
    print(f"→ Guardado: {out}")
    plt.show()
    plt.close(fig)
    print("Proceso terminado.")


if __name__ == "__main__":
    main()
