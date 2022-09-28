#!/usr/bin/env bash

for i in *.faa
do
  name=$(basename $i .faa)
  for H in sequence.hmm
  do
    hmmsearch \
      -E 1e-5 \
      --cpu 20 \
      -o ${name}.hmm.out \
      --tblout ${name}.hmm.tblout \
      --domtblout ${name}.hmm.domtblout \
      --pfamtblout ${name}.hmm.pfamtblout \
      $H $i
      
  done
done
