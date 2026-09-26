# Run: gnuplot pdr_vs_dao.gp
set terminal pngcairo size 1000,500 enhanced font 'Arial,11'
set output 'pdr_vs_dao.png'
set title 'DATA PDR vs DAO PDR - random50node_high_coverange'
set ylabel 'PDR (%)'
set xlabel 'Seed'
set yrange [0:100]
set grid ytics
set style data histograms
set style histogram clustered gap 1
set style fill solid 0.8 border -1
set boxwidth 0.9
set datafile missing "NaN"
plot '../summary.dat' using 3:xtic(2) title 'DATA PDR' lc rgb '#1f77b4', \
     ''                using 5         title 'DAO PDR'  lc rgb '#2ca02c'
