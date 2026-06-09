# Run: gnuplot latency.gp  (PNG written to plots/latency.png)
set terminal pngcairo size 900,500 enhanced font 'Arial,11'
set output 'latency.png'
set title 'Latency (ms) per run - random30node_high_coverange'
set ylabel 'Latency (ms)'
set xlabel 'Seed'
set yrange [*:*]
set grid ytics
set style fill solid 0.8 border -1
set boxwidth 0.6
set datafile missing "NaN"
plot '../summary.dat' using 4:xtic(2) with histograms title 'latency' lc rgb '#ff7f0e'
