reset
set terminal postscript eps enhanced color solid linewidth 1.5 "Helvetica,16"
set output "duty_cycle.eps"

detas = "#00AA00"

set xlabel "Simulation time (min)"   font "Helvetica,20"
set ylabel "Radio duty cycle (\%)"   font "Helvetica,20"
set xrange [0:65]
set yrange [0:70]
set xtics 10 font "Helvetica,16"
set ytics 10 font "Helvetica,16"
set grid xtics ytics

set key right top box opaque
set key spacing 1.4 font "Helvetica,15"

set title "Radio Duty Cycle (n=5 runs)" font "Helvetica,18"

plot "data_duty_cycle.dat" using 1:2:3 with errorlines \
        lc rgb detas lw 3 pt 7 ps 1.4 \
        title "(TX+RX) / Total (mean +- std)"
unset output
