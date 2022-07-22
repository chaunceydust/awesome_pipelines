#!/bin/bash
#####   TOSHIBA    #####
##  OrthoMCL
# mkdir -p $PWD/orthomcl
# cd $PWD/orthomcl

# 1.5 在当前工作目录中创建配置文件。配置数据库信息
perl -p -e 's/:3307//; s/^dbLogin=.*/dbLogin=zhouxingchen/; s/^dbPassword=.*/dbPassword=2016\@cpu/' /opt/biosoft/orthomclSoftware-v2.0.9/doc/OrthoMCLEngine/Main/orthomcl.config.template > orthomcl.config
# perl -p -e 's/:3307//; s/^dbLogin=.*/dbLogin=zhouxingchen/; s/^dbPassword=.*/dbPassword=2016\@cpu/; s/^percentMatchCutoff=.*/percentMatchCutoff=50/' /opt/biosoft/orthomclSoftware-v2.0.9/doc/OrthoMCLEngine/Main/orthomcl.config.template > orthomcl.config


# 1.6 安装 OrthoMCL 运行所需要的 mysql 数据库的表
echo "CREATE DATABASE IF NOT EXISTS orthomcl" | mysql -uzhouxingchen -p2016@cpu
orthomclInstallSchema orthomcl.config

#### 	根据生成的 similarSequences.txt 文件大小设定 MySQL 配置文件 /etc/my.cnf 中的 myisam_max_sort_file_size 参数的值，设置该参数的值为 similarSequences.txt 文件大小的 5 倍。比如：similarSequences.txt 文件的大小为 80 M，则设置大小为 409600 。将 “myisam_max_sort_file_size = 409600” 这一行添加到 myisam_sort_buffer_size 这一行的上面。
####	然后，将 similarSequences.txt 文件载入到 MySQL 数据库中。
# 1.7 将 similarSequences.txt 导入到 mysql 数据库
orthomclLoadBlast orthomcl.config similarSequences.txt


# 1.8 寻找相似序列对：在物种间中是相互最佳匹配的对（orthologs对）；在物种内是相>互最佳匹配并优于种间匹配的对（in-paralogs对）；前两者结合得到的co-orthologs对。
orthomclPairs orthomcl.config orthomcl_pairs.log cleanup=no

# 1.9 将找到的相似序列对从 mysql 中导出
orthomclDumpPairsFiles orthomcl.config

# # 1.10 使用 mcl 对 pairs 进行聚类（Ortholog Cluster Groups）并对类进行编号
# mcl mclInput --abc -I 1.5 -o mclOutput
# orthomclMclToGroups OCG 1 < mclOutput > groups.txt
# perl -e 'open IN, $ARGV[0]; @num = <IN>; $num = @num; $len = length($num); foreach (@num) { m/OCG(\d+)/; $id = 0 x ($len - length($1)); s/OCG/OCG$id/; print;} ' groups.txt > aa; mv aa groups.txt


# 安装 OrthoMCL 运行所需要的 mysql 数据库的表
echo "DROP DATABASE orthomcl" | mysql -uzhouxingchen -p2016@cpu

###### result ######
# .
# ├── [ 18M]  mclInput
# ├── [2.2K]  orthomcl2-4small-file.sh
# ├── [ 406]  orthomcl.config
# ├── [7.1K]  orthomcl_pairs.log
# ├── [  88]  pairs
# │   ├── [280K]  coorthologs.txt
# │   ├── [114K]  inparalogs.txt
# │   └── [ 18M]  orthologs.txt
# └── [112M]  similarSequences.txt
# 
# 1 directory, 8 files

