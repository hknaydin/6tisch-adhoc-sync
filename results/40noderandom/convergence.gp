reset
set terminal postscript eps enhanced color solid linewidth 1.5 "Helvetica,16"
set output "convergence.eps"

umay = "#800080"

set style data histogram
set style histogram errorbars gap 1.5 lw 2
set style fill solid 1.0 border -1
set boxwidth 0.8

set ylabel "Convergence time (s)"  font "Helvetica,20"
set yrange [0:2800]
set ytics 200 font "Helvetica,16"
set xtics font "Helvetica,16"
set grid ytics

set key right top box opaque
set key spacing 1.4 font "Helvetica,15"

set title "Convergence Time Statistics (n=5 runs)" font "Helvetica,18"

# data_convergence.dat sutunlar:
#   1=metric_name, 2=mean, 3=std, 4=n_runs
plot "data_convergence.dat" using 2:3:xtic(1) \
        lc rgb umay title "Mean +- std"
unset output
