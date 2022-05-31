# MR
This repository contains code and data necessary to replicate the findings of the paper:

Shi Yao<sup>1#</sup>, Meng Zhang<sup>2#</sup>, Shan-Shan Dong<sup>2#</sup>, Jia-Hao Wang<sup>2</sup>, Kun Zhang<sup>2</sup>, Jing Guo<sup>2</sup>, Yan Guo<sup>2</sup>\*, Tie-Lin Yang<sup>1,2</sup>\*. Mendelian Randomization identifies causal associations between relative carbohydrate intake and depression. *Nature Human Behaviour*. 2022.
> <sup>1</sup>National and Local Joint Engineering Research Center of Biodiagnosis and Biotherapy, The Second Affiliated Hospital, Xi'an Jiaotong University, Xi'an, Shaanxi, 710004, P. R. China  
> <sup>2</sup>Key Laboratory of Biomedical Information Engineering of Ministry of Education, School of Life Science and Technology, Xi'an Jiaotong University, Xi'an, Shaanxi, 710049, P. R. China  

## Requirements  
> - [**Python**](https://www.python.org/downloads/)
> - [**Plink**](http://zzz.bwh.harvard.edu/plink/)
> - [**R**](https://www.r-project.org/)
>   - R packages: TwoSampleMR (version 0.4.10), MRPRESSO (version 1.0), RadialMR (version 0.4), MendelianRandomization (version 0.5.1).

## Maintainer
> **Yao Shi & Zhang Meng**  
> You can contact :email:yaoshi@xjtu.edu.cn or :email:zmarch@stu.xjtu.edu.cn when you have any questions, suggestions, comments, etc.  
> Please describe in details, and attach your command line and log messages if possible.  

# MR pipline
## Schematic of single-variable MR （SVMR）

### Data preprocessing
#### 1. Organize the GWASsummary data into the following format.

```
SNP   A1  A2  EAF  beta  se  p  N
rs11682175  T  C  0.522  -0.028  0.0048  4.68E-09  480359
rs8063603  A  G	  0.654  -0.030  0.0053  6.865E-09  480359
```
#### 2. SNPs with EAF less than 0.01 or greater than 0.99 were removed.
#### 3. Unify the rsid of all files.

### Create workspace
#### 1. Create a storage path for the SVMR project, for example: “**~/SVMR**“.
#### 2. Put the “**src**“ folder under the SVMR.
#### 3. Create a project folder in the SVMR, for example: “**example**”.
#### 4. Create folders in the example to save the results of each step. 
- Folders for each step include: **0-clump, 1-input, 2-Radial, 3-MR, 4-Qtest, 5-raps, 6-Result, 7-SS, 8-PRESSO, 9-Steiger**.
#### 5. List the filename of exposure in the file “**exposure**” and the filename of the outcome in the file “**outcome**”.
#### 6. Put the scripts in the corresponding folder. 
- Put **MR_input.sh, Radial_work.sh, MR_work.sh, raps.sh, sort_result.sh, SS.sh, PRESSO.sh and Steiger.sh** from the script folder into the example folder. 
- Put **clump.sh, clump_sort.sh and sort_clump.py** from the scripts folder into the 0-clump folder. 
- Put **fstatistic.sh, clump_sort.sh and SNPs.sh** from the scripts folder into the 1-Radial folder.

```
mkdir SVMR
cd SVMR
mkdir 0-clump 1-input 2-Radial 3-MR 4-Qtest 5-raps 6-Result 7-SS 8-PRESSO 9-Steiger
vim exposure
vim outcome
```

### Selection of the genetic instrumental variables (IVs)
#### Step 1. Identified SNPs with P < 5E-8 were clumped for independence using PLINK clumping in the TwoSampleMR tool. A strict cut-off of R2 < 0.001 and a window of 10,000 kb were used for clumping with the 1000 Genomes European data as the reference panel. 
- Run
```
cd ~/SVMR/example/0-clump
mkdir clump_ori clump_sort
sh clump.sh
sh clump_sort.sh
```
- Output
  - The results will be stored in  “ ~/SVMR/0-clump/clump_sort/”
```
##IVs selected from the GWASsummary data of carbohydrate intake.
SNP  A1  A2  EAF  beta  se  p  n
rs2472297  T  C  	0.2055  -0.01795  0.00326  3.727e-08  244000
rs7190396  T  G	  0.5985  0.01781  0.00281  2.393e-10  264000
rs1104608  C  G	  0.4184  0.01847  0.00289  1.737e-10  245000
rs36123991  T  G  0.1858  0.0213  0.00369  8.238e-09  224000
rs8097672  A  T	  0.847  0.02346  0.00391  1.949e-09  264000
rs4420638  A  G	  0.8219  -0.02415  0.00372  8.849e-11  239000
rs838144  T  C  0.5342  -0.02323  0.00275  3.261e-17  264000
rs10206338  A  G  0.5724  -0.01577  0.00279  1.516e-08  264000
rs10510554  T  C  0.4362  0.01942  0.00278  2.939e-12  264000
rs10433500  A  G  0.6301  0.01608  0.00286  1.961e-08  264000
rs7012637  A  G	  0.4915  0.01734  0.00278  4.684e-10  259000
rs10962121  T  G  0.4791  -0.01519  0.00275  3.395e-08  264000
```

#### Step 2. Select the SNPs obtained in the step 1 in the exposure GWASsummary data and outcome GWASsummary data respectively.
- Run
```
cd ~/SVMR/example/1-input
mkdir exposure outcome
cd ../
sh MR_input.sh
```
- Output
  - The information of the SNPs selected by exposure GWASsummary data will be stored in “ ~/SVMR/example/1-input/exposure/“.
  - The information of the SNPs selected by outcome GWASsummary data will be stored in “ ~/SVMR/example/1-input/outcome/“.

#### Step 3. If there are SNPs not found in the outcome GWASsummary data.
- We replaced them with proxy SNPs (r2 > 0.8) using the [**LDproxy**](https://ldlink.nci.nih.gov/)  search online.
- If the rsids of the exposure dataset and the outcome dataset are inconsistent, [**NCBI**](https://www.ncbi.nlm.nih.gov/snp/) can check whether the SNPs not found are merged into other rsids, and then replace them.

#### Step 4. Remove confounders
- To avoid potential confounding, we investigated each instrument SNP in the [**PhenoScanner GWAS database**](http://www.phenoscanner.medschl.cam.ac.uk/upload/)  to assess any previous associations (P < 5×10-8) with plausible confounders (i.e. alcohol consumption, smoking status, physical activity, education). 
- Remove confounders from the corresponding file. The files are located in " ~/SVMR/example/1-input/exposure/“ and " ~/SVMR/example/1-input/outcome/“.

#### Step 5. To meet the assumption that requires instruments to be associated with the outcome only through exposure, we excluded SNPs strongly associated with the outcome. 
- Remove them from the corresponding file. The files are located in " ~/SVMR/example/1-input/exposure/” and " ~/SVMR/example/1-input/outcome/“.

#### Step 6. Remove heterogenous SNPs
- Run
```
cd ~/SVMR/example/1-Radial
mkdir exposure_remove outcome_remove result
cd ../
sh Radial_work.sh
```
- Output
  - The removed SNPs are stored in the result folder.
  - The remaining SNPs of exposure dataset is stored in " ~/SVMR/example/2-Radial/exposure_remove/“.
  - The remaining SNPs of outcome dataset is stored in " ~/SVMR/example/2-Radial/exposure_remove/“.
#### After the above six steps of selection and deletion, the remaining SNPs were used to perform MR analysis. 

### Perform MR analysis and Q-test.
- We used five MR methods, they are IVW, Weighted Median, Weighted Mode, MR RAPS and MR Egger.
- Run
```
cd ~/SVMR/example
sh MR_work.sh
sh raps.sh
```
- Output
  - MR results will be written into the " ~/SVMR/example/3-MR/“ and " ~/SVMR/example/ 5-raps/“.
  - Q-test results will be written into the "~/SVMR/example/4-Qtest/“.
- Note: SNPs that need to be removed may be displayed in the log file of this step. These points have palindromic sequences and need to be deleted in the corresponding files.  The files are located in " ~/SVMR/example/2-Radial/exposure_remove/“ and " ~/SVMR/example/2-Radial/outcome_remove/“.

### Collate the results
- Calculate F-statistic and the number of IVs.
- Run
```
cd ~/SVMR/example/2-Radial
mkdir fstatistic SNPs
sh fstatistic.sh
sh SNPs.sh
```
- Summary results
```
cd ~/SVMR/example/Result
mkdir tem
cd ../
sh sort_result.sh
```
- Output
  - Results will be written into the "~/SVMR/example/Result/“.
### Single SNP MR
- Run
```
cd ~/SVMR/example
sh SS.sh
```
- Output
  - Results will be written into the "~/SVMR/example/7-SS/“.
### MR PRESSO
- Run
```
cd ~/SVMR/example
sh PRESSO.sh
```

- Output
  - Results will be written into the "~/SVMR/example/8-PRESSO/“.

### 	MR Steiger test
- Run
```
cd ~/SVMR/example
sh Steiger.sh
```
- Output
  - Results will be written into the "~/SVMR/example/9-Steiger/ ".

## Schematic of multivariable MR (MVMR)

- Data preparation
 - We combined the genetic instruments from the relevant GWASs: relative carbohydrate intake, relative fat intake, and relative protein intake, and further linkage disequilibrium clumped (R2 < 0.001 within a window of 10,000 kb), to ensure that SNPs were independent. 
 - Organize the exposure.file into the following format. 

```
SNP  A1  A2  carbohydrate  carbohydrate.se  carbohydrate.p  fat  fat.se  fat.p  protein  protein.se  protein.p
```
 - Organize the outcome.file into the following format. 

```
SNP   A1  A2  EAF  beta  se  p  N
```
  - Note: the order of SNPs in the two files, A1 and A2, must be consistent.
- Run

```
cd ~/MVMR/
Rscript MVMR_1.R exposure.file outcome.file
```
