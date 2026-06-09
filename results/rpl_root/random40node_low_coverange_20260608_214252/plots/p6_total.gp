# Run: gnuplot p6_total.gp  (PNG written to plots/p6_total.png)
set terminal pngcairo size 900,500 enhanced font 'Arial,11'
set output 'p6_total.png'
set title '6P Total Transactions per run - random40node_low_coverange'
set ylabel '6P Total Transactions'
set xlabel 'Seed'
set yrange [*:*]
set grid ytics
set style fill solid 0.8 border -1
set boxwidth 0.6
set datafile missing "NaN"
plot '../summary.dat' using 10:xtic(2) with histograms title 'p6_total' lc rgb '#9467bd'
