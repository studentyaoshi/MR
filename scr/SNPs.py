import os,sys

path=sys.argv[1]
newpath=sys.argv[2]
types=str(sys.argv[3])
outcome=str(sys.argv[4])
newfile=newpath+types
out=open(newfile,'a')
files=os.listdir(path)
for file in files:
	file_path=path+file
	result=open(file_path,'r')
	for i in result:
		try:
			line=i.strip().split('\t')
			newline=[file,outcome,line[0],line[1]]
			out.write('\t'.join(newline)+'\n')
		except IndexError:
			continue
out.close()
result.close()
