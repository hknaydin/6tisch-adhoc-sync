reset
set terminal postscript eps enhanced color solid linewidth 1.5 "Helvetica,16"
set output "control_overhead.eps"

dsf = "#FF0000"

set xlabel "Simulation time (min)"            font "Helvetica,20"
set ylabel "Cumulative RPL control frames"    font "Helvetica,20"
set xrange [0:65]
set yrange [0:5000]
set xtics 10  font "Helvetica,16"
set ytics 500 font "Helvetica,16"
set grid xtics ytics

set key left top box opaque
set key spacing 1.4 font "Helvetica,15"

set title "Control Overhead (DIO+DIS+DAO, n=5 runs)" font "Helvetica,18"

plot "data_control_overhead.dat" using 1:2:3 with errorlines \
        lc rgb dsf lw 3 pt 7 ps 1.4 \
        title "RPL Total (mean +- std)"
unset output
