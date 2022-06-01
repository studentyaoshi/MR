Args <- commandArgs(TRUE)
input1 <- Args[1] #exposure data
input2 <- Args[2] #outcome data

#output1 <- Args[3] #SS table



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
							  samplesize_col = "N",
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
					  outcome_dat = outcome_dat,
					  )
rsq <- add_rsq(dat)
rsq

#a1<-cbind(res_ss[6],res_ss[7],res_ss[8],res_ss[9])



#write.table(a1,output1,quote=F,row.names=F,col.names=F,sep=",") #SS table

##write.table(a2,output4,quote=F,row.names=F,col.names=F,sep="\t") #Q-Q' pvalue



