import re
from sys import argv
_, InputFile, OutputFile = argv
print(InputFile)
print(OutputFile)

dic ={}
v1f = re.compile('GGATCCAGACTTTGATYMTGGCTCAG', re.I)
v3f = re.compile('CCTA[CT]GGG[AG][GTC]GCA[CG]CAG', re.I)
v4f = re.compile('GTG[CT]CAGC[AC]GCCGCGGTAA', re.I)
v4r = re.compile('ATTAGA[AT]ACCC[CTG][ATGC]GTAGTCC', re.I)
v6f = re.compile('AACGCGAAGAACCTTAC', re.I)
v8f = re.compile('CGTCATCC[AC]CACCTTCCTC', re.I)
vr = re.compile('AAGTCGTAACAAGGTA[AG]CCGTA', re.I)
#v4r = re.compile('GGACTAC[ATGC][ACG]GGGT[AT]TCTAAT', re.I)
vf = re.compile('AG[AG]GTT[CT]GAT[CT][AC]TGGCTCAG', re.I)
#vr = re.compile('GACGGGCGGTG[AT]GT[AG]CA', re.I)
#seq_list = []


def decide_which_zone(f1, f3, f4, f4r, f6, f8, f, fr):
    type = [f1, f3, f4, f4r, f6, f8, f, fr]
    type_str = ['f1', 'f3', 'f4', 'f4r', 'f6', 'f8', 'f', 'fr']
    type_name = []
    for i in range(len(type)):
        #print(type[i])
        if type[i] != None :
            type_name.append(type_str[i])
        else:
            continue
        if i + 1 < len(type):
            if type[i + 1] != None and type_str[i + 1] not in type_str:
                type_name.append(type_str[i + 1])
        else:
            continue
        if i + 2 < len(type):
            if type[i + 2] != None and type_str[i + 2] not in type_str:
                type_name.append(type_str[i + 2])
        else:
            continue
        if  i + 3 < len(type):
            if type[i + 3] != None and type_str[i + 3] not in type_str:
                type_name.append(type_str[i + 3])
        else:
            continue
        if  i + 4 < len(type):
            if type[i + 4] != None and type_str[i + 4] not in type_str:
                type_name.append(type_str[i + 4])
        else:
            continue
        if  i + 5 < len(type):
            if type[i + 5] != None and type_str[i +5 ] not in type_str:
                type_name.append(type_str[i + 5])
        else:
            continue
        if  i + 6 < len(type):
            if type[i + 6] != None and type_str[i + 6] not in type_str:
                type_name.append(type_str[i + 6])
        else:
            continue
        if  i + 7 < len(type):
            if type[i + 7] != None and type_str[i + 7] not in type_str:
                type_name.append(type_str[i + 7])
        else:
            continue
    return type_name

with open(InputFile) as f:
    li = ['f1', 'f3', 'f4', 'f4r', 'f6', 'f8', 'f', 'fr']
    for i in range(len(li)):
        for j in range(len(li)):
            if i <= j:
                dic[li[i] + li[j]] = 0


    #print(dic)
    flag = 0
    seq = ''
    #i = 0
    for line in f:
        if line.startswith('>'):# and i <=2:
            flag = 1
            if seq != '':
                #print(seq)
                f1 = v1f.search(seq)
                f4r = v4r.search(seq)
                f3 = v3f.search(seq)
                f4 = v4f.search(seq)
                f6 = v6f.search(seq)
                f8 = v8f.search(seq)
                f = vf.search(seq)
                fr = vr.search(seq)
                #seq_list.append(length)
                type_name = []
                type_name = decide_which_zone(f1, f3, f4, f4r, f6, f8, f, fr)
                # print(type_name)
                if type_name != []:
                    type_key = type_name[0] + type_name[-1]
                    dic[type_key] += 1
                #i += 1
                #break
                seq = ''
                flag = 0
            else:
                seq = ''
        elif flag == 1:
            seq += line.strip()
# print(dic)
import pandas as pd
dataF = pd.Series(dic)
# print(dataF)
dataF.to_csv(OutputFile, header=False)
