reset
set terminal postscript eps enhanced color solid linewidth 1.5 "Helvetica,16"
set output "udp_buf_drop.eps"

dsf = "#FF0000"

set xlabel "Simulation time (min)"        font "Helvetica,20"
set ylabel "Cumulative UDP buffer drops"  font "Helvetica,20"
set xrange [0:65]
set yrange [0:2800]
set xtics 10  font "Helvetica,16"
set ytics 200 font "Helvetica,16"
set grid xtics ytics

set key left top box opaque
set key spacing 1.4 font "Helvetica,15"

set title "UDP Buffer Drops (n=5 runs)" font "Helvetica,18"

plot "data_udp_buf_drop.dat" using 1:2:3 with errorlines \
        lc rgb dsf lw 3 pt 7 ps 1.4 \
        title "BufferDrop (mean +- std)"
unset output
