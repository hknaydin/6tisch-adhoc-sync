#!/usr/bin/env bash
# ============================================================
# run_all.sh - Tum .eps dosyalarini uretir
#
# Kullanim:
#   bash run_all.sh                    # default: ./testler/
#   bash run_all.sh /path/to/logs      # ozel klasor
# ============================================================

set -e

LOGS_DIR="${1:-./testler}"

echo "=> Veri dosyalari uretiliyor..."
echo "   log klasor: $LOGS_DIR"
python3 make_data.py "$LOGS_DIR"

echo
echo "=> Gnuplot scriptleri calistiriliyor..."
for gp in pdr.gp latency.gp udp_buf_drop.gp \
          avg_va.gp max_va.gp \
          adhoc_tx.gp adhoc_rx.gp control_overhead.gp \
          power_total.gp power_breakdown.gp duty_cycle.gp \
          convergence.gp; do
    if [ -f "$gp" ]; then
        echo "   gnuplot $gp"
        gnuplot "$gp"
    fi
done

echo
echo "=> Bitti. Uretilen .eps dosyalari:"
ls -1 *.eps
