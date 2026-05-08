reset
set terminal postscript eps enhanced color solid linewidth 1.5 "Helvetica,16"
set output "pdr.eps"

msf = "#0000FF"

set xlabel "Simulation time (min)" font "Helvetica,20"
set ylabel "UDP PDR (\%)"          font "Helvetica,20"
set xrange [0:65]
set yrange [0:80]
set xtics 10 font "Helvetica,16"
set ytics 10 font "Helvetica,16"
set grid xtics ytics

set key right bottom box opaque
set key spacing 1.4 font "Helvetica,15"

set title "UDP Packet Delivery Ratio (n=5 runs)" font "Helvetica,18"

plot "data_pdr.dat" using 1:2:3 with errorlines \
        lc rgb msf lw 3 pt 7 ps 1.4 \
        title "PDR (mean +- std)"
unset output
