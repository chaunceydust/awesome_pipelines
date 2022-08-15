#!/usr/bin/env bash

/home/zhouxingchen/megan_6_22_2/tools/daa-meganizer -i Total.uniq.pep.daa -mdb /home/zhouxingchen/DATABASE/megan-map-Jan2021.db

# $ time sudo bash daa-meganizer.sh 
# Version   MEGAN Community Edition (version 6.22.2, built 10 Mar 2022)
# Author(s) Daniel H. Huson
# Copyright (C) 2022 Daniel H. Huson. This program comes with ABSOLUTELY NO WARRANTY.
# Java version: 17.0.2
# Functional classifications to use: EC, EGGNOG, GTDB, INTERPRO2GO, SEED
# Loading ncbi.map: 2,396,736
# Loading ncbi.tre: 2,396,740
# Loading ec.map:     8,200
# Loading ec.tre:     8,204
# Loading eggnog.map:    30,875
# Loading eggnog.tre:    30,986
# Loading gtdb.map:   240,103
# Loading gtdb.tre:   240,107
# Loading interpro2go.map:    14,242
# Loading interpro2go.tre:    28,907
# Loading seed.map:       961
# Loading seed.tre:       962
# Meganizing: Total.uniq.pep.daa
# Meganizing init
# Annotating DAA file using FAST mode (accession database and first accession per line)
# Annotating references
# 10% 20% 30% 40% 50% 100% (9.0s)
# Writing
# 10% 20% 30% 40% 50% 60% 70% 80% 90% 100% (0.5s)
# Binning reads Initializing...
# Initializing binning...
# Using 'Naive LCA' algorithm for binning: Taxonomy
# Using Best-Hit algorithm for binning: SEED
# Using Best-Hit algorithm for binning: EGGNOG
# Using 'Naive LCA' algorithm for binning: GTDB
# Using Best-Hit algorithm for binning: EC
# Using Best-Hit algorithm for binning: INTERPRO2GO
# Binning reads...
# Binning reads Analyzing alignments
# 10% 20% 30% 40% 50% 60% 70% 80% 90% 100% (486.2s)
# Total reads:          228,529
# With hits:             228,529 
# Alignments:         42,154,336
# Assig. Taxonomy:       206,300
# Assig. SEED:             3,940
# Assig. EGGNOG:               0
# Assig. GTDB:             2,866
# Assig. EC:              71,427
# Assig. INTERPRO2GO:    100,928
# MinSupport set to: 22
# Binning reads Applying min-support & disabled filter to Taxonomy...
# 10% 20% 30% 40% 50% 60% 70% 80% 90% 100% (0.7s)
# Min-supp. changes:         871
# Binning reads Applying min-support & disabled filter to GTDB...
# 10% 20% 30% 40% 50% 60% 70% 80% 90% 100% (0.3s)
# Min-supp. changes:           3
# Binning reads Writing classification tables
# 10% 20% 30% 40% 50% 60% 70% 80% 90% 100% (0.4s)
# Binning reads Syncing
# 100% (0.1s)
# Class. Taxonomy:           344
# Class. SEED:                50
# Class. EGGNOG:               1
# Class. GTDB:                10
# Class. EC:                 922
# Class. INTERPRO2GO:      4,297
# Total time:  509s
# Peak memory: 5.7 of 7.8G
# 
# real    8m33.339s
# user    15m54.086s
# sys     3m40.793s
