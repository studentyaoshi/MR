# Rscript .R exposure.file outcome.file scatter.pdf LOO.pdf exposure outcome

Args <- commandArgs(TRUE)
input1 <- Args[1] #exposure data
input2 <- Args[2] #outcome data


##output1 <- Args[3] #scatter plot
##output2 <- Args[4] #leave one out plot
output1 <- Args[3] #leave one out plot
##output2 <- Args[4] #Single SNP plot

library(TwoSampleMR)

exp_dat <- read_exposure_data(
							  filename = input1,
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
								 samplesize_col = "N",
								 )
exp_dat$exposure <- Args[4]
outcome_dat$outcome <- Args[5]
dat <- harmonise_data(
					  exposure_dat = exp_dat,
					  outcome_dat = outcome_dat 
					  )

##tsmr <- mr(dat, method_list=c("mr_weighted_median","mr_ivw","mr_egger_regression","mr_weighted_mode"))
##p1 <- mr_scatter_plot(tsmr,dat)
##pdf(file = output1)
##p1
##dev.off()

res_loo <- mr_leaveoneout(dat,method=mr_ivw)
p1 <- mr_leaveoneout_plot(res_loo)
pdf(file = output1)
p1
dev.off()

##res_single <- mr_singlesnp(dat)
##p2 <- mr_forest_plot(res_single)
##pdf(file = output2)
##p2
##dev.off()


