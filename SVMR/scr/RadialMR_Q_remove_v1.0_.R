Args<-commandArgs(TRUE)
input1<-Args[1] #exposure data
input2<-Args[2] #outcome data


output1<-Args[3] #outlier data
####output2<-Args[4]

library(RadialMR)

data1<-read.table(input1,header=T)
data2<-read.table(input2,header=T)

data3<-format_radial(data1$beta,data2$beta,data1$se,data2$se,data1$SNP)

##res1<-ivw_radial(data3,0.05,1,0.000001)
res1<-ivw_radial(data3,0.05,1,0.0001)
res2<-egger_radial(data3,0.05,1)

a1<-cbind(res1$outliers[1])
a2<-cbind(res2$outliers[1])
a1<-as.matrix(a1)
a2<-as.matrix(a2)
a3<-rbind(a1,a2)
a3<-as.data.frame(a3)
a3<-unique(a3)

write.table(a3,output1,quote=F,row.names=F,col.names=F,sep="\t")
####write.table(a2,output2,quote=F,row.names=F,col.names=F,sep="\t")



