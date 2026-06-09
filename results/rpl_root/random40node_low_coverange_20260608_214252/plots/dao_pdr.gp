# Run: gnuplot dao_pdr.gp  (PNG written to plots/dao_pdr.png)
set terminal pngcairo size 900,500 enhanced font 'Arial,11'
set output 'dao_pdr.png'
set title 'DAO PDR (%) per run - random40node_low_coverange'
set ylabel 'DAO PDR (%)'
set xlabel 'Seed'
set yrange [0:100]
set grid ytics
set style fill solid 0.8 border -1
set boxwidth 0.6
set datafile missing "NaN"
plot '../summary.dat' using 5:xtic(2) with histograms title 'dao_pdr' lc rgb '#2ca02c'
