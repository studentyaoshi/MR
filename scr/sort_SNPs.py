#coding=utf-8
####### python .py SNPs_file Result/tem/ presso_simex_file_1 后缀

import sys

dic={}
a=open(sys.argv[1],'r') #presso, simex file
b=open(sys.argv[2],'r') #Result/tem/
c=open(sys.argv[3],'w')
for i in a:
	line=i.strip().split('\t')
	dic[line[0]]=[line[0],line[1],line[2],line[3]]
a.close()
for j in b:
	lines=j.strip().split('\t')
	filename=lines[0]
	try:
		content=dic.get(str(filename))
		newline=[filename,content[1],content[2],content[3]]
		c.write('\t'.join(newline)+'\n')
	except TypeError:
		newline=[filename,'NA','NA','NA']
		c.write('\t'.join(newline)+'\n')
b.close()
c.close()
