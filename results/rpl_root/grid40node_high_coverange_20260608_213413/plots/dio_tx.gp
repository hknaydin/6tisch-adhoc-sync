# Run: gnuplot dio_tx.gp  (PNG written to plots/dio_tx.png)
set terminal pngcairo size 900,500 enhanced font 'Arial,11'
set output 'dio_tx.png'
set title 'DIO Tx per run - grid40node_high_coverange'
set ylabel 'DIO Tx'
set xlabel 'Seed'
set yrange [*:*]
set grid ytics
set style fill solid 0.8 border -1
set boxwidth 0.6
set datafile missing "NaN"
plot '../summary.dat' using 11:xtic(2) with histograms title 'dio_tx' lc rgb '#8c564b'
