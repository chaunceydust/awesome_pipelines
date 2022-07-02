#!/usr/bin/env bash

#### online version of RoseTTAFold: https://robetta.bakerlab.org/

#### FastaPath: 'Path to a directory that stored the fasta sequences.'
FastaPath=./FASTA/ZXC

#### Output: 'name to a directory that will store the results.'
Output=ZXC0303

#### 'Maximum template release date to consider (ISO-8601 format: YYYY-MM-DD). '
#### 'Important if folding historical test sets.'
max_template_date=2020-05-14

bash run_temple.sh -f $FastaPath -o $Output -t $max_template_date

echo "CPUg244" | sudo -S chown -R lijing ${PWD}/RESULT/$Output
echo "CPUg244" | sudo -S chgrp -R lijing ${PWD}/RESULT/$Output

