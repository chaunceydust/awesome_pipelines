#!/bin/bash

##  OrthoMCL
# mkdir -p $PWD/orthomcl
# cd $PWD/orthomcl

# 1.5 在当前工作目录中创建配置文件。配置数据库信息
perl -p -e 's/:3307//; s/^dbLogin=.*/dbLogin=zhouxingchen/; s/^dbPassword=.*/dbPassword=2016\@cpu/' /opt/biosoft/orthomclSoftware-v2.0.9/doc/OrthoMCLEngine/Main/orthomcl.config.template > orthomcl.config


# 1.6 安装 OrthoMCL 运行所需要的 mysql 数据库的表
echo "CREATE DATABASE IF NOT EXISTS orthomcl" | mysql -uzhouxingchen -p2016@cpu
orthomclInstallSchema orthomcl.config

#### 	根据生成的 similarSequences.txt 文件大小设定 MySQL 配置文件 /etc/my.cnf 中的 myisam_max_sort_file_size 参数的值，设置该参数的值为 similarSequences.txt 文件大小的 5 倍。比如：similarSequences.txt 文件的大小为 80 M，则设置大小为 409600 。将 “myisam_max_sort_file_size = 409600” 这一行添加到 myisam_sort_buffer_size 这一行的上面。
####	然后，将 similarSequences.txt 文件载入到 MySQL 数据库中。

# 1.7 将 similarSequences.txt 导入到 mysql 数据库
file="similarSequences.txt"
count=13


line=`wc -l <$file`
size=$((( $line / ($count * 4) + 1) * 4))
awk -v sz=$size 'BEGIN{i=1}{ print $0 > FILENAME "." i ".tmp"; if (NR>=i*sz){close(FILENAME "." i ".tmp");i++}}' $file

echo "LoadBlast START!" > test.log
echo `date` >> test.log

# orthomclLoadBlast orthomcl.config similarSequences.txt

for tmp in `ls similarSequences.txt*.tmp | sed '1!G;h;$!d'`;
do
	orthomclLoadBlast orthomcl.config $tmp
	echo `date` >> test.log
	echo $tmp "Finished!" >> test.log
	# wc -l $tmp
	sleep 60
	sleep 60
done

echo "LoadBlast Finished!" >> test.log
echo `date` >> test.log

for i in {1..60};
do
	sleep 60
done

# 1.8
echo "Pairs START!" >> test.log
echo `date` >> test.log

orthomclPairs orthomcl.config orthomcl_pairs.log cleanup=no

echo "Pairs Finished!" >> test.log
echo `date` >> test.log

# 1.9 将找到的相似序列对从 mysql 中导出
orthomclDumpPairsFiles orthomcl.config
# real    29m59.367s
# user    2m38.838s
# sys     0m21.926s
