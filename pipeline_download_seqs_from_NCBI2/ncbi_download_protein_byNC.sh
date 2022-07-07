# esearch -db protein -query "SEC24A [PROT] NOT partial [All Fields]" | efetch -format fasta > proteins.fa
#### (SecA [protein name] OR "preprotein translocase subunit SecA" [protein name]) AND bacteria[filter] AND refseq[filter] NOT partial [All Fields]
#### ("name1"[Protein Name] OR "name2"[Protein Name]) AND bacteria[filter] NOT partial[All Fields] NOT plasmid[All Fields]

:>command.list
echo "# " $(date) >> command.list

IFS_SAVE=$IFS
IFS=$'\t'

tail -n +3 nc_number.list | while read line
do
    #### format the file name according PROT's id
    temp=($line);
    filename=$(echo ${temp[0]} | tr \  _)
    echo -e ${temp[0]}"\t"$filename

    id=${temp[1]}
    echo "esearch -db protein -query \"${id}[EC/RN Number] AND bacteria[filter] NOT partial[All Fields] NOT plasmid[All Fields]\" | efetch -format fasta > ${filename}_bacteria.faa" >> command.list
    echo "esearch -db protein -query \"${id}[EC/RN Number] AND bacteria[filter] AND refseq[filter] NOT partial[All Fields] NOT plasmid[All Fields]\" | efetch -format fasta > ${filename}_bacteria_refseq.faa" >> command.list

    echo "esearch -db protein -query \"${id}[EC/RN Number] AND fungi[filter] NOT partial[All Fields] NOT plasmid[All Fields]\" | efetch -format fasta > ${filename}_fungi.faa" >> command.list
    echo "esearch -db protein -query \"${id}[EC/RN Number] AND fungi[filter] AND refseq[filter] NOT partial[All Fields] NOT plasmid[All Fields]\" | efetch -format fasta > ${filename}_fungi_refseq.faa" >> command.list

done
        
IFS=$IFS_SAVE

rm -rf sequences
[ ! -d sequences ] && mkdir -p sequences
mv command.list sequences
cd ./sequences

ParaFly -c command.list -CPU 20
# bash command.list 2>&1 | tee -a command.log
