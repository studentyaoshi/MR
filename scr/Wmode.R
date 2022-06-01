library(TwoSampleMR)
Args<-commandArgs(TRUE)
input1<-Args[1]
input2<-Args[2]
#output1<-Args[3]
#output2<-Args[4]
#output3<-Args[5]

exposure<-read.table(input1,header=T)
outcome<-read.table(input2,header=T)
#b_out<-read.table(input3,header=F)
#se_out<-read.table(input4,header=F)

#b.exp
raps<-mr_weighted_mode(exposure$beta, outcome$beta, exposure$se, outcome$se, parameters = default_parameters())
#bsen<-get_r_from_bsen(exposure$beta, exposure$se, exposure$N)
#pn<-get_r_from_pn(exposure$se, exposure$N)
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


