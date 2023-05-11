import sys

a=open(sys.argv[1],'r')
b=open(sys.argv[2],'r')
c=open(sys.argv[3],'w')
snp=[]
for i in a:
	line=i.strip().split('\t')
	snp.append(line[0])
a.close()
head=b.readline()
data=b.readlines()
he=['SNP','A1','A2','EAF','beta','se','p','N']
c.write('\t'.join(he)+'\n')
for j in data:
	lines=j.strip().split('\t')
	if lines[0] in snp:
		continue
	else:
		c.write('\t'.join(lines)+'\n')
b.close()
c.close()
