"""
Cooja .testlog dosyalarini okuyup makaledeki her grafik icin
ayri .dat dosyasi uretir.

KULLANIM:
    python3 make_data.py                    # default: ./testler/
    python3 make_data.py /path/to/logs      # ozel klasor

GIRDI:
    Belirtilen klasor icindeki COOJA_*.testlog dosyalari (5 adet bekleniyor)

CIKTI (15 dosya):
    Application:
      data_pdr.dat              UDP PDR (%)
      data_latency.dat          UDP avg latency (ms)
      data_udp_buf_drop.dat     UDP cumulative buffer drops
    Sync / convergence:
      data_avg_va.dat           Average version age
      data_max_va.dat           Max version age
      data_convergence.dat      first/last/avg convergence (tek deger)
    Control overhead:
      data_adhoc_tx.dat         Cumulative ad-hoc TX frames
      data_adhoc_rx.dat         Cumulative ad-hoc RX frames
      data_control_overhead.dat RPL Total (DIO+DIS+DAO)
    Power:
      data_power_total.dat      Total network power (mW)
      data_power_cpu.dat        CPU power
      data_power_lpm.dat        LPM power
      data_power_tx.dat         TX power
      data_power_rx.dat         RX power
      data_duty_cycle.dat       Radio duty cycle (%) = (TX+RX)/Total

Her zaman serisi .dat dosyasi 4 sutunlu:
    # time_min   mean   std   n_runs
"""

import re
import os
import sys
import glob
import statistics

# ----------------------------------------------------------------------------
# Klasor (argumandan oku, yoksa ./testler/)
# ----------------------------------------------------------------------------
if len(sys.argv) >= 2:
    LOGS_DIR = sys.argv[1]
else:
    LOGS_DIR = "./testler/11node/"

LOGS_GLOB    = os.path.join(LOGS_DIR, "COOJA_*.testlog")
TARGET_TIMES = [600, 1200, 1800, 2400, 3000, 3600]   # 10..60 dakika
TOLERANCE    = 30                                     # +/- 30s

# Zaman serisi metrikleri
METRICS = [
    ("pdr",            r"Total TX:\s*\d+\s+RX:\s*\d+\s+PDR:\s*([\d.]+)%",         float, "data_pdr.dat"),
    ("latency",        r"AvgDelay:\s*([\d.]+)ms\s+BufferDrop",                    float, "data_latency.dat"),
    ("udp_buf_drop",   r"BufferDrop:\s*(\d+)\s*$",                                int,   "data_udp_buf_drop.dat"),
    ("avg_va",         r"Avg Version Age:\s*([\d.]+)",                            float, "data_avg_va.dat"),
    ("max_va",         r"Max Version Age:\s*(\d+)",                               int,   "data_max_va.dat"),
    ("adhoc_tx",       r"Adhoc_TX:\s*(\d+)",                                      int,   "data_adhoc_tx.dat"),
    ("adhoc_rx",       r"Adhoc_RX:\s*(\d+)",                                      int,   "data_adhoc_rx.dat"),
    ("rpl_total",      r"RPL_Total:\s*(\d+)",                                     int,   "data_control_overhead.dat"),
    ("power_total",    r"Power_Total:\s*([\d.]+)",                                float, "data_power_total.dat"),
    ("power_cpu",      r"Power_CPU:\s*([\d.]+)",                                  float, "data_power_cpu.dat"),
    ("power_lpm",      r"Power_LPM:\s*([\d.]+)",                                  float, "data_power_lpm.dat"),
    ("power_tx",       r"Power_TX:\s*([\d.]+)",                                   float, "data_power_tx.dat"),
    ("power_rx",       r"Power_RX:\s*([\d.]+)",                                   float, "data_power_rx.dat"),
    # Energest tickleri (duty cycle hesabi icin)
    ("energest_tx",    r"Energest_TX:\s*(\d+)",                                   int,   None),
    ("energest_rx",    r"Energest_RX:\s*(\d+)",                                   int,   None),
    ("energest_total", r"Energest_Total:\s*(\d+)",                                int,   None),
]

# Tek-seferlik metrikler (convergence)
SUMMARY_METRICS = [
    ("first_conv", r"First convergence:\s*([\d.]+)\s*s",         float),
    ("last_conv",  r"Network convergence \(last\):\s*([\d.]+)",  float),
    ("avg_conv",   r"Average convergence:\s*([\d.]+)",           float),
]

REPORT_RE = re.compile(
    r"===== PERIODIC REPORT at ([\d.]+) s =====(.*?)===== END REPORT =====",
    re.DOTALL
)

