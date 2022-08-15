#!/usr/bin/env  bash

/home/zhouxingchen/miniconda3/bin/diamond blastp --db /home/Metagenome/Ref_Database/NR-20211111-BLAST/nr_fungi_20220420 --query Total.uniq.pep.fa -c 1 --daa Total.uniq.pep.daa --sensitive --max-target-seqs 500 --evalue 1e-5 --id 20 --tmpdir /dev/shm

# real    18m28.817s
# user    1779m3.154s
# sys     441m34.464s
