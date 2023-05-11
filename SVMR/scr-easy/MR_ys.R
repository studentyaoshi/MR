Args <- commandArgs(TRUE)
library(TwoSampleMR)
input1 <- Args[1] #exposure data
input2 <- Args[2] #outcome data
exposure<-read.table(input1,header=T)
outcome<-read.table(input2,header=T)
exp_dat <- read_exposure_data( filename = input1, sep = "\t", snp_col = "SNP", beta_col = "beta", se_col = "se", effect_allele_col = "A1", other_allele_col = "A2", eaf_col = "EAF", pval_col = "p", samplesize_col = "N")
outcome_dat <- read_outcome_data(snps = exp_dat$SNP, filename = input2, sep = "\t", snp_col = "SNP", beta_col = "beta", se_col = "se", effect_allele_col = "A1", other_allele_col = "A2", eaf_col = "EAF", pval_col = "p", samplesize_col = "N")
dat <- harmonise_data(exposure_dat = exp_dat, outcome_dat = outcome_dat)

#IVW,Weighted-median
tsmr<-mr(dat, method_list=c("mr_weighted_median","mr_ivw","mr_egger_regression","mr_weighted_mode"))
a1<-cbind('IVW',tsmr[2,7],(tsmr[2,7]-1.96*tsmr[2,8]),(tsmr[2,7]+1.96*tsmr[2,8]),tsmr[2,9]) #ivw
a2<-cbind('Weighted-median',tsmr[1,7],(tsmr[1,7]-1.96*tsmr[1,8]),(tsmr[1,7]+1.96*tsmr[1,8]),tsmr[1,9]) #weight median
write.table(a1,file=Args[3],append = TRUE,quote=F,row.names=F,col.names=F,sep="\t")
write.table(a2,file=Args[3],append = TRUE,quote=F,row.names=F,col.names=F,sep="\t")

#Weighted-mode
n <- tsmr[3,6]
CI <- 0.95
df_wm <- n-1
t_star_wm <- qt((1 - CI)/2, df_wm, lower.tail = FALSE)
SE_wm <- tsmr[4,8]
MOE_wm <- t_star_wm * SE_wm
a3<-cbind('Weighted-mode',tsmr[4,7],(tsmr[4,7]-MOE_wm),(tsmr[4,7]+MOE_wm),tsmr[4,9]) #weight mode
write.table(a3,file=Args[3],append = TRUE,quote=F,row.names=F,col.names=F,sep="\t")

#Egger
df_egger <- n-2
t_star_egger <- qt((1 - CI)/2, df_egger, lower.tail = FALSE)
SE_egger <- tsmr[3,8]
MOE_egger <- t_star_egger * SE_egger
a4<-cbind('Egger',tsmr[3,7],(tsmr[3,7]-MOE_egger),(tsmr[3,7]+MOE_egger),tsmr[3,9]) #egger slope
write.table(a4,file=Args[3],append = TRUE,quote=F,row.names=F,col.names=F,sep="\t")
#Egger intercept
Inter<-mr_pleiotropy_test(dat)
a5<-cbind('Egger-intercept',Inter[1,5],(Inter[1,5]-1.96*Inter[1,6]),(Inter[1,5]+1.96*Inter[1,6]),Inter[1,7])
write.table(a5,file=Args[3],append = TRUE,quote=F,row.names=F,col.names=F,sep="\t")

#Raps
raps<-mr_raps(exposure$beta, outcome$beta, exposure$se, outcome$se, parameters = default_parameters())
a6<-cbind('Raps',raps$b,(raps$b-1.96*raps$se),(raps$b+1.96*raps$se),raps$pval)
write.table(a6,file=Args[3],append = TRUE,quote=F,row.names=F,col.names=F,sep="\t")

#Q
hete<-mr_heterogeneity(dat,method_list=c("mr_egger_regression","mr_ivw"))
a6<-cbind('Egger-Q',hete[1,6],hete[1,7],hete[1,8]) # egger Q
a7<-cbind('IVW-Q',hete[2,6],hete[2,7],hete[2,8]) # ivw Q
write.table(a6,file=Args[3],append = TRUE,quote=F,row.names=F,col.names=F,sep="\t")
write.table(a7,file=Args[3],append = TRUE,quote=F,row.names=F,col.names=F,sep="\t")

#Q-Q'
qq<-cbind((hete[2,6]-hete[1,6]))
qqp<-pchisq(qq, df=1, lower.tail=FALSE)
a8<-cbind('Q-Q',qq,qqp)
write.table(a8,file=Args[3],append = TRUE,quote=F,row.names=F,col.names=F,sep="\t")

#MRPRESSO
library(MRPRESSO)
bzx<-exposure$beta
sebzx<-exposure$se
bzy<-outcome$beta
sebzy<-outcome$se
data3<-cbind(bzx,sebzx,bzy,sebzy)
data3<-as.data.frame(data3)
results<-mr_presso(BetaOutcome = "bzy", BetaExposure = "bzx", SdOutcome= "sebzy", SdExposure = "sebzx", OUTLIERtest = TRUE, DISTORTIONtest= TRUE, data = data3, NbDistribution = 300 , SignifThreshold = 0.05)
a9<-cbind('PRESSO RSSobs',results$`MR-PRESSO results`$`Global Test`$RSSobs,'P-value',results$`MR-PRESSO results`$`Global Test`$Pvalue)
write.table(a9,file=Args[3],append = TRUE,quote=F,row.names=F,col.names=F,sep="\t")

#MR SS
res_ss <- mr_singlesnp(dat,all_method = c("mr_ivw"))
a10<-cbind(res_ss[6],res_ss[7],res_ss[8],res_ss[9])
write.table(a10,file=Args[4],quote=F,row.names=F,col.names=F,sep="\t")

#LOO
loo <- mr_leaveoneout(dat,method=mr_ivw)
a11 <- cbind(loo[6],loo[7],loo[8],loo[9])
write.table(a11,file=Args[5],quote=F,row.names=F,col.names=F,sep="\t")

#Steiger filtering
sf <- directionality_test(dat)
a12 <- cbind('exposure r2:',sf[1,5],'outcome r2:',sf[1,6],sf[1,7],'P-value:',sf[1,8])
write.table(a12,file=Args[3],append = TRUE,quote=F,row.names=F,col.names=F,sep="\t")
