import sys
a=open(sys.argv[1],'rt')
snp=[]
for i in a:
	snp.append(i.rstrip('\n'))
a.close()

a=open(sys.argv[2],'rt')
b=open(sys.argv[3],'wt')
b.write(a.readline())
for i in a:
	if i.strip().split('\t')[0] not in snp:
		b.write(i)
a.close()
b.close()
