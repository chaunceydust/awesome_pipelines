# # All time points
# K = 14
for i in {1..100}
do
  echo "Rscript run_cormotif.R ../data/table-s1.txt ../data/annotation.txt 14 $i -o ../data/cormotif" | qsub -l h_vmem=4g -cwd -N cormotif.all.$i -j y -V
done

# K = 6
for i in {1..100}
do
  echo "Rscript run_cormotif.R ../data/table-s1.txt ../data/annotation.txt 6 $i -o ../data/cormotif" | qsub -l h_vmem=4g -cwd -N cormotif.all.$i -j y -V
done

# 18 hour time point
# K = 5
for i in {1..100}
do
  echo "Rscript run_cormotif.R ../data/table-s1.txt ../data/annotation.txt 5 $i -o ../data/cormotif -t 18" | qsub -l h_vmem=4g -cwd -N cormotif.18.$i -j y -V
done

# 48 hour time point
# K = 5
for i in {1..100}
do
  echo "Rscript run_cormotif.R ../data/table-s1.txt ../data/annotation.txt 5 $i -o ../data/cormotif -t 48" | qsub -l h_vmem=4g -cwd -N cormotif.48.$i -j y -V
done
