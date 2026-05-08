reset
set terminal postscript eps enhanced color solid linewidth 1.5 "Helvetica,16"
set output "power_total.eps"

umay = "#800080"

set xlabel "Simulation time (min)"               font "Helvetica,20"
set ylabel "Average network power (mW)"          font "Helvetica,20"
set xrange [0:65]
set yrange [0:30]
set xtics 10 font "Helvetica,16"
set ytics 1  font "Helvetica,16"
set grid xtics ytics

set key right top box opaque
set key spacing 1.4 font "Helvetica,15"

set title "Total Power Consumption (n=5 runs)" font "Helvetica,18"

plot "data_power_total.dat" using 1:2:3 with errorlines \
        lc rgb umay lw 3 pt 7 ps 1.4 \
        title "P_{total} (mean +- std)"
unset output
