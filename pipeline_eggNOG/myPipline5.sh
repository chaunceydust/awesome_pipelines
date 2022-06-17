#!/bin/bash

#### GO: (http://geneontology.org/docs/download-ontology/)
#### go.basic.obo: (http://purl.obolibrary.org/obo/go/go-basic.obo)
#### parse_go_obofile.py: (https://github.com/Hua-CM/HuaSmallTools/blob/master/parse/parse_go_obofile.py)
#### parse_eggNOG.py: (https://github.com/Hua-CM/HuaSmallTools/tree/master/parse)

wget -c http://purl.obolibrary.org/obo/go/go-basic.obo
python parse_go_obofile.py -i go-basic.obo -o go.tb

python parse_eggNOG.py -i out.emapper.annotations -g go.tb -O cal,caur,mgl,mrt -o parsed.emapper.annotations
https://www.genome.jp/kaas-bin/kaas_org
