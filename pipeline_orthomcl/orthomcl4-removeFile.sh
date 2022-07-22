#!/bin/bash

WD=$(dirname $PWD)
WD=WD/orthomcl

cd $WD
rm diamond.xml
rm diamond.tab
rm goodProteins.dmnd
rm mclInput mclOutput
# rm similarSequences.txt
