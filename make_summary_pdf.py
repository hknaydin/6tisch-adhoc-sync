"""Combine all metrics into a single multi-page PDF for review.

Each page = one (metric, style) combination shown as a 2x2 grid:
    rows -> 30 / 40 nodes
    cols -> grid / random
Two pages per metric (line + bar), 9 metrics => 18 pages total.

The single-panel figures produced by make_figures.py are NOT touched;
this script writes only:
    figures/summary_all_metrics.pdf
"""

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.patches import Patch

BASE = Path(__file__).resolve().parent
OUT  = BASE / "figures"
OUT.mkdir(exist_ok=True)

SIZES     = [30, 40]
TOPOS     = ["grid", "random"]
PROTOCOLS = ["RPL Root", "RPL Root + Gossip"]
COVERAGES = ["high coverange", "low coverange"]

METRICS = {
    "pdr":         dict(file="data_pdr.dat",              ylabel="PDR (%)",                          title="Packet Delivery Ratio"),
    "latency":     dict(file="data_latency.dat",          ylabel="End-to-end Latency (ms)",          title="Latency"),
    "power":       dict(file="data_power_total.dat",      ylabel="Average Power (mW)",               title="Total Power Consumption"),
    "duty_cycle":  dict(file="data_duty_cycle.dat",       ylabel="Radio Duty Cycle (%)",             title="Radio Duty Cycle"),
    "coverage":    dict(file="data_max_va.dat",           ylabel="Max Version Age",                  title="Coverage (Max Version Age)"),
    "avg_va":      dict(file="data_avg_va.dat",           ylabel="Average Version Age",              title="Average Version Age"),
    "ctrl_oh":     dict(file="data_control_overhead.dat", ylabel="RPL Control Packets (cumulative)", title="Control Overhead (DIO+DIS+DAO)"),
    "adhoc_tx":    dict(file="data_adhoc_tx.dat",         ylabel="Ad-hoc TX Frames (cumulative)",    title="Ad-hoc TX Frames"),
    "adhoc_rx":    dict(file="data_adhoc_rx.dat",         ylabel="Ad-hoc RX Frames (cumulative)",    title="Ad-hoc RX Frames"),
}

SERIES = [
    ("RPL Root",          "high coverange", "RPL, high cov.",        "#1f77b4", "-",  "o"),
    ("RPL Root",          "low coverange",  "RPL, low cov.",         "#1f77b4", "--", "s"),
    ("RPL Root + Gossip", "high coverange", "RPL+Gossip, high cov.", "#d62728", "-",  "^"),
    ("RPL Root + Gossip", "low coverange",  "RPL+Gossip, low cov.",  "#d62728", "--", "D"),
]


def load_dat(path):
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


def collect(size, topo, fname):
    out = []
    for proto, cov, label, color, ls, marker in SERIES:
        data = load_dat(scenario_dir(size, topo, proto, cov) / fname)
        if data is None:
            continue
        t, m, s = data
        out.append(dict(label=label, color=color, ls=ls, marker=marker, t=t, m=m, s=s))
    return out


plt.rcParams.update({
    "font.family":      "DejaVu Serif",
    "font.size":        9.5,
    "axes.titlesize":   10.5,
    "axes.labelsize":   9.5,
    "legend.fontsize":  8.0,
    "xtick.labelsize":  8.5,
    "ytick.labelsize":  8.5,
    "axes.linewidth":   0.9,
    "lines.linewidth":  1.4,
    "lines.markersize": 4.5,
    "axes.grid":        True,
    "grid.alpha":       0.35,
    "grid.linestyle":   ":",
    "pdf.fonttype":     42,
    "ps.fonttype":      42,
})


def draw_line_panel(ax, series):
    for s in series:
        ax.plot(s["t"], s["m"], color=s["color"], ls=s["ls"], marker=s["marker"], label=s["label"])
        ax.fill_between(s["t"], s["m"] - s["s"], s["m"] + s["s"], color=s["color"], alpha=0.12, linewidth=0)
        ax.errorbar(s["t"], s["m"], yerr=s["s"], fmt="none", ecolor=s["color"], elinewidth=0.8,
                    capsize=2.2, capthick=0.8, alpha=0.85, zorder=3)
    ax.set_xticks([10, 20, 30, 40, 50, 60])
    ax.margins(x=0.02)


def draw_bar_panel(ax, series):
    times = sorted({float(t) for s in series for t in s["t"]})
    n_groups = len(times)
    n_series = len(series)
    group_w  = 0.8
    bar_w    = group_w / n_series
    x        = np.arange(n_groups)
    for i, s in enumerate(series):
        t2m = dict(zip(s["t"], s["m"]))
        t2s = dict(zip(s["t"], s["s"]))
        means = [t2m.get(t, np.nan) for t in times]
        stds  = [t2s.get(t, 0.0)    for t in times]
        offset = (i - (n_series - 1) / 2) * bar_w
        ax.bar(
            x + offset, means, bar_w,
            yerr=stds, capsize=1.8, error_kw=dict(elinewidth=0.8, capthick=0.8, ecolor="0.25"),
            color=s["color"], edgecolor="white", linewidth=0.3, alpha=0.92,
            hatch=("" if s["ls"] == "-" else "//"),
            label=s["label"],
        )
    ax.set_xticks(x)
    ax.set_xticklabels([f"{int(t)}" for t in times])
    ax.grid(axis="x", alpha=0)
    ax.margins(x=0.02)


def page_2x2(pdf, key, meta, kind):
    fig, axes = plt.subplots(2, 2, figsize=(11.0, 8.0))
    for r, size in enumerate(SIZES):
        for c, topo in enumerate(TOPOS):
            ax = axes[r, c]
            series = collect(size, topo, meta["file"])
            if not series:
                ax.set_visible(False)
                continue
            if kind == "line":
                draw_line_panel(ax, series)
            else:
                draw_bar_panel(ax, series)
            ax.set_title(f"{size} nodes, {topo}")
            ax.set_xlabel("Simulation time (min)")
            ax.set_ylabel(meta["ylabel"])

    # shared legend
    handles = [Patch(facecolor=c, edgecolor="white", hatch=("" if ls == "-" else "//"), label=lbl)
               for _, _, lbl, c, ls, _ in SERIES]
    fig.legend(handles=handles, loc="upper center", ncol=4, frameon=False, bbox_to_anchor=(0.5, 0.99))
    fig.suptitle(f"{meta['title']}  ({kind})", fontsize=13, y=1.045)
    fig.tight_layout(rect=[0, 0, 1, 0.96])
    pdf.savefig(fig, bbox_inches="tight")
    plt.close(fig)


def main():
    for kind in ("line", "bar"):
        out_path = OUT / f"summary_all_metrics_{kind}.pdf"
        print(f"Writing: {out_path}")
        with PdfPages(out_path) as pdf:
            for key, meta in METRICS.items():
                print(f"  page: {key} ({kind})")
                page_2x2(pdf, key, meta, kind)
            pdf.infodict()["Title"]   = f"6TiSCH SRA - all metrics review ({kind})"
            pdf.infodict()["Subject"] = "30/40 nodes, grid/random, RPL vs RPL+Gossip, high vs low coverage"
    print("Done.")


if __name__ == "__main__":
    main()
