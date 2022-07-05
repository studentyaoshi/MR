mkdir 3-Radial
####sort input data
cd 2-input/exposure
sort -k 1 Carbohydrate |sed '$d' > Carbohydrate.tem
sed -i '1i\SNP\tA1\tA2\tEAF\tbeta\tse\tp\tN' Carbohydrate.tem
rm Carbohydrate
mv Carbohydrate.tem Carbohydrate
cd ../../
	
cd 2-input/outcome
sort -k 1 Carbohydrate |sed '$d' > Carbohydrate.tem
sed -i '1i\SNP\tA1\tA2\tEAF\tbeta\tse\tp\tN' Carbohydrate.tem
rm Carbohydrate
mv Carbohydrate.tem Carbohydrate
cd ../../

mkdir 3-Radial/result
mkdir 3-Radial/exposure_remove
mkdir 3-Radial/outcome_remove
####Radial MR
Rscript ../scr/RadialMR_Q_remove_v1.0_.R 2-input/exposure/Carbohydrate 2-input/outcome/Carbohydrate 3-Radial/result/Carbohydrate

####select IV after radialMR
python ../scr/remove_rad_snp.py 3-Radial/result/Carbohydrate 2-input/exposure/Carbohydrate 3-Radial/exposure_remove/Carbohydrate
python ../scr/remove_rad_snp.py 3-Radial/result/Carbohydrate 2-input/outcome/Carbohydrate 3-Radial/outcome_remove/Carbohydrate
