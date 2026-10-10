#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
EX05 – split.py
Module 3 – The present – Piscine Data Science

================================================================================
SUBJECT (Split)
================================================================================
  Turn-in directory : ex05/
  Files to turn in  : split.*
  Allowed functions : All

  • Randomly split Train_knight.csv into:
        Training_knight.csv
        Validation_knight.csv
  • Be able to explain how many % you keep in each file and why

  Uso (como el subject):
      ./split.py Train_knight.csv
      # → Training_knight.csv y Validation_knight.csv en el directorio actual

================================================================================
PORCENTAJES (defensa)
================================================================================
  Por defecto: 80 % Training / 20 % Validation.

  Por qué:
  - El Training debe ser lo bastante grande para aprender patrones (Jedi/Sith).
  - La Validation se reserva para estimar el error *sin* usar esos puntos al
    ajustar (o al elegir hiperparámetros más adelante, p. ej. módulo 4).
  - 80/20 es un convenio habitual con cientos de filas (~398 en este Train).
  - Opcionalmente se estratifica por ``knight`` para conservar la proporción
    Jedi/Sith en ambos trozos.

  Semilla fija (42) → el mismo split al repetir (reproducible en defensa).
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

# Proporciones por defecto (explicables en defensa)
TRAIN_FRAC = 0.80
VAL_FRAC = 0.20
RANDOM_SEED = 42
TARGET_COL = "knight"


def ensure_dependencies() -> None:
    import importlib.util
    import subprocess

    if importlib.util.find_spec("pandas") is None:
        print("Instalando pandas...")
        subprocess.check_call(
            [sys.executable, "-m", "pip", "install", "--user", "pandas"]
        )


ensure_dependencies()

import pandas as pd


def resolve_input(path_str: str) -> Path:
    """Busca el CSV: ruta dada, cwd, o data/ del módulo."""
    p = Path(path_str)
    if p.is_file():
        return p.resolve()
    candidates = [
        Path.cwd() / path_str,
        Path.cwd() / "Train_knight.csv",
        Path(__file__).resolve().parent / path_str,
        Path(__file__).resolve().parent.parent / "data" / "Train_knight.csv",
        Path(__file__).resolve().parent.parent / "data" / path_str,
    ]
    for c in candidates:
        if c.is_file():
            return c.resolve()
    raise FileNotFoundError(
        f"No se encuentra {path_str}. "
        "Pasa la ruta: python3 split.py /ruta/Train_knight.csv"
    )


def split_dataframe(
    df: pd.DataFrame,
    train_frac: float = TRAIN_FRAC,
    seed: int = RANDOM_SEED,
    stratify: bool = True,
) -> tuple[pd.DataFrame, pd.DataFrame]:
    """
    Parte aleatoria. Si existe ``knight`` y stratify=True, mantiene
    proporciones de clase aproximadas en Training y Validation.
    """
    if not 0.0 < train_frac < 1.0:
        raise ValueError("train_frac debe estar entre 0 y 1 (excluido).")

    n = len(df)
    if n < 2:
        raise ValueError("Hacen falta al menos 2 filas para partir.")

    if stratify and TARGET_COL in df.columns:
        parts_train = []
        parts_val = []
        for _, group in df.groupby(TARGET_COL, sort=False):
            g = group.sample(frac=1.0, random_state=seed)
            n_g = len(g)
            n_tr = max(1, int(round(n_g * train_frac)))
            if n_tr >= n_g:
                n_tr = n_g - 1
            parts_train.append(g.iloc[:n_tr])
            parts_val.append(g.iloc[n_tr:])
        train_df = pd.concat(parts_train, axis=0).sample(frac=1.0, random_state=seed)
        val_df = pd.concat(parts_val, axis=0).sample(frac=1.0, random_state=seed)
    else:
        shuffled = df.sample(frac=1.0, random_state=seed)
        n_tr = max(1, int(round(n * train_frac)))
        if n_tr >= n:
            n_tr = n - 1
        train_df = shuffled.iloc[:n_tr]
        val_df = shuffled.iloc[n_tr:]

    return train_df.reset_index(drop=True), val_df.reset_index(drop=True)


def print_summary(
    src: Path,
    train_df: pd.DataFrame,
    val_df: pd.DataFrame,
    train_frac: float,
) -> None:
    n = len(train_df) + len(val_df)
    pct_tr = 100.0 * len(train_df) / n
    pct_va = 100.0 * len(val_df) / n
    print("EX05 – Split (Module 3 – The present)")
    print()
    print(f"→ Entrada : {src}")
    print(f"  Filas   : {n}")
    print()
    print(f"  Objetivo: ~{100 * train_frac:.0f} % Training / "
          f"~{100 * (1 - train_frac):.0f} % Validation")
    print(f"  Semilla : {RANDOM_SEED} (reproducible)")
    print()
    print(f"  Training_knight.csv   : {len(train_df)} filas  ({pct_tr:.1f} %)")
    print(f"  Validation_knight.csv : {len(val_df)} filas  ({pct_va:.1f} %)")
    if TARGET_COL in train_df.columns:
        print()
        print("  Distribución knight (estratificada):")
        print("    Training :")
        print(train_df[TARGET_COL].value_counts().to_string().replace("\n", "\n      "))
        print("    Validation :")
        print(val_df[TARGET_COL].value_counts().to_string().replace("\n", "\n      "))
    print()
    print("Por qué este %:")
    print("  • Training grande → el modelo (o el análisis) ve la mayoría de ejemplos.")
    print("  • Validation 20 % → mide generalización sin tocar esos puntos al ajustar.")
    print("  • 80/20 es un convenio habitual con cientos de filas.")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Parte Train_knight.csv en Training y Validation (EX05)."
    )
    parser.add_argument(
        "csv",
        nargs="?",
        default="Train_knight.csv",
        help="Ruta a Train_knight.csv (default: Train_knight.csv en cwd)",
    )
    parser.add_argument(
        "--train-frac",
        type=float,
        default=TRAIN_FRAC,
        help=f"Fracción para Training (default: {TRAIN_FRAC})",
    )
    parser.add_argument(
        "--no-stratify",
        action="store_true",
        help="No estratificar por knight (split puramente aleatorio)",
    )
    parser.add_argument(
        "-o",
        "--out-dir",
        default=".",
        help="Directorio de salida (default: directorio actual)",
    )
    args = parser.parse_args(argv)

    src = resolve_input(args.csv)
    df = pd.read_csv(src)

    train_df, val_df = split_dataframe(
        df,
        train_frac=args.train_frac,
        seed=RANDOM_SEED,
        stratify=not args.no_stratify,
    )

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    path_tr = out_dir / "Training_knight.csv"
    path_va = out_dir / "Validation_knight.csv"
    train_df.to_csv(path_tr, index=False)
    val_df.to_csv(path_va, index=False)

    print_summary(src, train_df, val_df, args.train_frac)
    print(f"→ Escrito: {path_tr.resolve()}")
    print(f"→ Escrito: {path_va.resolve()}")
    print()
    print("Proceso terminado.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
