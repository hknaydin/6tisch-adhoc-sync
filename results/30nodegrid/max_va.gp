reset
set terminal postscript eps enhanced color solid linewidth 1.5 "Helvetica,16"
set output "max_va.eps"

dsf = "#FF0000"
blue = "#0000DD"

set xlabel "Simulation time (min)"        font "Helvetica,20"
set ylabel "Max version age {/Symbol D}"  font "Helvetica,20"
set xrange [0:70]
set yrange [0:500]
set xtics 10  font "Helvetica,16"
set ytics 50  font "Helvetica,16"
set grid xtics ytics

set key left top box opaque
set key spacing 1.4 font "Helvetica,15"

set title "Worst-Case Version Age (n=5 runs)" font "Helvetica,18"

# 3 seri:
#   1) errorlines (kirmizi)             - normal grafik
#   2) vectors    (mavi ok)             - etiketten noktaya geri ok
#   3) labels     (mavi std metni)      - noktanin sag-altinda
plot \
  "data_max_va.dat" using 1:2:3 with errorlines \
        lc rgb dsf lw 3 pt 7 ps 1.4 \
        title "Max {/Symbol D} (mean +- std)", \
  "data_max_va.dat" using ($1+3.5):($2-55):(-3.5):(55) with vectors \
        filled head size screen 0.012,15 lc rgb blue lw 2 \
        notitle, \
  "data_max_va.dat" using ($1+3.7):($2-58):(sprintf("{/Symbol \\261}%.2f", $3)) with labels \
        font "Helvetica,12" tc rgb blue left \
        notitle

unset output
