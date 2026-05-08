reset
set terminal postscript eps enhanced color solid linewidth 1.5 "Helvetica,16"
set output "power_breakdown.eps"

dsf   = "#FF0000"   # RX
msf   = "#0000FF"   # CPU
detas = "#00AA00"   # LPM
umay  = "#800080"   # TX

set xlabel "Simulation time (min)"   font "Helvetica,20"
set ylabel "Power (mW)"              font "Helvetica,20"
set xrange [0:65]
set yrange [0:8]
set xtics 10 font "Helvetica,16"
set ytics 1  font "Helvetica,16"
set grid xtics ytics

set key right top box opaque
set key spacing 1.4 font "Helvetica,15"

set title "Power Breakdown by Component (n=5 runs)" font "Helvetica,18"

plot "data_power_rx.dat"  using 1:2:3 with errorlines lc rgb dsf   lw 3 pt 7  ps 1.3 title "P_{RX}", \
     "data_power_cpu.dat" using 1:2:3 with errorlines lc rgb msf   lw 3 pt 5  ps 1.3 title "P_{CPU}", \
     "data_power_tx.dat"  using 1:2:3 with errorlines lc rgb umay  lw 3 pt 9  ps 1.3 title "P_{TX}", \
     "data_power_lpm.dat" using 1:2:3 with errorlines lc rgb detas lw 3 pt 11 ps 1.3 title "P_{LPM}"
unset output
