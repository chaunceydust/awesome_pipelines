#!/usr/bin/env bash
# set -e

# set -exuo pipefail

usage()
{
cat <<EOF >&2
Usage:
    bash $0 -f ./FASTA/SZW/tt -o SZW -t 2020-05-14

OPTIONS:
    -d database file(the list of individual target protein sequences file with full path, each per line.), default dat
abase.list
    -q query file, recommend must give
    -h/? show help of script
Example:
    bash $0 -f ./FASTA/SZW/tt -o SZW -t 2020-05-14
EOF
}

while getopts "f:o:t:h" OPTION
do
    case $OPTION in
        f)
            myFastaPath=$OPTARG
            ;;
        o)
            myDir=$OPTARG
            ;;
        t)
            my_max_template_date=$OPTARG
	    ;;
        h)
            usage
            exit 1
            ;;
        ?)
            usage
            exit 1
            ;;
    esac
done

my_output_dir=${PWD}"/RESULT/"${myDir}
[ ! -d $my_output_dir ] && mkdir -p $my_output_dir
echo $my_output_dir

source /home/nvme0/miniconda3/bin/activate
conda activate alphafold_docker

:>$my_output_dir/${myDir}.log

for seq in $(ls $myFastaPath)
do
	my_fasta_path=$(readlink -e $myFastaPath/$seq)
	echo $my_fasta_path
	echo -e "\033[32m######### start running $seq($(date))  ######### \033[0m" >> $my_output_dir/${myDir}.log
	echo -e "\n" >> $my_output_dir/${myDir}.log

	time python3 /home/nvme0/alphafold/docker/run_docker.py \
		--docker_image_name=neoformit/alphafold-galaxy \
		--fasta_paths=$my_fasta_path \
		--db_preset=full_dbs \
		--max_template_date=$my_max_template_date \
		--data_dir=/home/nvme0/data/alphafold_data \
		--output_dir=$my_output_dir \
		--model_preset=monomer 2>&1 | tee -a $my_output_dir/${myDir}.log
done
