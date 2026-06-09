# Run: gnuplot power_on.gp  (PNG written to plots/power_on.png)
set terminal pngcairo size 900,500 enhanced font 'Arial,11'
set output 'power_on.png'
set title 'Radio ON (%) per run - grid30node_high_coverange'
set ylabel 'Radio ON (%)'
set xlabel 'Seed'
set yrange [*:*]
set grid ytics
set style fill solid 0.8 border -1
set boxwidth 0.6
set datafile missing "NaN"
plot '../summary.dat' using 18:xtic(2) with histograms title 'power_on' lc rgb '#e377c2'
