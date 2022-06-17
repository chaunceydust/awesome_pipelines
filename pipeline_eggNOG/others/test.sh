#!/bin/bash

cat kegg_pathway.txt | sed '1d' | awk -F"\t" '{print $3}' | sort | uniq -c | awk '{printf("%s\t%s\n", $2, $1)}' | sort -t $'\t' -k 2nr | sed '1 ipathway_id\tpathway_num' > kegg_pathway_num.txt
