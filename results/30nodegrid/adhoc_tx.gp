reset
set terminal postscript eps enhanced color solid linewidth 1.5 "Helvetica,16"
set output "adhoc_tx.eps"

umay = "#800080"
red  = "#CC0000"

set xlabel "Simulation time (min)"        font "Helvetica,20"
set ylabel "Cumulative ad-hoc TX frames"  font "Helvetica,20"
set xrange [0:70]
set yrange [0:12000]
set xtics 10    font "Helvetica,16"
set ytics 1500  font "Helvetica,16"
set grid xtics ytics

set key left top box opaque
set key spacing 1.4 font "Helvetica,15"

set title "Cumulative Ad-Hoc TX (n=5 runs)" font "Helvetica,18"

# 3 seri:
#   1) errorlines (mor)             - normal grafik
#   2) vectors    (kirmizi ok)      - etiketten noktaya geri ok
#   3) labels     (kirmizi std)     - noktanin sag-altinda
plot \
  "data_adhoc_tx.dat" using 1:2:3 with errorlines \
        lc rgb umay lw 3 pt 7 ps 1.4 \
        title "Adhoc TX (mean +- std)", \
  "data_adhoc_tx.dat" using ($1+3.5):($2-1100):(-3.5):(1100) with vectors \
        filled head size screen 0.012,15 lc rgb red lw 2 \
        notitle, \
  "data_adhoc_tx.dat" using ($1+3.7):($2-1150):(sprintf("{/Symbol \\261}%.2f", $3)) with labels \
        font "Helvetica,12" tc rgb red left \
        notitle

unset output
