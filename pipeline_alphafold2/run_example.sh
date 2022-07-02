#!/usr/bin/env bash

#### online version of RoseTTAFold: https://robetta.bakerlab.org/

#### FastaPath: 'Path to a directory that stored the fasta sequences.'
FastaPath=./FASTA/example

#### Output: 'name to a directory that will store the results.'
Output=dummy_test

#### 'Maximum template release date to consider (ISO-8601 format: YYYY-MM-DD). '
#### 'Important if folding historical test sets.'
max_template_date=2020-05-14

bash run_temple.sh -f $FastaPath -o $Output -t $max_template_date

echo "CPUg244" | sudo -S chown -R lijing ${PWD}/RESULT/$Output
echo "CPUg244" | sudo -S chgrp -R lijing ${PWD}/RESULT/$Output


# lijing@:/home/nvme0$ du -ah --max-depth=1 alphafold_project/RESULT/SZW/
# 290M    alphafold_project/RESULT/SZW/L.delbrueckiind02-T2
# 289M    alphafold_project/RESULT/SZW/L.mucosae_dsm_13345-T2
# 289M    alphafold_project/RESULT/SZW/L.ruminis_atcc_25644-T2
# 286M    alphafold_project/RESULT/SZW/L.delbrueckii-T2
# 258M    alphafold_project/RESULT/SZW/L.paracasei_atcc_334-T0
# 283M    alphafold_project/RESULT/SZW/L.salivarius_dsm_20555_atcc_11741-T3
# 300M    alphafold_project/RESULT/SZW/L.amylovorus-T3
# 285M    alphafold_project/RESULT/SZW/L.animalis-T2
# 273M    alphafold_project/RESULT/SZW/L.rhamnosus_gg-T0
# 285M    alphafold_project/RESULT/SZW/L.salivarius_dsm_20555_atcc_11741-T0
# 299M    alphafold_project/RESULT/SZW/L.gasseri-T3
# 288M    alphafold_project/RESULT/SZW/L.reuteri-T3
# 299M    alphafold_project/RESULT/SZW/L.sakei_subsp_ATCC_15521-T0
# 269M    alphafold_project/RESULT/SZW/L.fermentum-T0
# 3.9G    alphafold_project/RESULT/SZW/
