#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import argparse
import sys
import os
import pandas as pd 
from datatable import dt,join,f,by
parser = argparse.ArgumentParser(prog='abundance.py',

    epilog='''
用法:
abundance.py -class asvclass.txt -db spdt.txt -asv asvtable.txt -out out_dir
''', formatter_class=argparse.RawDescriptionHelpFormatter)


parser.add_argument('-class', '--asvclass', required=True, type=str,
                    help='asvclass.txt')
parser.add_argument('-asv', '--asvtable', required=True, type=str,
                    help='asvtable.txt')
parser.add_argument('-db', '--spdb', required=True, type=str,
                    help='spdt.txt')
parser.add_argument('-out', '--output', required=True, type=str,
                    help='out_dir')

def main():
    args = parser.parse_args()
    asvclass=dt.fread(args.asvclass,sep='\t')
    spdt=dt.fread(args.spdb,sep='\t')
    spdt.key='spid'
    genusdt=asvclass[:, :, join(spdt)]
    orftab=dt.fread(args.asvtable,header=True)
    orftab.names={"#OTU ID" : "asvid"}
    # orftab=orftab.to_pandas()
    genusdt.key='asvid'
    genusdt=orftab[:, :, join(genusdt)]
    genusdt=genusdt[:, f[:].remove([f.spid])]
    genusdt.to_csv(os.path.join(args.output,'asv-sp.csv'))
    #S
    #genusdt=genusdt.to_pandas()le 
    ##genus
    genusdt=genusdt[:, f[:].remove([f.asvid])]
    #genusdt=genusdt[:, dt.sum(f[:]), by("taxonomy")]
    genusdt=genusdt.to_pandas()
    genusdt=genusdt.groupby('taxonomy').agg('sum')
    genusdt=genusdt.reset_index()
    genusdt=pd.concat([genusdt, genusdt['taxonomy'].str.split('|', expand=True)], axis=1)
    genusdt=genusdt.rename(columns={0:'K',1:'P',2:'C',3:'O',4:'F',5:'G'})
    genusdt['taxonomy']=genusdt['K']+str('|')+genusdt['P']+str('|')+genusdt['C']+str('|')+genusdt['O']+str('|')+genusdt['F']+str('|')+genusdt['G']
    genusdt=genusdt.groupby('taxonomy').agg('sum')
    genusdt.to_csv(os.path.join(args.output,'genus.txt'),index=1,sep="\t")
    genus_rel= genusdt/genusdt.sum()#####计算相对丰度
    genus_rel.to_csv(os.path.join(args.output,'genus_rel.txt'),sep="\t")
    
    ##family
    genusdt=genusdt.reset_index()###将索引（index）转换为列名
    genusdt=pd.concat([genusdt, genusdt['taxonomy'].str.split('|', expand=True)], axis=1)
    genusdt=genusdt.rename(columns={0:'K',1:'P',2:'C',3:'O',4:'F',5:'G'})
    genusdt=genusdt.drop(['G'], axis=1)
    genusdt['taxonomy']=genusdt['K']+str('|')+genusdt['P']+str('|')+genusdt['C']+str('|')+genusdt['O']+str('|')+genusdt['F']
    genusdt=genusdt.groupby('taxonomy').agg('sum')
    genusdt.to_csv(os.path.join(args.output,'family.txt'),index=1,sep="\t")
    genus_rel= genusdt/genusdt.sum()#####计算相对丰度
    genus_rel.to_csv(os.path.join(args.output,'family_rel.txt'),sep="\t")
    ##order
    genusdt=genusdt.reset_index()###将索引（index）转换为列名
    genusdt=pd.concat([genusdt, genusdt['taxonomy'].str.split('|', expand=True)], axis=1)
    genusdt=genusdt.rename(columns={0:'K',1:'P',2:'C',3:'O',4:'F'})
    genusdt=genusdt.drop(['F'], axis=1)
    genusdt['taxonomy']=genusdt['K']+str('|')+genusdt['P']+str('|')+genusdt['C']+str('|')+genusdt['O']
    genusdt=genusdt.groupby('taxonomy').agg('sum')
    genusdt.to_csv(os.path.join(args.output,'order.txt'),index=1,sep="\t")
    genus_rel= genusdt/genusdt.sum()#####计算相对丰度
    genus_rel.to_csv(os.path.join(args.output,'order_rel.txt'),sep="\t")
    ##class
    genusdt=genusdt.reset_index()###将索引（index）转换为列名
    genusdt=pd.concat([genusdt, genusdt['taxonomy'].str.split('|', expand=True)], axis=1)
    genusdt=genusdt.rename(columns={0:'K',1:'P',2:'C',3:'O'})
    genusdt=genusdt.drop(['O'], axis=1)
    genusdt['taxonomy']=genusdt['K']+str('|')+genusdt['P']+str('|')+genusdt['C']
    genusdt=genusdt.groupby('taxonomy').agg('sum')
    genusdt.to_csv(os.path.join(args.output,'class.txt'),index=1,sep="\t")
    genus_rel= genusdt/genusdt.sum()#####计算相对丰度
    genus_rel.to_csv(os.path.join(args.output,'class_rel.txt'),sep="\t")
  ##phylum
    genusdt=genusdt.reset_index()###将索引（index）转换为列名
    genusdt=pd.concat([genusdt, genusdt['taxonomy'].str.split('|', expand=True)], axis=1)
    genusdt=genusdt.rename(columns={0:'K',1:'P',2:'C'})
    genusdt=genusdt.drop(['C'], axis=1)
    genusdt['taxonomy']=genusdt['K']+str('|')+genusdt['P']
    genusdt=genusdt.groupby('taxonomy').agg('sum')
    genusdt.to_csv(os.path.join(args.output,'phylum.txt'),index=1,sep="\t")
    genus_rel= genusdt/genusdt.sum()#####计算相对丰度
    genus_rel.to_csv(os.path.join(args.output,'phylum_rel.txt'),sep="\t")
    print('OK!')
   

if __name__ == "__main__":
    main()
