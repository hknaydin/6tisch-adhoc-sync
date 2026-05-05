"""
Cooja .testlog parser for ad-hoc sync experiments.

Parses periodic reports from one or more Cooja test logs, aggregates final-state
metrics across runs of the same scenario (mean ± std ± 95% CI), and exports
both summary and time-series CSVs for downstream plotting.

Usage:
    python3 parse_logs.py \
        --logs testler/*.testlog \
        --scenario 30_grid \
        --out-dir ./summary \
        --min-duration 3000
"""

import re
import os
import glob
import csv
import statistics
import argparse


# ---------------------------------------------------------------------------
# Regex patterns
# ---------------------------------------------------------------------------

REPORT_RE = re.compile(
    r"===== PERIODIC REPORT at ([\d.]+) s =====(.*?)===== END REPORT =====",
    re.DOTALL,
)

SEED_RE = re.compile(r"Random seed:\s*(\d+)")

# (key, regex_pattern, cast_func)
METRIC_PATTERNS = [
    ("rpl_dio",      r"RPL_DIO:\s*(\d+)",                                       int),
    ("rpl_dis",      r"RPL_DIS:\s*(\d+)",                                       int),
    ("rpl_dao",      r"RPL_DAO:\s*(\d+)",                                       int),
    ("rpl_total",    r"RPL_Total:\s*(\d+)",                                     int),
    ("adhoc_tx",     r"Adhoc_TX:\s*(\d+)",                                      int),
    ("adhoc_rx",     r"Adhoc_RX:\s*(\d+)",                                      int),
    ("conv_count",   r"Converged nodes:\s*(\d+)/\d+",                           int),
    ("first_conv",   r"First convergence:\s*([\d.]+)\s*s",                      float),
    ("last_conv",    r"Network convergence \(last\):\s*([\d.]+)",               float),
    ("avg_conv",     r"Average convergence:\s*([\d.]+)",                        float),
    ("avg_va",       r"Avg Version Age:\s*([\d.]+)",                            float),
    ("max_va",       r"Max Version Age:\s*(\d+)",                               int),
    ("perfect_pct",  r"Perfect pairs.*?\(([\d.]+)%\)",                          float),
    ("avg_eta_sc",   r"Avg eta_sc:\s*([\d.]+)%",                                float),
    ("min_eta_sc",   r"Min eta_sc:\s*([\d.]+)%",                                float),
    ("max_eta_sc",   r"Max eta_sc:\s*([\d.]+)%",                                float),
    ("udp_pdr",      r"Total TX:\s*\d+\s+RX:\s*\d+\s+PDR:\s*([\d.]+)%",         float),
    ("udp_latency",  r"AvgDelay:\s*([\d.]+)ms\s+BufferDrop",                    float),
    ("udp_buf_drop", r"BufferDrop:\s*(\d+)\s*$",                                int),
]

METRIC_KEYS = [k for k, _, _ in METRIC_PATTERNS]

# t-distribution critical values for 95% CI (two-tailed), df = n - 1
T95 = {1: 12.706, 2: 4.303, 3: 3.182, 4: 2.776, 5: 2.571,
       6: 2.447, 7: 2.365, 8: 2.306, 9: 2.262, 10: 2.228,
       15: 2.131, 20: 2.086, 30: 2.042}


# ---------------------------------------------------------------------------
# Parsing
# ---------------------------------------------------------------------------

def parse_report_block(time_s, body):
    """Extract metrics from one PERIODIC REPORT body."""
    rep = {"time": float(time_s)}
    for key, pattern, cast in METRIC_PATTERNS:
        m = re.search(pattern, body, re.MULTILINE)
        if m:
            try:
                rep[key] = cast(m.group(1))
            except (ValueError, TypeError):
                pass
    return rep


def parse_log_file(filepath):
    """Read one .testlog file and return its full structure."""
    with open(filepath, "r", encoding="utf-8", errors="replace") as f:
        content = f.read()

    seed_match = SEED_RE.search(content)
    seed = int(seed_match.group(1)) if seed_match else None

    reports = [parse_report_block(t, b) for t, b in REPORT_RE.findall(content)]

    return {
        "filepath": filepath,
        "filename": os.path.basename(filepath),
        "seed":     seed,
        "reports":  reports,
        "final":    reports[-1] if reports else {},
    }


# ---------------------------------------------------------------------------
# Aggregation
# ---------------------------------------------------------------------------

def t_critical(df):
    """Return t-critical for given df, or fall back to the closest known one."""
    if df in T95:
        return T95[df]
    if df > 30:
        return 1.96
    return T95[min(T95.keys(), key=lambda k: abs(k - df))]


def aggregate(runs, scenario_name):
    """Compute mean ± std ± 95% CI from final-state values across runs."""
    print(f"\n{'=' * 76}")
    print(f"  SCENARIO: {scenario_name}   (n={len(runs)} runs)")
    print('=' * 76)
    print(f"  {'Metric':<18s} {'Mean':>12s} {'StdDev':>10s} {'CV':>7s} {'95% CI':>11s}")
    print(f"  {'-' * 18} {'-' * 12} {'-' * 10} {'-' * 7} {'-' * 11}")

    summary = {"scenario": scenario_name, "n_runs": len(runs)}

    for key in METRIC_KEYS:
        vals = [r["final"].get(key) for r in runs if r["final"].get(key) is not None]
        if not vals:
            continue

        avg = sum(vals) / len(vals)
        std = statistics.stdev(vals) if len(vals) > 1 else 0.0
        cv  = std / abs(avg) if avg != 0 else 0
        df  = len(vals) - 1
        ci  = t_critical(df) * std / (len(vals) ** 0.5) if df > 0 else 0

        warn = " ⚠"  if cv > 0.10 else ""
        print(f"  {key:<18s} {avg:>12.2f} {std:>10.2f} {cv:>6.1%} {ci:>11.2f}{warn}")

        summary[f"{key}_mean"] = avg
        summary[f"{key}_std"]  = std
        summary[f"{key}_ci95"] = ci
        summary[f"{key}_n"]    = len(vals)

    return summary


