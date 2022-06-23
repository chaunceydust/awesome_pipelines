#!/bin/bash
set -e

# Concatenate files so that all reads for a sample are in one file
# (804 -> 156 files)

DIR="/media/Seagate Backup Plus Drive/DATA/flow_cells/jdblischak@uchicago.edu"

# This takes a long time. Do each individual one at a time so that it can be
# parallelized across shells (I did this on my computer and not the cluster).
for ind in M372 # M373 M374 M375 M376 M377
do
  for bact in none Rv Rv+ GC BCG Smeg Yers Salm Staph
  do
    for time in 4 18 48
    do
      echo $ind-$bact-$time
      zcat $DIR/$ind-$bact-$time-* > $DIR/$ind-$bact-$time.fastq
      gzip $DIR/$ind-$bact-$time.fastq
      rm $DIR/$ind-$bact-$time-*gz
      ls $DIR/$ind-$bact-$time*
    done
  done 
done

# Remove empty Staph-48 files
rm $DIR/*Staph-48*

# md5checksum new files
md5sum $DIR/*fastq.gz > ../data/md5sum_combined.txt

# Confirm that each file only contains one index
for f in $DIR/*fastq.gz
do
  echo $f
  echo $f >> ../data/index.txt
  zcat $f | grep "@" | cut -d"#" -f2 | sort | uniq >> $DIR/index.txt
done

wc -l $DIR/index.txt
# 312 index.txt
