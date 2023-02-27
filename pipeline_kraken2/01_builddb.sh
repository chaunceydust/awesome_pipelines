#!/bin/bash


DBNAME=~/Downloads/db/kraken2/nr2
[ ! -d $DBNAME ] && mkdir -p $DBNAME
cd $DBNAME

# kraken2-build --download-taxonomy --threads 50 --db $DBNAME

# kraken2-build --download-library nr --threads 64 --db $DBNAME --protein
#### Downloading nr database from server... done.
#### Uncompressing nr database...done.
#### Parsing nr FASTA file...done.
#### Masking low-complexity regions of downloaded library... done.
#### 
#### real    2301m30.084s
#### user    1979m28.591s
#### sys     93m54.576s


kraken2-build --build --threads 32 --db $DBNAME
#### Creating sequence ID to taxonomy ID map (step 1)...
#### Found 7912/770454036 targets, searched through 807570859 accession IDs, search complete.
#### lookup_accession_numbers: 770446124/770454036 accession numbers remain unmapped, see unmapped.txt in DB directory
#### Sequence ID to taxonomy ID map complete. [1h25m17.191s]
#### Estimating required capacity (step 2)...
#### Estimated hash table requirement: 95490737004 bytes
#### Capacity estimation complete. [11m46.272s]
#### Building database files (step 3)...
#### Taxonomy parsed and converted.
#### CHT created with 11 bits reserved for taxid.
#### Completed processing of 5488 sequences, 1652790 aa
#### Writing data to disk...  complete.
#### Database files completed. [15m23.286s]
#### Database construction complete. [Total: 1h52m26.897s]
#### 
#### real    112m26.985s
#### user    408m14.599s
#### sys     57m28.167s
