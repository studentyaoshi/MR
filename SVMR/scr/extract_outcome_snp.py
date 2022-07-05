import sys

snp=[]
dic={}
a=open(sys.argv[1],'r')
he=a.readline()
da=a.readlines()
for i in da:
	line=i.strip().split('\t')
	dic[line[0]]=[line[0],line[1],line[2]]
	snp.append(line[0])
a.close()

b=open(sys.argv[2],'r')
c=open(sys.argv[3],'w')
head=b.readline()
data=b.readlines()
h=['SNP','A1','A2','EAF','beta','se','p','N']
c.write('\t'.join(h)+'\n')
for j in data:
	lines=j.strip().split('\t')
	if lines[0] in snp:
		try:
			allele=dic.get(lines[0])
			if lines[1].lower == allele[1].lower:
				c.write('\t'.join(lines)+'\n')
			elif lines[2].lower == allele[1].lower:
				eaf=str(1-float(lines[3]))
				beta=str(0-float(lines[4]))
				newline=[allele[0],allele[1],allele[2],eaf,beta,lines[5],lines[6],lines[7]]
				c.write('\t'.join(newline)+'\n')
			else:
				continue
		except TypeError:
			continue

b.close()
c.close()
