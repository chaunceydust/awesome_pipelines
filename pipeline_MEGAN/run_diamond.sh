#!/usr/bin/env  bash


workdir=$PWD
DIAMOND=/home/zhouxingchen/miniconda3/bin

for m in AMR2 AMR3 Aus Aut DEN EBH1D Fra JPN KOR Sweden Ger HADZA Ita PAS PCRC_gut PCRC_nm1 PCRC_plos PHT PIBD POB PSkinCN 
# for m in Peru AMR EBH2
do
echo $m START `date`
    $DIAMOND/diamond blastp \
        --db /home/Metagenome/Ref_Database/NR-20211111-BLAST/nr_fungi_20220420 \
        --query $workdir/$m/7_Total_Uniq_Gene_fungi/Total.uniq.pep.fa \
        --daa $workdir/$m/7_Total_Uniq_Gene_fungi/Total.uniq.pep.daa \
        --sensitive \
        --max-target-seqs 500 \
        --evalue 1e-5 \
        --id 20 \
        --block-size 100.0 \
        --index-chunks 1 \
        --tmpdir /dev/shm
echo $m END `date`
done    


# /home/zhouxingchen/miniconda3/bin/diamond blastp --db /home/Metagenome/Ref_Database/NR-20211111-BLAST/nr_fungi_20220420 --query Total.uniq.pep.fa -c 1 --daa Total.uniq.pep.daa --sensitive --max-target-seqs 500 --evalue 1e-5 --id 20 --tmpdir /dev/shm

# real    18m28.817s
# user    1779m3.154s
# sys     441m34.464s
