# Run: gnuplot pdr.gp  (PNG written to plots/pdr.png)
set terminal pngcairo size 900,500 enhanced font 'Arial,11'
set output 'pdr.png'
set title 'PDR (%) per run - grid30node_low_coverange'
set ylabel 'PDR (%)'
set xlabel 'Seed'
set yrange [0:100]
set grid ytics
set style fill solid 0.8 border -1
set boxwidth 0.6
set datafile missing "NaN"
plot '../summary.dat' using 3:xtic(2) with histograms title 'pdr' lc rgb '#1f77b4'
