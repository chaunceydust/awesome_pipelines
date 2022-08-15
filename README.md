# myPipeline

…or create a new repository on the command line
```
echo "# myPipeline" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:chaunceydust/myPipeline.git
git push -u origin main
```

…or push an existing repository from the command line
```
git remote add origin git@github.com:chaunceydust/myPipeline.git
git branch -M main
git push -u origin main
```

…or import code from another repository
You can initialize this repository with code from a Subversion, Mercurial, or TFS project.


## pipeline_download_seqs_from_NCBI
software installation
```
conda install -y entrez-direct
```

## eggNOG 注释流程

### 使用到的数据
- GO: (http://geneontology.org/docs/download-ontology/)
- go.basic.obo: (http://purl.obolibrary.org/obo/go/go-basic.obo)
- parse_go_obofile.py: (https://github.com/Hua-CM/HuaSmallTools/blob/master/parse/parse_go_obofile.py)
- parse_eggNOG.py: (https://github.com/Hua-CM/HuaSmallTools/tree/master/parse)

### 流程：
1. 使用eggNOG对基因组蛋白序列进行注释
2. 解析eggNOG结果文件
3. 使用clusterProfiler进行富集分析

首先需要去GO下载GO的obo文件,这里我使用go-basic.obo然后我写了个脚本可以把obo文件解析为如下格式：
```
python parse_go_obofile.py -i go-basic.obo \
                           -o go.tb
```
处理后的文件：

等eggNOG注释完后，使用另一个parse_eggNOG.py脚本处理eggNOG的结果。
> - 「参数说明」
> -「-i」 eggNOG的注释结果
> -「-g」 上一步根据obo解析出来的文件
> -「-O」 参考物种(只用于KEGG注释，使用KEGG三字母物种缩写表示).设置这个参数的原因是我做KEGG富集的时候发现有的基因会出现在非常荒唐的通路上，比如某个植物基因富集到了癌症的相关通路，后来发现原因是有的比较基础的KO可能与癌症通路有关，如果不使用参考物种，直接用KO去寻找map的话就会出现上述的情况。这里使用参考物种可以把没有出现在参考物种中的通路给过滤掉。植物我选择拟南芥和水稻作为参考，同样的如果做非模式动物的话，可以考虑设置一些动物物种来排除富集到植物的通路上。参考（https://www.genome.jp/kaas-bin/kaas_org）
> -「-o」 输出结果文件夹。会在该文件夹生成GOannotation.tsv和KOannotation.tsv两个文件

```
python parse_eggNOG.py -i panax_ginseng.annotations \
                       -g go.tb \
                       -O ath,osa \
                       -o D:\RProject\MedicalPlantDB
```

### 富集分析
总的来说就是利用clusterProfiler中的enricher这个通用函数进行富集
```
library(clusterProfiler)
KOannotation <- read.delim("D:/RProject/MedicalPlantDB/KOannotation.tsv", stringsAsFactors=FALSE)
GOannotation <- read.delim("D:/RProject/MedicalPlantDB/GOannotation.tsv", stringsAsFactors=FALSE)
GOinfo <- read.delim("D:/RProject/MedicalPlantDB/go.tb", stringsAsFactors=FALSE)
# 前面获取gene list的过程略
gene_list<- # 你的gene list
# GO富集
## 拆分成BP，MF，CC三个数据框
GOannotation = split(GOannotation, with(GOannotation, level))
## 以MF为例
enricher(gene_list,
          TERM2GENE=GOannotation[['molecular_function']][c(2,1)],
          TERM2NAME=GOinfo[1:2])
# KEGG富集
enricher(gene_list,
          TERM2GENE=KOannotation[c(3,1)],
          TERM2NAME=KOannotation[c(3,4)])
```


## MEGAN6 - Metagenome Analyzer
- [megan主页](https://uni-tuebingen.de/en/fakultaeten/mathematisch-naturwissenschaftliche-fakultaet/fachbereiche/informatik/lehrstuehle/algorithms-in-bioinformatics/software/megan6/)
- [megan软件及数据库下载](https://software-ab.informatik.uni-tuebingen.de/download/megan6/welcome.html)
