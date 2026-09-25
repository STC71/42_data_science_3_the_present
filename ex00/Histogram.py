#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
EX00 – Histogram.py
Module 3 – The present – Piscine Data Science

================================================================================
SUBJECT (Histogram)
================================================================================
  • Graph with Test_knight.csv (distribución de las skills).
  • Graph with Train_knight.csv mostrando la interacción skills × target
    (columna "knight": Jedi / Sith).

  Turn-in directory : ex00/
  Files to turn in  : Histogram.*

================================================================================
ENFOQUE
================================================================================
  1) Cargar CSV (busca en el directorio del script y en ../data/).
  2) Test: rejilla de histogramas de cada feature (sin etiqueta).
  3) Train: misma rejilla, pero cada feature superpone Jedi vs Sith
     (así se ve qué skills separan mejor los bandos de la Fuerza).

Analogía:
  Como mirar las notas de dos equipos en el mismo examen: primero
  el grupo sin nombres (Test), luego coloreando por equipo (Train).
"""

from __future__ import annotations

import os
import sys
import warnings
from pathlib import Path

warnings.filterwarnings("ignore", message=r"Unable to import Axes3D.*")
warnings.filterwarnings("ignore", message=r"FigureCanvasAgg is non-interactive.*")
warnings.filterwarnings(
    "ignore",
    category=UserWarning,
    module=r"matplotlib(\..*)?",
)

# ---------------------------------------------------------------------------
# Dependencias
# ---------------------------------------------------------------------------


def ensure_dependencies() -> None:
    import importlib.util
    import subprocess

    needed = {
        "pandas": "pandas",
        "matplotlib": "matplotlib",
        "numpy": "numpy",
    }
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

if not os.environ.get("MPLBACKEND") and not os.environ.get("DISPLAY"):
    matplotlib.use("Agg")

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

SCRIPT_DIR = Path(__file__).resolve().parent
MODULE3_DIR = SCRIPT_DIR.parent
TARGET_COL = "knight"


def find_csv(name: str) -> Path:
    """Busca name junto al script, en ../data/ o en el cwd."""
    candidates = [
        SCRIPT_DIR / name,
        MODULE3_DIR / "data" / name,
        Path.cwd() / name,
        Path.cwd() / "data" / name,
    ]
    for path in candidates:
        if path.is_file():
            return path
    raise FileNotFoundError(
        f"No se encuentra {name}. Colócalo en ex00/ o data_science_3/data/"
    )


def feature_columns(df: pd.DataFrame) -> list[str]:
    return [c for c in df.columns if c != TARGET_COL]


def grid_shape(n: int) -> tuple[int, int]:
    """Rejilla legible (~5 columnas)."""
    cols = 5
    rows = int(np.ceil(n / cols))
    return rows, cols


def plot_test_histograms(df: pd.DataFrame, out: Path) -> None:
    """
    Test_knight.csv: un histograma por skill (sin target).
    Sirve para ver rangos y formas de cada feature.
    """
    feats = feature_columns(df)
    rows, cols = grid_shape(len(feats))
    fig, axes = plt.subplots(rows, cols, figsize=(14, 2.4 * rows), layout="constrained")
    axes = np.atleast_1d(axes).ravel()
    for i, col in enumerate(feats):
        ax = axes[i]
        data = df[col].dropna().to_numpy(dtype=float)
        ax.hist(data, bins=20, color="#4C78A8", edgecolor="white", alpha=0.9)
        ax.set_title(col, fontsize=8)
        ax.tick_params(labelsize=6)
    for j in range(len(feats), len(axes)):
        axes[j].set_visible(False)
    fig.suptitle("Test_knight.csv – feature histograms", fontsize=12)
    fig.savefig(out, dpi=140, bbox_inches="tight", pad_inches=0.15, facecolor="white")
    print(f"→ Guardado: {out}")
    plt.show()
    plt.close(fig)


def plot_train_histograms(df: pd.DataFrame, out: Path) -> None:
    """
    Train_knight.csv: por cada skill, histograma de Jedi y de Sith superpuestos.
    Así se ve la interacción feature ↔ target (subject).
    """
    if TARGET_COL not in df.columns:
        raise ValueError(f"Train debe incluir la columna '{TARGET_COL}'")
    feats = feature_columns(df)
    rows, cols = grid_shape(len(feats))
    fig, axes = plt.subplots(rows, cols, figsize=(14, 2.4 * rows), layout="constrained")
    axes = np.atleast_1d(axes).ravel()

    # Colores por bando de la Fuerza
    colors = {"Jedi": "#4C78A8", "Sith": "#E45756"}
    labels_order = sorted(df[TARGET_COL].dropna().unique().astype(str))

    for i, col in enumerate(feats):
        ax = axes[i]
        for label in labels_order:
            subset = df.loc[df[TARGET_COL].astype(str) == label, col].dropna()
            ax.hist(
                subset.to_numpy(dtype=float),
                bins=20,
                alpha=0.55,
                color=colors.get(label, "#999999"),
                label=label if i == 0 else None,
                edgecolor="white",
                linewidth=0.3,
            )
        ax.set_title(col, fontsize=8)
        ax.tick_params(labelsize=6)

    for j in range(len(feats), len(axes)):
        axes[j].set_visible(False)

    # Leyenda global
    handles, labels = axes[0].get_legend_handles_labels()
    if handles:
        fig.legend(handles, labels, loc="upper right", fontsize=9)
    fig.suptitle(
        "Train_knight.csv – features vs knight (Jedi / Sith)",
        fontsize=12,
    )
    fig.savefig(out, dpi=140, bbox_inches="tight", pad_inches=0.15, facecolor="white")
    print(f"→ Guardado: {out}")
    plt.show()
    plt.close(fig)


def main() -> None:
    print("EX00 – Histogram (Module 3 – The present)")
    print()

    test_path = find_csv("Test_knight.csv")
    train_path = find_csv("Train_knight.csv")
    print(f"→ Test : {test_path}")
    print(f"→ Train: {train_path}")

    test_df = pd.read_csv(test_path)
    train_df = pd.read_csv(train_path)
    print(f"  Test  shape={test_df.shape}")
    print(f"  Train shape={train_df.shape}")
    if TARGET_COL in train_df.columns:
        print("  knight:")
        print(train_df[TARGET_COL].value_counts().to_string())
    print()

    plot_test_histograms(test_df, SCRIPT_DIR / "histogram_test.png")
    plot_train_histograms(train_df, SCRIPT_DIR / "histogram_train.png")
    print("Proceso terminado.")


if __name__ == "__main__":
    main()
