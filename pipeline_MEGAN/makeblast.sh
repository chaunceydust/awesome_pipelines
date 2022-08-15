# for i in fungi bacteria archaea virus;
for i in animal plant;
do
        makeblastdb -in nr_${i}.fasta \
                    -dbtype prot \
                    -blastdb_version 5 \
                    -parse_seqids \
                    -title nr_${i} \
                    -out nr_${i}_`date +%Y%m%d` \
                    -logfile nr_${i}_`date +%Y%m%d`.log
done

# bacteria
# $ time bash makeblast.sh
# 
# real    471m51.564s
# user    959m58.449s
# sys     59m56.889s
