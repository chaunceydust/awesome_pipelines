
#prokka
cd /home/dell/dockers
docker load -i Prokka

#安装funannotate
# download/pull the image from docker hub
$ docker pull nextgenusfs/funannotate

# download bash wrapper script (optional)
$ wget -O funannotate-docker https://raw.githubusercontent.com/nextgenusfs/funannotate/master/funannotate-docker

# might need to make this executable on your system
$ chmod +x /path/to/funannotate-docker

# assuming it is in your PATH, now you can run this script as if it were the funannotate executable script
$ funannotate-docker test -t predict --cpus 12

#数据库
funannotate-docker setup -i uniprot -d database/uniprot


export FUNANNOTATE_DB=/root/software/database/uniprot


#安装unicycler
conda create -n unicycler python==3.6.12
conda activate unicycler
conda install -c bioconda unicycler


#orthofinder
conda create -n orthofinder  #python==2.7
conda activate orthofinder
conda install -c bioconda orthofinder
#github下载
Download the latest release from github: https://github.com/davidemms/OrthoFinder/releases
If you have python installed and the numpy and scipy libraries then download OrthoFinder_source.tar.gz.
If not then download the larger bundled package, OrthoFinder.tar.gz.
In a terminal, 'cd' to where you downloaded the package
Extract the files: tar xzf OrthoFinder_source.tar.gz or tar xzf OrthoFinder.tar.gz
conda activate phylogeny
orthofinder -f ExampleData/ -o test_results
OK!

#进行blast并用mafft进行多重序列align
orthofinder -f input -S blast -M msa -t 80 -oa
#结果文件在：
input/Orthofinder/Results/MultipleSequenceAlignments/SpeciesTreeAlignment.fa
conda activate phylogeny
orthofinder -f /mnt/d/pipeline/fungi/OrthoFinder_source/ExampleData/ -S blast -M msa -t 2 -oa -o Test-Example

#下载安装iqtree2
wget https://github.com/iqtree/iqtree2/releases/download/v2.2.0/iqtree-2.2.0-Linux.tar.gz
tar -zxvf iqtree-2.2.0-Linux.tar.gz
#将iqtree2文件取出，其余文件可以删除
#运行iqtree2进行模型预测（耗时很长，可以不做）
./iqtree2 -s SpeciesTreeAlignment.fa -m MF -nt 80 -pre outfoldername/outfilename
#对align后的蛋白序列建树
./iqtree2 -s SpeciesTreeAlignment.fa -m LG+G4 -pre outfoldername/outfilename -bb 1000 -nt 80



#iqtree-2
cd /data1/home/zhangzy/work/YY/test
/data1/home/zhangzy/soft/iqtree-2.2.0-Linux/bin/iqtree2 -s SpeciesTreeAlignment.fa -m LG+G4 -pre outfolder/Test-iqtree2 -bb 1000 -nt 80