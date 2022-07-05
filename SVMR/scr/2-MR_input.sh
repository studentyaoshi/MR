mkdir 2-input
mkdir 2-input/exposure
mkdir 2-input/outcome
#### outcome data
python ../scr/extract_outcome_snp.py 1-clump/clump_sort_5e-8_10000/Carbohydrate ../../data/MDD 2-input/outcome/Carbohydrate

#### exposure data
python ../scr/extract_exposure_snp.py 2-input/outcome/Carbohydrate 1-clump/clump_sort_5e-8_10000/Carbohydrate 2-input/exposure/Carbohydrate
