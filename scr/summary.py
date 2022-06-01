import os,sys

path=sys.argv[1]
newpath=sys.argv[2]
types=str(sys.argv[3])
outcome=str(sys.argv[4])
newfile=newpath+outcome+'_'+types+'.txt'
out=open(newfile,'a')
files=os.listdir(path)
for file in files:
	txt_path=path+file
	contents=open(txt_path,'r')
	for i in contents:
		try:
			line=i.strip().split('\t')
			beta=str(round(float(line[0]),4))
			CI1=str(round(float(line[1]),4))
			CI2=str(round(float(line[2]),4))
			newline=[file,outcome,beta,CI1,CI2,line[3]]
			out.write('\t'.join(newline)+'\n')
		except ValueError:
			newline=[file,outcome,line[0],line[1],line[2],line[3]]
			out.write('\t'.join(newline)+'\n')

out.close()
contents.close()
