database=/home/zhouxingchen/Downloads/database_16S/minikraken_8GB_20200312

for i in $(ls *.join.fna);
do
	kraken2 --db $database \
		--threads 80 \
		--report $(basename $i .join.fna).kreport2  \
		--output $(basename $i .join.fna).result2 \
		--unclassified-out $(basename $i .join.fna).unclassified.fa \
		--classified-out $(basename $i .join.fna).classified.fa  \
		$i | \
		tee $(basename $i .join.fna).log
		# --use-mpa-style \
		# $i

	awk '$1 == "C" && $3 != 0' $(basename $i .join.fna).result2 \
		| awk '{$0=$2 "\t"$3}1' \
		| sed '1i\asvid\tspid' > $(basename $i .join.fna).asvclass.txt

	python mappingArea.py $i $(basename $i .join.fna).csv

done
