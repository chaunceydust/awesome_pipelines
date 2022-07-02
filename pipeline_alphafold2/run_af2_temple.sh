#!/usr/bin/env bash

usage()
{
cat <<EOF >&2
Usage:
    $(basename "${BASH_SOURCE[0]}") [-h] [-v] -f arg1 -o arg2 -t 2020-05-14

------------------------------------------------------------------------------------
Filename: 
Revision: 1.0
Author:   chauncey zhou
Date:     2022.05.07
Email:    zhouxingchen5678@163.com
------------------------------------------------------------------------------------

Available options:

-h   Print this help and exit
-v   Print script debug info
-f
-t

Example:
    $(basename "${BASH_SOURCE[0]}") [-h] [-v] -f ./FASTA/example -o dummy_test -t 2020-05-14
EOF

exit

}


parse_params() {
  # default values of variables set from params
  
  # Default environment name.
  ENV=alphafold_docker
  
  # Conda directory name.
  CONDA_DIR=/home/nvme0/miniconda3
  
  # all required data for AlphaFold2 (AF2).
  AF2_db=/home/nvme0/data/alphafold_data


  while getopts "f:o:t:v:h" OPTION
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
          v)
              set -x
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

  args=("$@")

  # check required params and arguments
  [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

  return 0
}

parse_params "$@"


# The conda shell cannot be run in strict mode.
set +ue

# Apply the environment.
source ${CONDA_DIR}/etc/profile.d/conda.sh

# Activate the environment.
conda activate ${ENV}

# Reenable strict error checking.
# set -eu

my_output_dir=${PWD}"/RESULT/"${myDir}
[ ! -d $my_output_dir ] && mkdir -p $my_output_dir
:>$my_output_dir/${myDir}.log
echo -e "\033[32m# \033[0m" 2>&1 | tee -a $my_output_dir/${myDir}.log
echo -e "\033[32m# Input sequence direictory: $myFastaPath \033[0m" 2>&1 | tee -a $my_output_dir/${myDir}.log
echo -e "\033[32m# Output direictory: $my_output_dir \033[0m" 2>&1 | tee -a $my_output_dir/${myDir}.log
echo -e "\033[32m#\n \033[0m" 2>&1 | tee -a $my_output_dir/${myDir}.log


declare -i myorder=0
for seq in $(ls $myFastaPath)
do
        let myorder++
	my_fasta_path=$(readlink -e $myFastaPath/$seq)
        echo -e "\033[32m# \033[0m" 2>&1 | tee -a $my_output_dir/${myDir}.log
        echo -e "\033[32m# Task $myorder \033[0m" 2>&1 | tee -a $my_output_dir/${myDir}.log
	echo -e "\033[32m######### start running $seq($(date))  ######### \033[0m" 2>&1 | tee -a $my_output_dir/${myDir}.log
	echo -e "\033[32m#\n \033[0m" 2>&1 | tee -a $my_output_dir/${myDir}.log

 	time python3 /home/nvme0/alphafold/docker/run_docker.py \
 		--docker_image_name=chaunceyzhou/alphafold-galaxy:v1.0 \
 		--fasta_paths=$my_fasta_path \
 		--db_preset=full_dbs \
 		--max_template_date=$my_max_template_date \
 		--data_dir=$AF2_db \
 		--output_dir=$my_output_dir \
 		--model_preset=monomer 2>&1 | tee -a $my_output_dir/${myDir}.log
done
