#!/usr/bin/env bash

#### online version of RoseTTAFold: https://robetta.bakerlab.org/

#### FastaPath: 'Path to a directory that stored the fasta sequences.'
FastaPath=./FASTA/example

#### Output: 'name to a directory that will store the results.'
Output=dummy_test

#### 'Maximum template release date to consider (ISO-8601 format: YYYY-MM-DD). '
#### 'Important if folding historical test sets.'
max_template_date=2020-05-14

bash run_af2_temple.sh -f $FastaPath -o $Output -t $max_template_date

# echo "CPUg244" | sudo -S chown -R lijing ${PWD}/RESULT/$Output
# echo "CPUg244" | sudo -S chgrp -R lijing ${PWD}/RESULT/$Output

sudo groupadd G1
sudo usermod -aG G1 $USER
newgrp G1

echo "CPUg244" | sudo -S chown -R "$USER":"$USER" "${PWD}/RESULT/$Output"
echo "CPUg244" | sudo -S chmod -R g+rwx "${PWD}/RESULT/$Output"
