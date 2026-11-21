"""Shared matplotlib style for thesis data figures."""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib import font_manager as fm
import os

CJK = "/home/user/.local/share/fonts/noto-cjk/NotoSansCJKsc-Regular.otf"
CJK_B = "/home/user/.local/share/fonts/noto-cjk/NotoSansCJKsc-Bold.otf"
for p in (CJK, CJK_B):
    if os.path.exists(p):
        fm.fontManager.addfont(p)

INK = "#1f2933"
MUTED = "#6b7a8f"
GRID = "#e3e9f0"
TEAL = "#0f766e"
SLATE = "#334e68"
AMBER = "#b7791f"
PURPLE = "#6b46c1"
GRAY = "#94a3b8"
RED = "#b91c1c"

PALETTE = [TEAL, AMBER, PURPLE, SLATE, GRAY, RED]

plt.rcParams.update({
    "font.family": "Noto Sans CJK SC",
    "font.size": 10.5,
    "axes.unicode_minus": False,
    "axes.edgecolor": "#cbd5e1",
    "axes.linewidth": 0.9,
    "axes.labelcolor": INK,
    "axes.titlesize": 11.5,
    "axes.titleweight": "600",
    "axes.titlecolor": INK,
    "xtick.color": MUTED,
    "ytick.color": MUTED,
    "xtick.labelsize": 9.5,
    "ytick.labelsize": 9.5,
    "legend.frameon": False,
    "legend.fontsize": 9.5,
    "grid.color": GRID,
    "grid.linewidth": 0.8,
    "figure.dpi": 200,
    "savefig.bbox": "tight",
    "savefig.pad_inches": 0.06,
    "axes.spines.top": False,
    "axes.spines.right": False,
})


def finish(ax, xgrid=False, ygrid=True):
    ax.set_axisbelow(True)
    if ygrid:
        ax.yaxis.grid(True, linestyle="-")
    if xgrid:
        ax.xaxis.grid(True, linestyle="-")
    return ax


def panel_label(ax, s):
    ax.text(0.0, 1.03, s, transform=ax.transAxes, fontsize=10.5,
            color=MUTED, ha="left", va="bottom")
