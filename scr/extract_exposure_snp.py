import sys

snp=[]
a=open(sys.argv[1],'r')
he=a.readline()
da=a.readlines()
for i in da:
	line=i.strip().split('\t')
	snp.append(line[0])
a.close()

b=open(sys.argv[2],'r')
c=open(sys.argv[3],'w')
head=['SNP','A1','A2','EAF','beta','se','p','N']
c.write('\t'.join(head)+'\n')
hea=b.readline()
data=b.readlines()
for j in data:
	lines=j.strip().split('\t')
	if lines[0] in snp:
		c.write('\t'.join(lines)+'\n')
	else:
		continue
b.close()
c.close()
