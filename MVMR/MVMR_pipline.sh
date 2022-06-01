####################
# Data preparation #
####################
# 1. We combined the genetic instruments from the relevant GWASs: relative carbohydrate intake, relative fat intake, and relative protein intake, and further linkage disequilibrium clumped (R2 < 0.001 within a window of 10,000 kb), to ensure that SNPs were independent. 
# 2. Organize the exposure file into the following format.
# SNP	A1	A2	carbohydrate	carbohydrate.se	carbohydrate.p	fat	fat.se	fat.p	protein	protein.se	protein.p
# 3. Organize the outcome file into the following format. 
# SNP	A1	A2	EAF	beta	se	p	N
mkdir result
mkdir result/IVW result/egger
Rscript MVMR_1.R exp.file out.file result/IVW/exp.file_out.file result/egger/exp.file_out.file
