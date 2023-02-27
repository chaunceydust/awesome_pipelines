#!/bin/bash

# DBNAME=~/Downloads/db/kraken2/bacteria
# DBNAME=~/Downloads/db/kraken2/fungi
DBNAME=~/Downloads/db/kraken2/archaea
[ ! -d $DBNAME ] && mkdir -p $DBNAME
cd $DBNAME


# kraken2-build --download-taxonomy --threads 50 --db $DBNAME
#### Downloading nucleotide gb accession to taxon map... done.
#### Downloading nucleotide wgs accession to taxon map... done.
#### Downloaded accession to taxon map(s)
#### Downloading taxonomy tree data... done.
#### Uncompressing taxonomy data... done.
#### Untarring taxonomy tree data... done.

# kraken2-build --download-library bacteria --threads 64 --db $DBNAME
#### Step 1/2: Performing rsync file transfer of requested files
#### Rsync file transfer complete.
#### Step 2/2: Assigning taxonomic IDs to sequences
#### Processed 27834 projects (65392 sequences, 115.43 Gbp)... done.
#### All files processed, cleaning up extra sequence files... done, library complete.
#### Masking low-complexity regions of downloaded library... done.
#### 
#### real    1936m15.194s
#### user    541m0.547s
#### sys     30m1.850s

# kraken2-build --download-library fungi --threads 66 --db $DBNAME
#### Step 1/2: Performing rsync file transfer of requested files
#### Rsync file transfer complete.
#### Step 2/2: Assigning taxonomic IDs to sequences
#### Processed 74 projects (1670 sequences, 1.73 Gbp)... done.
#### All files processed, cleaning up extra sequence files... done, library complete.
#### Masking low-complexity regions of downloaded library... done.

kraken2-build --download-library  archaea --threads 64 --db $DBNAME

#### Step 1/2: Performing rsync file transfer of requested files
#### Rsync file transfer complete.
#### Step 2/2: Assigning taxonomic IDs to sequences
#### Processed 419 projects (713 sequences, 1.14 Gbp)... done.
#### All files processed, cleaning up extra sequence files... done, library complete.
#### Masking low-complexity regions of downloaded library... done.

# 确定的库建索引
# kraken2-build --build --threads 24 --db $DBNAME
#### Creating sequence ID to taxonomy ID map (step 1)...
#### Sequence ID to taxonomy ID map complete. [0.135s]
#### Estimating required capacity (step 2)...
#### Estimated hash table requirement: 51480925620 bytes
#### Capacity estimation complete. [16m5.946s]
#### Building database files (step 3)...
#### Taxonomy parsed and converted.
#### CHT created with 14 bits reserved for taxid.
#### Completed processing of 65392 sequences, 115425685176 bp
#### Writing data to disk...  complete.
#### Database files completed. [29h2m13.837s]
#### Database construction complete. [Total: 29h18m20.229s]
#### 
#### real    1758m20.993s
#### user    17136m27.735s
#### sys     1504m32.291s

#### Creating sequence ID to taxonomy ID map (step 1)...
#### Sequence ID to taxonomy ID map complete. [0.022s]
#### Estimating required capacity (step 2)...
#### Estimated hash table requirement: 2689367768 bytes
#### Capacity estimation complete. [19.148s]
#### Building database files (step 3)...
#### Taxonomy parsed and converted.
#### CHT created with 8 bits reserved for taxid.
#### Completed processing of 1670 sequences, 1731336520 bp
#### Writing data to disk...  complete.
#### Database files completed. [19m41.419s]
#### Database construction complete. [Total: 20m0.614s]