# ----------------------------------------------------------------------------
# 1) Loglari oku
# ----------------------------------------------------------------------------
print(f"Klasor: {LOGS_DIR}")
print(f"Pattern: {LOGS_GLOB}\n")

logs = sorted(glob.glob(LOGS_GLOB))

if not logs:
    print(f"HATA: '{LOGS_DIR}' klasorunde COOJA_*.testlog dosyasi bulunamadi.")
    print(f"\nKullanim:")
    print(f"  python3 make_data.py                  # default: ./testler/")
    print(f"  python3 make_data.py /path/to/logs    # ozel klasor")
    sys.exit(1)

print(f"Bulunan log: {len(logs)}\n")
all_runs   = []
final_data = []

for filepath in logs:
    with open(filepath) as f:
        content = f.read()
    
    run = {}
    last_body = None
    for time_str, body in REPORT_RE.findall(content):
        t = float(time_str)
        last_body = body
        for target in TARGET_TIMES:
            if abs(t - target) <= TOLERANCE:
                rep = {}
                for key, pattern, cast, _ in METRICS:
                    m = re.search(pattern, body, re.MULTILINE)
                    if m:
                        try: rep[key] = cast(m.group(1))
                        except ValueError: pass
                # Duty cycle hesabi
                if all(k in rep for k in ("energest_tx", "energest_rx", "energest_total")):
                    if rep["energest_total"] > 0:
                        rep["duty_cycle"] = 100.0 * (rep["energest_tx"] + rep["energest_rx"]) / rep["energest_total"]
                run[target] = rep
                break
    all_runs.append(run)
    
    final = {}
    if last_body:
        for key, pattern, cast in SUMMARY_METRICS:
            m = re.search(pattern, last_body, re.MULTILINE)
            if m:
                try: final[key] = cast(m.group(1))
                except ValueError: pass
    final_data.append(final)
    
    print(f"  {os.path.basename(filepath)}  -> {sorted(run.keys())}")

print()

# ----------------------------------------------------------------------------
# 2) Zaman serisi .dat dosyalari
# ----------------------------------------------------------------------------
print("Yazilan .dat dosyalari:")

for key, _, _, outfile in METRICS:
    if outfile is None:
        continue
    with open(outfile, "w") as f:
        f.write(f"# {key}\n")
        f.write(f"# 10-min intervals, n={len(logs)} runs, mean +- std\n")
        f.write(f"# columns:  time_min   mean   std   n_runs\n")
        for target in TARGET_TIMES:
            vals = [r[target][key] for r in all_runs if target in r and key in r[target]]
            if not vals: continue
            mean_ = statistics.mean(vals)
            std_  = statistics.stdev(vals) if len(vals) > 1 else 0.0
            f.write(f"  {target/60:6.0f}   {mean_:14.4f}   {std_:14.4f}   {len(vals)}\n")
    print(f"  {outfile}")

# Duty cycle (turetilmis)
with open("data_duty_cycle.dat", "w") as f:
    f.write("# duty_cycle (%) = (Energest_TX + Energest_RX) / Energest_Total * 100\n")
    f.write(f"# 10-min intervals, n={len(logs)} runs, mean +- std\n")
    f.write("# columns:  time_min   mean   std   n_runs\n")
    for target in TARGET_TIMES:
        vals = [r[target]["duty_cycle"] for r in all_runs 
                if target in r and "duty_cycle" in r[target]]
        if not vals: continue
        mean_ = statistics.mean(vals)
        std_  = statistics.stdev(vals) if len(vals) > 1 else 0.0
        f.write(f"  {target/60:6.0f}   {mean_:14.4f}   {std_:14.4f}   {len(vals)}\n")
print("  data_duty_cycle.dat")

# ----------------------------------------------------------------------------
# 3) Convergence (tek deger)
# ----------------------------------------------------------------------------
with open("data_convergence.dat", "w") as f:
    f.write("# Convergence statistics (seconds)\n")
    f.write(f"# n={len(logs)} runs, mean +- std\n")
    f.write("# columns:  metric   mean   std   n_runs\n")
    for key, _, _ in SUMMARY_METRICS:
        vals = [d[key] for d in final_data if key in d]
        if not vals: continue
        mean_ = statistics.mean(vals)
        std_  = statistics.stdev(vals) if len(vals) > 1 else 0.0
        f.write(f"  {key:14s}  {mean_:8.3f}  {std_:8.3f}    {len(vals)}\n")
print("  data_convergence.dat")

print(f"\n--> Toplam 15 .dat dosyasi yazildi.")
