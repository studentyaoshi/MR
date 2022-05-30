# MR
This repository contains code and data necessary to replicate the findings of the paper:

Shi Yao<sup>1#</sup>, Meng Zhang<sup>2#</sup>, Shan-Shan Dong<sup>2#</sup>, Jia-Hao Wang<sup>2</sup>, Kun Zhang<sup>2</sup>, Jing Guo<sup>2</sup>, Yan Guo<sup>2</sup>\*, Tie-Lin Yang<sup>1,2</sup>\*. Mendelian Randomization identifies causal associations between relative carbohydrate intake and depression. *Nature Human Behaviour*. 2022.
> <sup>1</sup>National and Local Joint Engineering Research Center of Biodiagnosis and Biotherapy, The Second Affiliated Hospital, Xi'an Jiaotong University, Xi'an, Shaanxi, 710004, P. R. China  
> <sup>2</sup>Key Laboratory of Biomedical Information Engineering of Ministry of Education, School of Life Science and Technology, Xi'an Jiaotong University, Xi'an, Shaanxi, 710049, P. R. China  

## Abstract 


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
## Requirements 

> - [**Python**](https://www.python.org/downloads/)
> - [**Plink**](http://zzz.bwh.harvard.edu/plink/epidetails.shtml)
> - [**R**](https://www.r-project.org/)
>   - R packages: TwoSampleMR (version 0.4.10), MRPRESSO (version 1.0), RadialMR (version 0.4), MendelianRandomization (version 0.5.1)
## Schematic of SVMR

### Data preprocessing
#### 1. Organize the GWASsummary data into the following format.

```

SNP   A1  A2  EAF  beta  se  p  N

```
#### 2. SNPs with EAF less than 0.01 or greater than 0.99 were removed.

### Create workspace
#### 1. Create a storage path for the SVMR project, for example: ~/SVMR.
#### 2. Put the src folder under the SVMR.
#### 3. Create a project folder in the SVMR, for example: example.
#### 4. Create folders in the example to save the results of each step. 
- Folders for each step include: 0-clump, 1-input, 2-Radial, 3-MR, 4-Qtest, 5-raps, 6-Result, 7-SS, 8-PRESSO, 9-Steiger.
#### 5. List the filename of exposure in the file "exposure" and the filename of the outcome in the file "outcome".
#### 6. Put the script in the corresponding folder. 
- Put MR_input_1.sh, Radial_work_1.sh, MR_work_1.sh, raps.sh, sort_result.sh, SS.sh, PRESSO.sh and Steiger.sh from the script folder into the example folder. 
- Put clump1_1.sh, clump_sort1_1.sh and sort_clump.py from the scripts folder into the 0-clump folder. 
- Put fstatistic.sh, clump_sort1_1.sh and SNPs.sh from the scripts folder into the 1-Radial folder.

```
mkdir SVMR
cd SVMR
mkdir 0-clump 1-input 2-Radial 3-MR 4-Qtest 5-raps 6-Result 7-SS 8-PRESSO 9-Steiger
vim exposure
vim outcome
```

### Select instrumental variables (IVs)
#### Step 1. Use plink to pick out individual SNPs.
- Input
  - The reference we use is 1000genome project.
  - input.file is the exposure GWASsummary data processed in the data preprocessing step.

```
plink 
--bfile reference
--clump input.file 
--clump-field p 
--clump-kb 10000 
--clump-p1 5e-8
--clump-p2 0.01 
--clump-r2 0.001 
--out exposure.clump
```

- Run
```
cd ~/SVMR/example/0-clump
mkdir clump_ori clump_sort
sh clump.sh
sh clump_sort1.sh
```
- Output
  - The results will be stored in  “~/SVMR/0-clump/clump_sort”
#### Step 2. Select the SNPs obtained in the step 1 in the exposure GWASsummary data and outcome GWASsummary data respectively.
- Input
  - The result obtained in step 1.
  - The outcome GWASsummary data processed by the data preprocessing step.
- Run
```
cd ~/SVMR/example/1-input
mkdir exposure outcome
cd ../
sh MR_input.sh
```
- Output
  - The information of the SNPs selected by exposure GWASsummary data will be stored in ~/SVMR/example/1-input/exposure.
  - The information of the SNPs selected by outcome GWASsummary data will be stored in ~/SVMR/example/1-input/outcome.
#### Step 3. If there are SNPs not found in the outcome GWASsummary data.
- We approached this in two ways.
  - Use [**NCBI**](https://www.ncbi.nlm.nih.gov/snp/) to check if the SNP merges into other rsids. 
  - Use [**LDproxy**](https://ldlink.nci.nih.gov/) to find SNPs with r2>0.8.
- If the first approach does not solve the problem, then use the second approach. 
- If neither of these two approaches resolves, the SNP will be discarded.

#### Step 4. Remove confounders
- Step 4.1 use [** PhenoScanner**](http://www.phenoscanner.medschl.cam.ac.uk/upload/) to find whether SNPs from step 2 are associated with phenotypes such as education, smoking, alcohol consumption, IQ, exercise, etc. If there are SNPs associated with the above four phenotypes, they need to be removed.
- Remove SNPs found in step 4.1 from the corresponding file. The files are located in "~/SVMR/example/1-input/exposure" and "~/SVMR/example/1-input/outcome".
#### Step 5. Remove heterogenous SNPs
- Input
 - The result obtained in Step 4.
- Run
```
cd ~/SVMR/example/1-Radial
mkdir exposure_remove outcome_remove result
cd ../
sh Radial_work.sh
```
- Output
  - The removed SNPs are stored in the result folder.
  - The information of IVs of exposure is stored in "~/SVMR/example/2-Radial/exposure_remove".
  - The information of IVs of outcome is stored in "~/SVMR/example/2-Radial/exposure_remove".
- The result obtained in this step is our final selection of IVs.
### Perform MR and Q-test calculations.
- We used five MR methods, they are IVW, Weighted Median, Weighted Mode, MR RAPS and MR Egger.
- Run
```
cd ~/SVMR/example
sh MR_work_1.sh
sh raps.sh
```
- Output
  - MR results will be written into the "~/SVMR/example/3-MR" and "~/SVMR/example/ 5-raps".
  - Q-test results will be written into the "~/SVMR/example/4-Qtest".
- Note: SNPs that need to be removed may be displayed in the log file of this step. These points have palindromic sequences and need to be deleted in the corresponding files.  The files are located in "~/SVMR/example/2-Radial/exposure_remove" and "~/SVMR/example/2-Radial/outcome_remove".
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
  - Results will be written into the "~/SVMR/example/Result".
### Single SNP MR
- Run
```
cd ~/SVMR/example
sh SS.sh
```
- Output
  - Results will be written into the "~/SVMR/example/7-SS".
### MR PRESSO
- Run
```
cd ~/SVMR/example
sh PRESSO.sh
```

- Output
  - Results will be written into the "~/SVMR/example/8-PRESSO".

### 	MR Steiger test
- Run
```
cd ~/SVMR/example
sh Steiger.sh
```
- Output
  - Results will be written into the "~/SVMR/example/9-Steiger ".

## Schematic of MVMR

- Data preparation
 - Combine IVs for multiple phenotypes and pick independent points.
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

