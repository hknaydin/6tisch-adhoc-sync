reset
set terminal postscript eps enhanced color solid linewidth 1.5 "Helvetica,16"
set output "avg_va.eps"

umay = "#800080"
dsf  = "#FF0000"

set xlabel "Simulation time (min)"        font "Helvetica,20"
set ylabel "Avg. version age {/Symbol D}" font "Helvetica,20"
set xrange [0:65]
set yrange [0:2.2]
set xtics 10  font "Helvetica,16"
set ytics 0.5 font "Helvetica,16"
set grid xtics ytics

set key right top box opaque
set key spacing 1.4 font "Helvetica,15"

set title "Average Version Age (n=5 runs)" font "Helvetica,18"

plot "data_avg_va.dat" using 1:2:3 with errorlines \
        lc rgb umay lw 3 pt 7 ps 1.4 \
        title "Mean +- std", \
     2 with lines lc rgb dsf lw 2 dt 2 \
        title "Paper claim: < 2 versions"
unset output
