reset
set terminal postscript eps enhanced color solid linewidth 1.5 "Helvetica,16"
set output "latency.eps"

dsf = "#FF0000"

set xlabel "Simulation time (min)" font "Helvetica,20"
set ylabel "Data latency (ms)"     font "Helvetica,20"
set xrange [0:65]
set yrange [0:1600]
set xtics 10  font "Helvetica,16"
set ytics 200 font "Helvetica,16"
set grid xtics ytics

set key right top box opaque
set key spacing 1.4 font "Helvetica,15"

set title "Average Data Latency (n=5 runs)" font "Helvetica,18"

plot "data_latency.dat" using 1:2:3 with errorlines \
        lc rgb dsf lw 3 pt 7 ps 1.4 \
        title "Latency (mean +- std)"
unset output
