import math
import sys
f1=open(sys.argv[1],'r')
fw=open(sys.argv[2],'w')
he=f1.readline()
list=[]
N=[]
for a in f1.readlines():
	b=a.strip().split()
	PVE=2*float(b[3])*(1-float(b[3]))*float(b[4])*float(b[4])
	ss=float(b[7])
	N.append(ss)
	list.append(PVE)
R2=sum(list)
k=len(list)
n=sum(N)/k
F=((n-k-1)/k)*(R2/(1-R2))
fw.write(str(F)+'\n')
