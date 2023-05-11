import sys
a=open(sys.argv[2],'rt')
dic1={}
for i in a:
	dic1[i.strip().split('\t')[0]]='1'
a.close()

a=open(sys.argv[3],'rt')
dic2={}
for i in a:
	dic2[i.strip().split('\t')[0]]='1'
a.close()

a=open(sys.argv[1],'rt')
b=open(sys.argv[4],'wt')
for i in a:
	if dic1.get(i.rstrip('\n'))=='1' and dic2.get(i.rstrip('\n'))=='1':
		b.write(i)
a.close()
b.close()
