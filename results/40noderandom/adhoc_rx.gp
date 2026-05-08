reset
set terminal postscript eps enhanced color solid linewidth 1.5 "Helvetica,16"
set output "adhoc_rx.eps"

detas = "#00AA00"

set xlabel "Simulation time (min)"        font "Helvetica,20"
set ylabel "Cumulative ad-hoc RX frames"  font "Helvetica,20"
set xrange [0:65]
set yrange [0:58048]
set xtics 10    font "Helvetica,16"
set ytics 5000  font "Helvetica,16"
set grid xtics ytics

set key left top box opaque
set key spacing 1.4 font "Helvetica,15"

set title "Cumulative Ad-Hoc RX (n=5 runs)" font "Helvetica,18"

plot "data_adhoc_rx.dat" using 1:2:3 with errorlines \
        lc rgb detas lw 3 pt 7 ps 1.4 \
        title "Adhoc RX (mean +- std)"
unset output
