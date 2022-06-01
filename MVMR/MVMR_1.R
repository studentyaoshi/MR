library(MendelianRandomization)

Args<-commandArgs(TRUE)
input1<-Args[1]  #exposures
input2<-Args[2]  #outcome
output1<-Args[3] #IVW
output2<-Args[4] #MR-Egger
data1<-read.table(input1,header=T)
data2<-read.table(input2,header=T)
MRin<-mr_mvinput(snps = data1$SNP,bx = cbind(data1$carbohydrate,data1$fat,data1$protein),bxse =cbind(data1$carbohydrate.se,data1$fat.se,data1$protein.se),by=data2$beta,byse=data2$se)
MVMR1 <- mr_mvivw(MRin)
MVMR2 <- mr_mvegger(MRin, distribution = "t-dist")
MVMR1
MVMR2
sink(output1)
MVMR1
sink()
sink(output2)
MVMR2
sink()
