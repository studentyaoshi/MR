Args<-commandArgs(TRUE)
input1<-Args[1] #exposure data
input2<-Args[2] #outcome data
Ndb<-Args[3]
output1<-Args[4]
#output2<-Args[5]
#output3<-Args[6]
#output4<-Args[7]


library(MRPRESSO)
data1<-read.table(input1,header=T)
data2<-read.table(input2,header=T)
Ndb1<-as.numeric(Ndb)

bzx<-data1$beta
sebzx<-data1$se
bzy<-data2$beta
sebzy<-data2$se
data3<-cbind(bzx,sebzx,bzy,sebzy)
data3<-as.data.frame(data3)

results<-mr_presso(BetaOutcome = "bzy", BetaExposure = "bzx", SdOutcome= "sebzy", SdExposure = "sebzx", OUTLIERtest = TRUE, DISTORTIONtest= TRUE, data = data3, NbDistribution = Ndb1 , SignifThreshold = 0.05)
results

sink(output1)
results
sink()
####max1<-results$`Outlier Test`
####write.table(max1,"~/data/MR_proj/209Trait_replical_/2015BMI_444result_for/SNP_list",quote=F,row.names=F,sep="\t")

##a1<-results$`MR-PRESSO results`$`Distortion Test`$Pvalue
##a2<-results$`Main MR results`
##a3<-results$`MR-PRESSO results`$`Global Test`s$Pvalue
##a4<-results$`MR-PRESSO results`$`Global Test`$RSSobs
##a3<-results$Pvalue
##a4<-results$RSSobs

##b2<-cbind(a4,a3)
##a2A<-cbind(a2[2],a2[3],a2[4],a2[5],a2[6])

#write.table(a1,output1,quote=F,row.names=F,col.names=F,sep="\t") ##DTP
#write.table(b2,output1,quote=F,row.names=F,col.names=F,sep="\t") ##Global test
##write.table(a2A[1,],output3,quote=F,row.names=F,col.names=F,sep="\t") ##Raw result
##write.table(a2A[2,],output4,quote=F,row.names=F,col.names=F,sep="\t") ## Adj result




