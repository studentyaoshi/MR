######################
# Data preprocessing #
######################
# 1. Organize the GWASsummary data into the following format.
# SNP	A1	A2	EAF	beta	se	p	N
# rs11682175	T	C	0.522	-0.028	0.0048	4.68E-09	480359
# rs8063603	A	G	0.654	-0.030	0.0053	6.865E-09	480359
# 2. SNPs with EAF less than 0.01 or greater than 0.99 were removed.
# 3. Unify the rsid of GWASsummary data.
# The GWAS for relative intake of carbohydrate can be obtained through the SSGAC data portal (https://www.thessgac.org/). The GWAS for major depressive disorder were provided by the PGC (https://figshare.com/ndownloader/files/34427408). 

##############################
# Preparation before running #
##############################
# 1. Download the "scr" folder from GitHub. (https://github.com/studentyaoshi/MR)
# 2. Put the processed GWASsummary data in the "data" folder.
# 3. Create a workplace and put it in the same path as scr. For example we created a folder named "Carbohydrat-MDD".

cd ../Carbohydrat-MDD


########################################################
# Selection of the genetic instrumental variables (IVs)#
########################################################
# Step 1. Identified SNPs with P < 5E-8 were clumped for independence using PLINK clumping in the TwoSampleMR tool. A strict cut-off of R2 < 0.001 and a window of 10,000 kb were used for clumping with the 1000 Genomes European data as the reference panel.
# Input:
#	1. 1000 Genomes European data download address: https://www.internationalgenome.org/category/data-access/
#	2. exposure GWASsummary data
# Outputs are stored in "1-clump/clump_sort_5e-8_10000/"
# Note: Please modify the path of the reference file in "1-clump.sh".
sh ../scr/1-clump.sh

# Step 2. The SNPs obtained in step 1 were picked from the outcome GWASsummary data. And filter the SNPs selected by exposure GWASsummary data.
# Input:
#	1. outputs of step 1
#	2. outcome GWASsummary data
# Outputs are stored in "2-input/exposure/" and "2-input/outcome/"
sh ../scr/2-MR_input.sh

# Step 3. Where SNPs for the exposure were not available in the outcome datasets, we replaced them with proxy SNPs (r2 > 0.8) using the LDproxy search online (https://ldlink.nci.nih.gov/). And add them to the output file of the second step.
# Note: Check if SNPs for the exposure were not available in the outcome datasets by comparing "1-clump/clump_sort_5e-8_10000/Carbohydrate" and "2-input/outcome/Carbohydrate".

# Step 4. To avoid potential confounding, we investigated each instrument SNP in the PhenoScanner GWAS database (http://www.phenoscanner.medschl.cam.ac.uk/upload/) to assess any previous associations (P < 5×10-8) with plausible confounders (i.e. alcohol consumption, smoking status, physical activity, education). To meet the assumption that requires instruments to be associated with the outcome only through exposure, we excluded SNPs strongly associated with the outcome. The effects of SNPs on exposure and outcome were then harmonized to ensure the beta values were signed to the same alleles. After data harmonization, we removed palindromic SNPs with intermediate allele frequencies (>0.42). 
# Input:
#	List the SNPs that need to be removed in the file rm_snp.list and put it in "Carbohydrat-MDD".
# outputs are stored in "2-input/exposure/" and "2-input/outcome/"
# For example, in this step, we removed rs10433500, rs1104608, rs36123991, rs7190396, and rs838144.
sh ../scr/remove_snp.sh

# Step 5. We removed outlier pleiotropic SNPs via heterogeneity test (modified Q-statistics) using RadialMR with the P-value threshold of 0.05. 
# Input are stored in "2-input/exposure/" and "2-input/outcome/".
# Outputs are stored in "3-Radial/exposure_remove/" and "3-Radial/outcome_remove/".
sh ../scr/3-Radial_work.sh

# The remaining SNPs were used to perform MR analysis.

#########################
# MR analysis and Q-test#
#########################
# Inputs are stored in "3-Radial/exposure_remove/exposure.file" and "3-Radial/outcome_remove/outcome.file".
# Outputs are stored in "4-MR" and "5-Qtest".
# The format of the result is: exposure	outcome	beta	95%CI_L	95%CI_H	p-value
sh ../scr/4-5-MR_Qtest.sh

##########################
# Single SNP MR analysis #
##########################
# The format of the result is: SNP,beta,95%CI_L,95%CI_H,p-value
sh ../scr/6-MR_SingleSNP.sh

#############
# MR PRESSO #
#############
sh ../scr/7-PRESSO.sh

###################
# MR Steiger test #
###################
sh ../scr/8-Steiger.sh
