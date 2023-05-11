library(TwoSampleMR)
Args<-commandArgs(TRUE)
input1<-Args[1]
input2<-Args[2]
output1<-Args[3]

exposure<-read.table(input1,header=T)
outcome<-read.table(input2,header=T)

raps<-mr_raps(exposure$beta, outcome$beta, exposure$se, outcome$se, parameters = default_parameters())

a1<-cbind(raps$b,(raps$b-1.96*raps$se),(raps$b+1.96*raps$se),raps$pval)
write.table(a1,output1,quote=F,row.names=F,col.names=F,sep="\t")
a1
raps
#sink(output1)
#raps
#sink()

#sink(output2)
#bsen
#sink()
#sink(output3)
#pn
#sink()


