#!/usr/bin/env bash
set -e

myScript="/home/zhouxingchen/miniconda3/envs/funannotate/bin"

$myScript/funannotate setup -i all --busco_db all --database ~/DATABASE/funannotate_db
