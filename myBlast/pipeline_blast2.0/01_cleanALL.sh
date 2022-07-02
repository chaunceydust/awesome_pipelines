#!/usr/bin/bash
set -exuo pipefail

WD=$(dirname $PWD)

rm -rf $WD/00_BlastDB/[^db]*

rm -rf $WD/01_sequences/*.fasta

rm -rf $WD/02_blast_result/*.blastp

rm -rf $WD/03_ori_anno*/*