# ---------------------------------------------------------------------------
# Time-series export
# ---------------------------------------------------------------------------

def export_timeseries_avg(runs, output_path):
    """For each timestamp common across runs, write mean ± std per metric."""
    all_times = sorted({r["time"] for run in runs for r in run["reports"]})

    rows = []
    for t in all_times:
        snapshots = []
        for run in runs:
            for rep in run["reports"]:
                if rep["time"] == t:
                    snapshots.append(rep)
                    break

        row = {"time": t, "n": len(snapshots)}
        for key in METRIC_KEYS:
            vals = [s.get(key) for s in snapshots if s.get(key) is not None]
            if vals:
                row[f"{key}_mean"] = sum(vals) / len(vals)
                row[f"{key}_std"]  = statistics.stdev(vals) if len(vals) > 1 else 0.0
        rows.append(row)

    if not rows:
        return

    fieldnames = ["time", "n"]
    for key in METRIC_KEYS:
        fieldnames.extend([f"{key}_mean", f"{key}_std"])

    with open(output_path, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def export_timeseries_raw(runs, output_path):
    """One row per (time, run) — useful for plotting individual seed traces."""
    rows = []
    for run_idx, run in enumerate(runs):
        for rep in run["reports"]:
            row = {"time": rep["time"], "run_idx": run_idx, "seed": run["seed"]}
            for key in METRIC_KEYS:
                if key in rep:
                    row[key] = rep[key]
            rows.append(row)

    if not rows:
        return

    fieldnames = ["time", "run_idx", "seed"] + METRIC_KEYS
    with open(output_path, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def sanitize_name(name):
    """Make a string safe to use as a path component."""
    cleaned = re.sub(r"[^\w\-]+", "_", name.strip().strip("/")).strip("_")
    return cleaned or "scenario"


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--logs", nargs="+", required=True,
                    help="Log files or glob patterns (e.g. 'testler/*.testlog')")
    ap.add_argument("--scenario", default="default",
                    help="Scenario name used in output filenames")
    ap.add_argument("--out-dir", default=".",
                    help="Output directory (default: current)")
    ap.add_argument("--min-duration", type=float, default=3000,
                    help="Skip runs whose final report time is below this (seconds)")
    ap.add_argument("--require-runs", type=int, default=3,
                    help="Minimum number of valid runs needed for aggregation")
    ap.add_argument("--raw-timeseries", action="store_true",
                    help="Also export per-run raw time-series (no averaging)")
    args = ap.parse_args()

    safe_name = sanitize_name(args.scenario)

    # Expand globs
    files = []
    for pattern in args.logs:
        if any(c in pattern for c in "*?["):
            files.extend(sorted(glob.glob(pattern)))
        else:
            files.append(pattern)

    if not files:
        print("⚠  No log files matched.")
        return

    # Parse each log
    print(f"📂  {len(files)} log file(s) found:")
    runs, incomplete, errors = [], [], []
    for f in files:
        try:
            run = parse_log_file(f)
            last_t = run["final"].get("time", 0)
            n_rep  = len(run["reports"])

            if last_t < args.min_duration:
                incomplete.append((run, last_t))
                print(f"    ⚠ SKIP {run['filename']:55s}  "
                      f"only {last_t:.0f}s (< {args.min_duration:.0f}s threshold)")
                continue

            runs.append(run)
            print(f"    ✓      {run['filename']:55s}  "
                  f"seed={run['seed']}  reports={n_rep}  t_end={last_t:.0f}s")

        except Exception as e:
            errors.append((f, str(e)))
            print(f"    ✗      {os.path.basename(f)}: {e}")

    # Sanity checks
    if incomplete:
        print(f"\n⚠  Excluded {len(incomplete)} incomplete run(s) "
              f"(below {args.min_duration:.0f}s)")
    if errors:
        print(f"⚠  Failed to parse {len(errors)} file(s)")

    if len(runs) < args.require_runs:
        print(f"\n✗  Only {len(runs)} valid run(s); need at least "
              f"{args.require_runs} for aggregation. Aborting.")
        return

    # Check final-time consistency
    final_times = sorted({r["final"]["time"] for r in runs if r["final"]})
    if len(final_times) > 1:
        print(f"\n⚠  Runs have different final times: {final_times}")
        print("   Aggregation still proceeds, but results may be uneven.")

    # Aggregate
    summary = aggregate(runs, safe_name)

    # Write outputs
    os.makedirs(args.out_dir, exist_ok=True)

    summary_path = os.path.join(args.out_dir, f"{safe_name}_summary.csv")
    with open(summary_path, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=summary.keys())
        writer.writeheader()
        writer.writerow(summary)
    print(f"\n📊  Summary           → {summary_path}")

    ts_avg_path = os.path.join(args.out_dir, f"{safe_name}_timeseries_avg.csv")
    export_timeseries_avg(runs, ts_avg_path)
    print(f"📊  Time-series (avg) → {ts_avg_path}")

    if args.raw_timeseries:
        ts_raw_path = os.path.join(args.out_dir, f"{safe_name}_timeseries_raw.csv")
        export_timeseries_raw(runs, ts_raw_path)
        print(f"📊  Time-series (raw) → {ts_raw_path}")


if __name__ == "__main__":
    main()
