reset
set terminal postscript eps enhanced color solid linewidth 1.5 "Helvetica,16"
set output "adhoc_tx.eps"

umay = "#800080"
red  = "#CC0000"

set xlabel "Simulation time (min)"        font "Helvetica,20"
set ylabel "Cumulative ad-hoc TX frames"  font "Helvetica,20"
set xrange [0:65]
set yrange [0:16500]
set xtics 10    font "Helvetica,16"
set ytics 2000  font "Helvetica,16"
set grid xtics ytics

set key left top box opaque
set key spacing 1.4 font "Helvetica,15"

set title "Cumulative Ad-Hoc TX (n=5 runs)" font "Helvetica,18"

# Std degerlerini ok ile noktalara isaret etmek icin:
# - 1. seri:  errorlines (normal grafik)
# - 2. seri:  vectors    (ok cizimi: noktanin 1700 ustunden noktaya)
# - 3. seri:  labels     (std metni: noktanin 1900 ustunde)

plot \
  "data_adhoc_tx.dat" using 1:2:3 with errorlines \
        lc rgb umay lw 3 pt 7 ps 1.4 \
        title "Adhoc TX (mean +- std)", \
  "data_adhoc_tx.dat" using 1:($2+1700):(0):(-1500) with vectors \
        filled head size screen 0.012,15 lc rgb red lw 2 \
        notitle, \
  "data_adhoc_tx.dat" using 1:($2+1900):(sprintf("{/Symbol \\261}%.1f", $3)) with labels \
        font "Helvetica,12" tc rgb red \
        notitle

unset output
