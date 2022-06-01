import sys
file1=open(sys.argv[1],'r')
snp=[]
head=file1.readline()
data=file1.readlines()
for i in data:
	try:
		line=i.strip().split()
		snp.append(line[2])
	except IndexError:
		continue
file1.close()

file2=open(sys.argv[2],'r')
file3=open(sys.argv[3],'w')
tem=['SNP','A1','A2','EAF','beta','se','p','n']
file3.write('\t'.join(tem)+'\n')
he=file2.readline()
da=file2.readlines()
for j in da:
	lines=j.strip().split('\t')
	if lines[0] in snp:
		file3.write('\t'.join(lines)+'\n')
	else:
		continue	
file2.close()
file3.close()
