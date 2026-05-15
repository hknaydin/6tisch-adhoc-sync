"""Generate publication-quality figures from .dat files in testler/.

For every (metric, scenario) pair TWO single-panel figures are produced
so they can be inserted as separate LaTeX subfigures:

    figures/fig_<metric>_<size>_<topo>_line.{png,pdf}
    figures/fig_<metric>_<size>_<topo>_bar.{png,pdf}

Each panel compares 4 series:
    {RPL Root, RPL Root + Gossip}  x  {high coverage, low coverage}

Line plot   -> mean line  + mean +/- std shaded band + std error bars
Grouped bar -> mean bar   + std error bars at each 10-min interval
"""

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import Patch

BASE = Path(__file__).resolve().parent
OUT  = BASE / "figures"
OUT.mkdir(exist_ok=True)

SIZES      = [30, 40]
TOPOS      = ["grid", "random"]
PROTOCOLS  = ["RPL Root", "RPL Root + Gossip"]
COVERAGES  = ["high coverange", "low coverange"]

METRICS = {
    "pdr":         dict(file="data_pdr.dat",              ylabel="PDR (%)",                       title="Packet Delivery Ratio"),
    "latency":     dict(file="data_latency.dat",          ylabel="End-to-end Latency (ms)",       title="Latency"),
    "power":       dict(file="data_power_total.dat",      ylabel="Average Power (mW)",            title="Total Power Consumption"),
    "duty_cycle":  dict(file="data_duty_cycle.dat",       ylabel="Radio Duty Cycle (%)",          title="Radio Duty Cycle"),
    "coverage":    dict(file="data_max_va.dat",           ylabel="Max Version Age",               title="Coverage (Max Version Age)"),
    "avg_va":      dict(file="data_avg_va.dat",           ylabel="Average Version Age",           title="Average Version Age"),
    "ctrl_oh":     dict(file="data_control_overhead.dat", ylabel="RPL Control Packets (cumulative)", title="Control Overhead (DIO+DIS+DAO)"),
    "adhoc_tx":    dict(file="data_adhoc_tx.dat",         ylabel="Ad-hoc TX Frames (cumulative)", title="Ad-hoc TX Frames"),
    "adhoc_rx":    dict(file="data_adhoc_rx.dat",         ylabel="Ad-hoc RX Frames (cumulative)", title="Ad-hoc RX Frames"),
}

SERIES = [
    ("RPL Root",          "high coverange", "RPL, high cov.",        "#1f77b4", "-",  "o"),
    ("RPL Root",          "low coverange",  "RPL, low cov.",         "#1f77b4", "--", "s"),
    ("RPL Root + Gossip", "high coverange", "RPL+Gossip, high cov.", "#d62728", "-",  "^"),
    ("RPL Root + Gossip", "low coverange",  "RPL+Gossip, low cov.",  "#d62728", "--", "D"),
]


def load_dat(path: Path):
    """Return (time, mean, std) with unique time values sorted ascending."""
    if not path.exists():
        return None
    rows = []
    for line in path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        parts = line.split()
        try:
            t = float(parts[0]); m = float(parts[1]); s = float(parts[2])
            rows.append((t, m, s))
        except (ValueError, IndexError):
            continue
    if not rows:
        return None
    rows.sort(key=lambda r: r[0])
    out = {}
    for t, m, s in rows:
        out.setdefault(t, []).append((m, s))
    times, means, stds = [], [], []
    for t in sorted(out):
        pairs = out[t]
        ms = np.array([p[0] for p in pairs]); ss = np.array([p[1] for p in pairs])
        times.append(t); means.append(ms.mean()); stds.append(np.sqrt((ss ** 2).mean()))
    return np.array(times), np.array(means), np.array(stds)


def scenario_dir(size, topo, proto, cov):
    return BASE / f"{size}node{topo}" / proto / cov


def collect_series(size, topo, fname):
    """Return list of dicts {label,color,ls,marker,t,m,s} for one scenario."""
    series = []
    for proto, cov, label, color, ls, marker in SERIES:
        data = load_dat(scenario_dir(size, topo, proto, cov) / fname)
        if data is None:
            continue
        t, m, s = data
        series.append(dict(label=label, color=color, ls=ls, marker=marker, t=t, m=m, s=s))
    return series


