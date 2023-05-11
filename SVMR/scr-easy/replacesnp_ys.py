import sys
a=open(sys.argv[1],'rt')
wsnp=[]
head=a.readline()
for i in a:
	wsnp.append(i.strip().split('\t')[0])
a.close()

b=open(sys.argv[2],'rt')
for i in b:
	wsnp.append(i.strip().split(' ')[1])
b.close()

a=open(sys.argv[3],'rt')
b=open(sys.argv[4],'wt')
b.write(head)
for i in a:
	if i.strip().split('\t')[0] in wsnp:
		b.write(i)
a.close()
b.close()
