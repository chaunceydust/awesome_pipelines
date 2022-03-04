# esearch -db protein -query "SEC24A [PROT] NOT partial [All Fields]" | efetch -format fasta > proteins.fa
#### (SecA [protein name] OR "preprotein translocase subunit SecA" [protein name]) AND bacteria[filter] AND refseq[filter] NOT partial [All Fields]
#### ("name1"[Protein Name] OR "name2"[Protein Name]) AND bacteria[filter] NOT partial[All Fields] NOT plasmid[All Fields]

:>command.list
echo "# " $(date) >> command.list
tail -n +3 glycosidase_geneset.txt | while read id
do
        #### format the file name according PROT's id
        filename=$(echo $id | tr \  _)
        echo -e ${id}"\t"$filename

        # echo "esearch -db protein -query \"$id [PROT] NOT partial [All Fields]\" | efetch -format fasta > ${id}.fasta" >> command.list
        echo "esearch -db protein -query \"$id [PROT] AND bacteria[filter] NOT partial[All Fields] NOT plasmid[All Fields]\" | efetch -format fasta > ${filename}_bacteria.faa" >> command.list
        echo "esearch -db protein -query \"$id [PROT] AND bacteria[filter] AND refseq[filter] NOT partial[All Fields] NOT plasmid[All Fields]\" | efetch -format fasta > ${filename}_bacteria_refseq.faa" >> command.list
        echo "esearch -db protein -query \"$id [PROT] AND fungi[filter] NOT partial[All Fields] NOT plasmid[All Fields]\" | efetch -format fasta > ${filename}_fungi.faa" >> command.list
        echo "esearch -db protein -query \"$id [PROT] AND fungi[filter] AND refseq[filter] NOT partial[All Fields] NOT plasmid[All Fields]\" | efetch -format fasta > ${filename}_fungi_refseq.faa" >> command.list
done

rm -rf sequences
[ ! -d sequences ] && mkdir -p sequences
mv command.list sequences
cd ./sequences

bash command.list 2>&1 | tee -a command.log
