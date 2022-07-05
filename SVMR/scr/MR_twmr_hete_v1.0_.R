Args <- commandArgs(TRUE)
input1 <- Args[1] #exposure data
input2 <- Args[2] #outcome data


output1 <- Args[3] #weight median
output2 <- Args[4] #ivw
output3 <- Args[5] #egger slope
output4 <- Args[6] #weight mode
output5 <- Args[7] #egger intercept

output6 <- Args[8] #ivw Q
output7 <- Args[9] #egger Q

library(TwoSampleMR)

exp_dat <- read_exposure_data( filename = input1,
							  sep = "\t",
							  snp_col = "SNP",
							  beta_col = "beta",
							  se_col = "se",
							  effect_allele_col = "A1",
							  other_allele_col = "A2",
							  eaf_col = "EAF",
							  pval_col = "p",
							  samplesize_col = "N"
							)
outcome_dat <- read_outcome_data(
								 snps = exp_dat$SNP,
								 filename = input2,
								 sep = "\t",
								 snp_col = "SNP",
								 beta_col = "beta",
								 se_col = "se",
								 effect_allele_col = "A1",
								 other_allele_col = "A2",
								 eaf_col = "EAF",
								 pval_col = "p",
								 samplesize_col = "N"
								 )
dat <- harmonise_data(
					  exposure_dat = exp_dat,
					  outcome_dat = outcome_dat
					  )

tsmr<-mr(dat, method_list=c("mr_weighted_median","mr_ivw","mr_egger_regression","mr_weighted_mode"))
Inter<-mr_pleiotropy_test(dat)

hete<-mr_heterogeneity(dat,method_list=c("mr_egger_regression","mr_ivw"))

a1<-cbind(tsmr[1,7],(tsmr[1,7]-1.96*tsmr[1,8]),(tsmr[1,7]+1.96*tsmr[1,8]),tsmr[1,9]) #weight median
a2<-cbind(tsmr[2,7],(tsmr[2,7]-1.96*tsmr[2,8]),(tsmr[2,7]+1.96*tsmr[2,8]),tsmr[2,9]) #ivw

n <- tsmr[3,6]   # size of sample
CI <- 0.95  # type of CI
df_egger <- n-2
df_wm <- n-1
t_star_egger <- qt((1 - CI)/2, df_egger, lower.tail = FALSE);
t_star_wm <- qt((1 - CI)/2, df_wm, lower.tail = FALSE);

SE_egger <- tsmr[3,8]
SE_wm <- tsmr[4,8]
MOE_egger <- t_star_egger * SE_egger
MOE_wm <- t_star_wm * SE_wm

a3<-cbind(tsmr[3,7],(tsmr[3,7]-MOE_egger),(tsmr[3,7]+MOE_egger),tsmr[3,9]) #egger slope
a4<-cbind(tsmr[4,7],(tsmr[4,7]-MOE_wm),(tsmr[4,7]+MOE_wm),tsmr[4,9]) #weight mode


a5<-cbind(Inter[5],(Inter[5]-1.96*Inter[6]),(Inter[5]+1.96*Inter[6]),Inter[7]) #egger intercept 


a6<-cbind(hete[1,6],hete[1,7],hete[1,8]) # egger Q
a7<-cbind(hete[2,6],hete[2,7],hete[2,8]) # ivw Q


write.table(a1,output1,quote=F,row.names=F,col.names=F,sep="\t") #weight median
write.table(a2,output2,quote=F,row.names=F,col.names=F,sep="\t") #ivw
write.table(a3,output3,quote=F,row.names=F,col.names=F,sep="\t") #egger slope
write.table(a4,output4,quote=F,row.names=F,col.names=F,sep="\t") #weight mode

write.table(a5,output5,quote=F,row.names=F,col.names=F,sep="\t") #egger intercept

write.table(a6,output6,quote=F,row.names=F,col.names=F,sep="\t") #egger Q
write.table(a7,output7,quote=F,row.names=F,col.names=F,sep="\t") #ivw Q

tsmr



