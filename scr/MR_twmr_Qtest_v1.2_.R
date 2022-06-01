Args <- commandArgs(TRUE)
input1 <- Args[1] #exposure data
input2 <- Args[2] #outcome data

output3 <- Args[3] #Q-Q'


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




hete<-mr_heterogeneity(dat,method_list=c("mr_egger_regression","mr_ivw"))

a1<-cbind((hete[2,6]-hete[1,6])) # Q-Q'

a2<-pchisq(a1, df=1, lower.tail=FALSE) #Q-Q' pvalue

a3<-cbind(a1,a2)


write.table(a3,output3,quote=F,row.names=F,col.names=F,sep="\t") #Q-Q' pvalue




