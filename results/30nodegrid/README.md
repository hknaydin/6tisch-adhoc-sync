# paper_figures — Cooja log'larından makale grafikleri

Bu klasör, `COOJA_*.testlog` dosyalarından 11-node grid simülasyonunun
tüm istatistiklerini çıkarır ve makaleye eklemek için EPS grafikleri üretir.

## Hızlı başlangıç

```bash
# Default: ./testler/ klasörünü okur
python3 make_data.py
bash run_all.sh

# Özel klasör belirtmek istersen:
python3 make_data.py /path/to/your/logs/
bash run_all.sh /path/to/your/logs/
```

## Klasör yapısı (önerilen)

```
proje/
├─ paper_figures/
│  ├─ make_data.py
│  ├─ run_all.sh
│  ├─ *.gp
│  └─ ...
└─ testler/                 ← log dosyaları buraya
   ├─ COOJA_20260505-150806_Nodes11.testlog
   ├─ COOJA_20260505-150813_Nodes11.testlog
   └─ ...
```

Bu yapıda `paper_figures/` içinden `python3 make_data.py` çalıştırabilirsin
— argüman vermene gerek yok, default `./testler/` çalışır.

## Dosyalar

### Python script (1)

| Dosya | Görev |
|---|---|
| `make_data.py` | Klasördeki tüm `.testlog`'ları okur, 15 `.dat` üretir |

### Veri dosyaları (15)

Her `.dat` dosyası 4 sütun: `time_min   mean   std   n_runs`

| Dosya | Metrik |
|---|---|
| `data_pdr.dat`              | UDP PDR (%) |
| `data_latency.dat`          | UDP avg latency (ms) |
| `data_udp_buf_drop.dat`     | Cumulative UDP buffer drops |
| `data_avg_va.dat`           | Average version age $\bar{\Delta}$ |
| `data_max_va.dat`           | Max version age |
| `data_adhoc_tx.dat`         | Cumulative ad-hoc TX frames |
| `data_adhoc_rx.dat`         | Cumulative ad-hoc RX frames |
| `data_control_overhead.dat` | RPL Total (DIO+DIS+DAO) |
| `data_power_total.dat`      | Total network power (mW) |
| `data_power_cpu.dat`        | CPU power |
| `data_power_lpm.dat`        | LPM power |
| `data_power_tx.dat`         | TX power |
| `data_power_rx.dat`         | RX power |
| `data_duty_cycle.dat`       | Radio duty cycle (%) = (TX+RX)/Total |
| `data_convergence.dat`      | first/last/avg convergence (tek değer) |

### Gnuplot scriptleri (12)

Her `.gp` aynı isimli `.eps` üretir.

| Dosya | Çıktı | Makaledeki yer |
|---|---|---|
| `pdr.gp`              | `pdr.eps`              | Subsec V.C |
| `latency.gp`          | `latency.eps`          | Subsec V.C |
| `udp_buf_drop.gp`     | `udp_buf_drop.eps`     | Subsec V.C |
| `avg_va.gp`           | `avg_va.eps`           | Subsec V.C |
| `max_va.gp`           | `max_va.eps`           | Subsec V.C |
| `adhoc_tx.gp`         | `adhoc_tx.eps`         | Subsec V.C |
| `adhoc_rx.gp`         | `adhoc_rx.eps`         | Subsec V.C |
| `control_overhead.gp` | `control_overhead.eps` | Subsec V.C |
| `power_total.gp`      | `power_total.eps`      | Subsec V.E |
| `power_breakdown.gp`  | `power_breakdown.eps`  | Subsec V.E |
| `duty_cycle.gp`       | `duty_cycle.eps`       | Subsec V.E |
| `convergence.gp`      | `convergence.eps`      | Subsec V.C |

### Yardımcı (2)

| Dosya | Görev |
|---|---|
| `run_all.sh` | `make_data.py` + tüm `.gp`'leri çalıştırır |
| `README.md`  | Bu dosya |

## Stil

Tüm `.gp` dosyaları, makaledeki `speed_8.gp` ile aynı stili kullanıyor:

- **Çıktı:** EPS (Helvetica 16-20)
- **Renk paleti:** `#FF0000` `#0000FF` `#00AA00` `#800080`
- **Lejant:** `box opaque`
- **Hata barları:** mean ± std (n=5 runs)

## Makaleye nasıl eklenir

```latex
\begin{figure}[!t]
\centering
\includegraphics[scale=0.55]{pdr.eps}
\caption{UDP Packet Delivery Ratio over time (n=5 runs).}
\label{fig:pdr}
\end{figure}
```

## Toplam dosya sayısı

- 15 `.dat`
- 12 `.gp`
- 1 Python script (`make_data.py`)
- 1 bash script (`run_all.sh`)
- 1 README

→ **30 dosya, tek klasör.**