# --- global figure style -------------------------------------------------
plt.rcParams.update({
    "font.family":      "DejaVu Serif",
    "font.size":        11,
    "axes.titlesize":   12,
    "axes.labelsize":   11,
    "legend.fontsize":  9,
    "xtick.labelsize":  10,
    "ytick.labelsize":  10,
    "axes.linewidth":   1.0,
    "lines.linewidth":  1.6,
    "lines.markersize": 5.5,
    "axes.grid":        True,
    "grid.alpha":       0.35,
    "grid.linestyle":   ":",
    "savefig.dpi":      300,
    "savefig.bbox":     "tight",
    "pdf.fonttype":     42,
    "ps.fonttype":      42,
})

FIG_W, FIG_H = 5.6, 3.9   # single-panel size, good for LaTeX subfigure


def save(fig, key, size, topo, kind):
    base = OUT / f"fig_{key}_{size}_{topo}_{kind}"
    for ext in ("png", "pdf"):
        fig.savefig(f"{base}.{ext}")
    plt.close(fig)
    return base


def plot_line(key, meta, size, topo):
    series = collect_series(size, topo, meta["file"])
    if not series:
        return None
    fig, ax = plt.subplots(figsize=(FIG_W, FIG_H))
    for s in series:
        ax.plot(s["t"], s["m"], color=s["color"], ls=s["ls"], marker=s["marker"], label=s["label"])
        ax.fill_between(s["t"], s["m"] - s["s"], s["m"] + s["s"], color=s["color"], alpha=0.12, linewidth=0)
        ax.errorbar(s["t"], s["m"], yerr=s["s"], fmt="none", ecolor=s["color"], elinewidth=0.9,
                    capsize=2.5, capthick=0.9, alpha=0.85, zorder=3)
    ax.set_xlabel("Simulation time (min)")
    ax.set_ylabel(meta["ylabel"])
    ax.set_title(f"{meta['title']}  -  {size} nodes, {topo}")
    ax.set_xticks([10, 20, 30, 40, 50, 60])
    ax.margins(x=0.02)
    ax.legend(loc="best", frameon=True, framealpha=0.85)
    fig.tight_layout()
    return save(fig, key, size, topo, "line")


def plot_bar(key, meta, size, topo):
    series = collect_series(size, topo, meta["file"])
    if not series:
        return None
    times = sorted({float(t) for s in series for t in s["t"]})
    n_groups = len(times)
    n_series = len(series)
    group_w  = 0.8
    bar_w    = group_w / n_series
    x        = np.arange(n_groups)

    fig, ax = plt.subplots(figsize=(FIG_W, FIG_H))
    for i, s in enumerate(series):
        t2m = dict(zip(s["t"], s["m"]))
        t2s = dict(zip(s["t"], s["s"]))
        means = [t2m.get(t, np.nan) for t in times]
        stds  = [t2s.get(t, 0.0)    for t in times]
        offset = (i - (n_series - 1) / 2) * bar_w
        ax.bar(
            x + offset, means, bar_w,
            yerr=stds, capsize=2.2, error_kw=dict(elinewidth=0.9, capthick=0.9, ecolor="0.25"),
            color=s["color"], edgecolor="white", linewidth=0.4, alpha=0.92,
            hatch=("" if s["ls"] == "-" else "//"),
            label=s["label"],
        )
    ax.set_xlabel("Simulation time (min)")
    ax.set_ylabel(meta["ylabel"])
    ax.set_title(f"{meta['title']}  -  {size} nodes, {topo}")
    ax.set_xticks(x)
    ax.set_xticklabels([f"{int(t)}" for t in times])
    ax.grid(axis="x", alpha=0)
    ax.margins(x=0.02)
    # custom legend so hatch is visible
    handles = [Patch(facecolor=s["color"], edgecolor="white", hatch=("" if s["ls"] == "-" else "//"), label=s["label"]) for s in series]
    ax.legend(handles=handles, loc="best", frameon=True, framealpha=0.85)
    fig.tight_layout()
    return save(fig, key, size, topo, "bar")


def main():
    print("Writing figures to:", OUT)
    n = 0
    for key, meta in METRICS.items():
        print(f"[ {key} ]")
        for size in SIZES:
            for topo in TOPOS:
                a = plot_line(key, meta, size, topo)
                b = plot_bar(key, meta, size, topo)
                if a: print(f"  {a.name}.png/.pdf")
                if b: print(f"  {b.name}.png/.pdf")
                n += (1 if a else 0) + (1 if b else 0)
    print(f"Done. {n} figures (each as .png + .pdf).")


if __name__ == "__main__":
    main()
