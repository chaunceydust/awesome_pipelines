# esearch -db protein -query "SEC24A [PROT] NOT partial [All Fields]" | efetch -format fasta > proteins.fa
#### (SecA [protein name] OR "preprotein translocase subunit SecA" [protein name]) AND bacteria[filter] AND refseq[filter] NOT partial [All Fields]
#### ("name1"[Protein Name] OR "name2"[Protein Name]) AND bacteria[filter] NOT partial[All Fields] NOT plasmid[All Fields]

:>command.list
tail -n +3 REACTOME_METABOLISM_OF_LIPIDS_geneset.txt | while read id
do
	echo "esearch -db protein -query \"$id [PROT] NOT partial [All Fields]\" | efetch -format fasta > ${id}.fasta" >> command.list 
done
