# parse_logs.py — Cooja Test Log Parser
<p>
A Python utility for parsing Cooja `.testlog` files produced by ad-hoc
synchronisation experiments on the IEEE 802.15.4e TSCH / 6TiSCH stack.
The script extracts **periodic report blocks** from each log, aggregates
the final-state metrics across multiple runs of the same scenario, and
exports per-scenario summary and time-series CSV files ready for
plotting and statistical analysis.</p>

<p> 
It is designed to work with the Cooja headless (`-nogui`) workflow where each simulation run writes its output to a timestamped `COOJA_<timestamp>_Nodes<N>.testlog` file. </p>

---

## Table of Contents

1. [Requirements](#requirements)
2. [Installation](#installation)
3. [Expected Log Format](#expected-log-format)
4. [Usage](#usage)
5. [Command-Line Arguments](#command-line-arguments)
6. [Output Files](#output-files)
7. [Console Output Explained](#console-output-explained)
8. [Worked Example — End to End](#worked-example--end-to-end)
9. [Multi-Scenario Workflow](#multi-scenario-workflow)
10. [Plotting the Results](#plotting-the-results)
11. [Troubleshooting](#troubleshooting)
12. [FAQ](#faq)

---

## Requirements

* **Python 3.7+** (uses f-strings, `statistics.stdev`, no third-party
  dependencies)
* No `pip install` step is required — the script uses only the standard
  library: `re`, `os`, `glob`, `csv`, `statistics`, `argparse`.

Verify your Python version:

````bash
python3 --version
# Python 3.10.12  (or any 3.7+)
````

---

## Installation
<p>
Place `parse_logs.py` anywhere convenient. The natural location is your
Cooja working directory so the script can find the `.testlog` files
written by the simulator: </p>

````
cooja/
├── dist/
│   └── cooja.jar
├── parse_logs.py            ← place it here
├── testler/                 ← directory holding your testlog files
│   ├── COOJA_20260504-214837_Nodes31.testlog
│   ├── COOJA_20260504-214843_Nodes31.testlog
│   └── ...
└── summary/                 ← output directory (auto-created)
````

No build step is needed — the script is self-contained.

---

## Expected Log Format
<p> The parser is tightly coupled to the periodic report format emitted by the modified 6TiSCH stack. Every block the script understands looks like this: </p>

````
===== PERIODIC REPORT at 1500.0 s =====

========== AD-HOC SYNC RESULTS ==========

--- Control Overhead ---
RPL_DIO: 620
RPL_DIS: 172
RPL_DAO: 115
RPL_Total: 907
Adhoc_TX: 3697
Adhoc_RX: 11743

--- Convergence Time ---
Converged nodes: 4/31
First convergence: 127.58 s
Network convergence (last): 187.27 s
Average convergence: 165.85 s

--- Version Age (at simulation end) ---
Avg Version Age: 43.89
Max Version Age: 123
Perfect pairs (delta=0): 270/930 (29.0%)

--- Single-Contact Retrieval (eta_sc) ---
Avg eta_sc: 62.6%
Min eta_sc: 43.3%
Max eta_sc: 100.0%

========== UDP PDR/LATENCY RESULTS ==========
ID: 2 TX: 77 RX: 34 PDR: 44.2% AvgDelay: 1807.6ms Switches: 1 BufDrop: 0
...
Total TX: 2470 RX: 1231 PDR: 49.84% AvgDelay: 1195.67ms BufferDrop: 326
===== END REPORT =====
````

The first line of the file is normally:

````
Random seed: 824233
````

and is captured as the `seed` field for traceability.
<p>
A single `.testlog` may contain many of these report blocks (one every
few simulated minutes); the parser extracts **every** block and uses
the **final** one for the aggregated summary while the **full series**
is exported for plotting.</p>

The extracted metric keys are:

| Metric key | Description |
|---|---|
| `rpl_dio` / `rpl_dis` / `rpl_dao` | Per-message-type RPL control packets |
| `rpl_total` | Total RPL control overhead (sum of the three above) |
| `adhoc_tx` / `adhoc_rx` | Ad-hoc synchronisation frames sent / received |
| `conv_count` | Number of nodes that have converged so far |
| `first_conv` / `last_conv` / `avg_conv` | Convergence times in seconds |
| `avg_va` / `max_va` | Mean and worst-case version age $\Delta_{ij}$ |
| `perfect_pct` | Percentage of node pairs with $\Delta_{ij} = 0$ |
| `avg_eta_sc` / `min_eta_sc` / `max_eta_sc` | Single-contact retrieval ratio |
| `udp_pdr` / `udp_latency` / `udp_buf_drop` | Application-layer KPIs |

If the running 6TiSCH build emits a metric the parser does not yet
recognise, it is silently ignored; add a new entry to the
`METRIC_PATTERNS` list at the top of the script to capture it.

---

## Usage

The minimum invocation needs three arguments:

````bash
python3 parse_logs.py \
    --logs testler/*.testlog \
    --scenario 30_grid \
    --out-dir ./summary
````

* `--logs` accepts either a glob (`testler/*.testlog`) or a list of
  explicit paths (recommended when many unrelated logs share a folder
  — see [Multi-Scenario Workflow](#multi-scenario-workflow)).
* `--scenario` is used **only** to name the output files. Forward
  slashes, spaces, and other path-unsafe characters are sanitised to
  underscores automatically.
* `--out-dir` is created if it does not exist.

---

## Command-Line Arguments

| Argument | Type | Default | Description |
|---|---|---|---|
| `--logs` | one or more paths/globs | **required** | Files to parse. Globs are expanded, sorted, and deduplicated. |
| `--scenario` | string | `default` | Label used in CSV filenames (`<scenario>_summary.csv`, `<scenario>_timeseries_avg.csv`). |
| `--out-dir` | path | `.` | Output directory. Auto-created if missing. |
| `--min-duration` | float (seconds) | `3000` | Runs whose final report timestamp is below this are excluded from aggregation. Prevents mixing 5100 s and 600 s runs. |
| `--require-runs` | int | `3` | Aggregation aborts if fewer than this many runs survive the duration filter. |
| `--raw-timeseries` | flag | off | Also export a per-run, un-averaged CSV — useful when you want individual seed traces on the same plot. |

---

## Output Files

Two (optionally three) CSV files are produced, all prefixed with the
sanitised scenario name:

### 1. `<scenario>_summary.csv` — single row, one column per metric

Columns:

* `scenario`
* `n_runs`
* `<metric>_mean`
* `<metric>_std`
* `<metric>_ci95` (half-width of the 95 % confidence interval, computed
  using a Student-t critical value with df = n − 1)
* `<metric>_n` (number of runs that contributed a value for that
  metric — usually equal to `n_runs` but lower when a metric was
  absent in some logs)

This is the file you typically copy into your paper's results table.

### 2. `<scenario>_timeseries_avg.csv` — one row per simulated timestamp

Columns:

* `time` — simulated time in seconds
* `n` — how many runs contributed a snapshot at this timestamp
* `<metric>_mean`, `<metric>_std` — across runs at that instant

Use this for line plots with shaded ±1σ or 95 % CI bands.

### 3. `<scenario>_timeseries_raw.csv` (only with `--raw-timeseries`)

One row per `(time, run_idx)` pair, with the raw integer/float values
for every metric. This is what you want when plotting individual seed
traces overlaid on top of the mean curve.

---

## Console Output Explained

A typical run produces output like this:

````
📂  5 log file(s) found:
    ✓ COOJA_20260504-214837_Nodes31.testlog   seed=824233  reports=17  t_end=5100s
    ✓ COOJA_20260504-214843_Nodes31.testlog   seed=162941  reports=17  t_end=5100s
    ✓ COOJA_20260504-214847_Nodes31.testlog   seed=960329  reports=17  t_end=5100s
    ⚠ SKIP COOJA_20260505-095634_Nodes31.testlog  only 600s (< 3000s threshold)
    ⚠ SKIP COOJA_20260505-095640_Nodes31.testlog  only 600s (< 3000s threshold)

⚠  Excluded 2 incomplete run(s) (below 3000s)

============================================================================
  SCENARIO: 30_grid   (n=3 runs)
============================================================================
  Metric              Mean       StdDev    CV      95% CI
  ------------------ ----------- --------- ------- ----------
  rpl_total              907.00     12.30   1.4%      30.55
  adhoc_tx              3697.00    105.40   2.8%     261.71
  avg_va                  43.89      2.10   4.8%       5.21
  avg_eta_sc              62.60      1.20   1.9%       2.98
  udp_pdr                 49.84      1.05   2.1%       2.61

📊  Summary           → ./summary/30_grid_summary.csv
📊  Time-series (avg) → ./summary/30_grid_timeseries_avg.csv
````

Reading the table:

* **Mean**, **StdDev** — sample mean and sample standard deviation
  across the surviving runs.
* **CV** — coefficient of variation (`std / |mean|`). A `⚠` symbol is
  printed when CV > 10 %, indicating the metric varies a lot run-to-run
  and you may want more replicates.
* **95 % CI** — the half-width of the 95 % confidence interval, e.g.
  `mean ± 95% CI` is the interval. Critical values come from a small
  built-in t-table (df = 1…30) and fall back to 1.96 for df > 30.

---

## Worked Example — End to End

Suppose you ran five replicates of a 31-node grid scenario in
headless Cooja:

````bash
cd ~/Downloads/gokhan-aydın-tez/6tisch-ng-sra-v17/6tisch-ng-sra/tools/cooja

# Five runs, each with a different random seed
for seed in 824233 162941 960329 541195 987667; do
    java -mx512m -jar dist/cooja.jar \
        -nogui=scenarios/30_grid_seed_${seed}.csc \
        -contiki=../../
done

# Move the outputs into a per-scenario folder
mkdir -p testler/30_grid
mv COOJA_*.testlog testler/30_grid/
````

You now have:

````
testler/30_grid/
├── COOJA_20260504-214837_Nodes31.testlog   seed=824233   t_end=5100s
├── COOJA_20260504-214843_Nodes31.testlog   seed=162941   t_end=5100s
├── COOJA_20260504-214847_Nodes31.testlog   seed=960329   t_end=5100s
├── COOJA_20260505-095634_Nodes31.testlog   seed=541195   t_end=600s   ← crashed
└── COOJA_20260505-095640_Nodes31.testlog   seed=987667   t_end=600s   ← crashed
````

Run the parser:

````bash
python3 parse_logs.py \
    --logs testler/30_grid/*.testlog \
    --scenario 30_grid \
    --out-dir ./summary \
    --min-duration 3000 \
    --raw-timeseries
````

The two crashed runs are skipped, three valid runs are aggregated, and
three CSVs land in `./summary/`:

````
summary/
├── 30_grid_summary.csv
├── 30_grid_timeseries_avg.csv
└── 30_grid_timeseries_raw.csv
````

Re-run the two crashed seeds, drop the new `.testlog` files into
`testler/30_grid/`, and run the parser again to update the summary
with five replicates.

---

## Multi-Scenario Workflow

For experiments that vary node count and topology, the cleanest layout
is one folder per scenario:

````
testler/
├── 30_grid/
│   ├── COOJA_<ts>_Nodes31.testlog × 5
├── 30_random/
│   ├── COOJA_<ts>_Nodes31.testlog × 5
├── 40_grid/
│   ├── COOJA_<ts>_Nodes41.testlog × 5
└── 40_random/
    └── COOJA_<ts>_Nodes41.testlog × 5
````

Then a small bash loop produces one summary per scenario:

````bash
for scen in 30_grid 30_random 40_grid 40_random; do
    python3 parse_logs.py \
        --logs "testler/${scen}"/*.testlog \
        --scenario "$scen" \
        --out-dir ./summary \
        --min-duration 3000
done
````

You will end up with `summary/30_grid_summary.csv`,
`summary/30_random_summary.csv`, and so on — concatenate them in
pandas to build a four-row table for the paper.

If you do not want a folder hierarchy, you can also pass file lists explicitly:

````bash
python3 parse_logs.py \
    --logs \
        testler/COOJA_20260504-214837_Nodes31.testlog \
        testler/COOJA_20260504-214843_Nodes31.testlog \
        testler/COOJA_20260504-214847_Nodes31.testlog \
    --scenario 30_grid \
    --out-dir ./summary
````

This is the safest approach when many unrelated `.testlog` files share a directory.

---

## Plotting the Results

The time-series CSVs are designed to drop straight into pandas /
matplotlib. A typical convergence plot looks like:

````python
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("summary/30_grid_timeseries_avg.csv")

fig, ax = plt.subplots(figsize=(6, 3.5))
ax.plot(df["time"], df["avg_va_mean"], label="Avg version age")
ax.fill_between(df["time"],
                df["avg_va_mean"] - df["avg_va_std"],
                df["avg_va_mean"] + df["avg_va_std"],
                alpha=0.25, label="±1σ")
ax.set_xlabel("Simulation time (s)")
ax.set_ylabel(r"$\bar{\Delta}$ (versions)")
ax.legend()
fig.tight_layout()
fig.savefig("avg_version_age.pdf")
````

For a per-seed overlay, use the raw time-series file:

````python
raw = pd.read_csv("summary/30_grid_timeseries_raw.csv")
for seed, sub in raw.groupby("seed"):
    ax.plot(sub["time"], sub["avg_va"], alpha=0.4)
````

---

## Troubleshooting

### `FileNotFoundError: ./summary/<scenario>/_timeseries.csv`

Caused by a trailing slash in `--scenario`. The parser sanitises this automatically in current versions; if you still see it, upgrade or
remove the trailing slash:

````bash
--scenario 30_grid           # ✓
--scenario testler/          # ✗ (path looks like a directory)
````

### `Only 1 valid run(s); need at least 3`

`--min-duration` filtered out too many runs because they crashed
early. Either re-run the failed seeds or lower the threshold (only do
this if you know the short runs are still meaningful):

````bash
--min-duration 500
````

### A metric you expect is missing from the summary

The parser silently skips metrics whose regex does not match. Confirm
the regex against an actual report block — small wording changes in
the C-side `printf` will break the match. Add or adjust the entry in
`METRIC_PATTERNS` near the top of the script.

### Coefficient of variation (CV) is very high (⚠)

* **CV > 10 %**: noisy metric — consider 10 or more replicates for
  publication-quality numbers.
* **CV > 50 %**: almost certainly mixing inhomogeneous runs. Check the
  `t_end` column for each run — if some are 600 s and others 5100 s,
  raise `--min-duration`.

### `runs have different final times`

A warning, not an error. The parser still aggregates final-state
values, but interpret them carefully — comparing a 1500 s snapshot
with a 5100 s snapshot is rarely meaningful. Re-run the short ones
and re-parse.

---

## FAQ

**Q. Does the parser need to be restarted between scenarios?**
No. Each invocation processes one scenario, and the bash loop in
[Multi-Scenario Workflow](#multi-scenario-workflow) handles all four.

**Q. Can I parse a log file that is still being written?**
<p> Yes, but the `min-duration` filter will likely skip it until the
simulation ends. The parser only reads the file once, so it does not
follow live updates. <p>

**Q. Why does `n` differ from `n_runs` in the time-series?**
Because not every run necessarily produced a snapshot at every
timestamp. For example, if one run crashed at 4500 s and others ran
to 5100 s, the 4800 s and 5100 s rows in the time-series will have
`n = (n_runs − 1)`.

**Q. How are 95 % CIs computed?**
Using a small built-in table of Student-t critical values with df = n − 1
(2.776 for df = 4, 2.571 for df = 5, etc.). The half-width is
`t × σ / √n`. For df > 30 the limit value 1.96 is used.

**Q. How do I add a new metric?**
Open `parse_logs.py`, find the `METRIC_PATTERNS` list near the top,
and append a tuple of `(key, regex, cast_function)`:

````python
("my_new_metric", r"My New Metric:\s*([\d.]+)", float),
````

The new column will then appear in both the summary and time-series
outputs without further changes.

---

## Project Context

This parser is part of the experimental tooling for the paper
*Adaptive Data Dissemination and Opportunistic Collection in IEEE
802.15.4e-based 6TiSCH Networks*. It targets the customised Contiki-NG
6TiSCH stack provided by Mavi Alp Information Technologies and the
modified ad-hoc synchronisation modules described in the paper.

If you adapt the parser to a different stack, the only file you need
to touch is `parse_logs.py` itself — specifically the `METRIC_PATTERNS`
list and, if your reports use a different delimiter, `REPORT_RE`.
