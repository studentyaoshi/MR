import os,sys

path=sys.argv[1]
newpath=sys.argv[2]
types=str(sys.argv[3])
outcome=str(sys.argv[4])
newfile=newpath+outcome+'_'+types+'.txt'
out=open(newfile,'a')
files=os.listdir(path)
for file in files:
	file_path=path+file
	result=open(file_path,'r')
	for i in result:
		line=i.strip().split('\t')
		newline=[file,outcome,line[0],line[2]]
		out.write('\t'.join(newline)+'\n')
out.close()
result.close()
