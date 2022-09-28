#!/usr/bin/env python

from Bio import SeqIO

records = SeqIO.parse("THIS_IS_YOUR_INPUT_FILE.clustal", "clustal")
count = SeqIO.write(records, "THIS_IS_YOUR_OUTPUT_FILE.stockholm", "stockholm")
print("Converted %i records" % count)
