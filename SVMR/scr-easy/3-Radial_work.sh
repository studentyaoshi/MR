mkdir 3-Radial
####sort input data
cd 2-input/exposure
sort -k 1 Acne |sed '$d' > Acne.tem
sed -i '1i\SNP\tA1\tA2\tEAF\tbeta\tse\tp\tN' Acne.tem
rm Acne
mv Acne.tem Acne
cd ../../
	
cd 2-input/outcome
sort -k 1 Acne |sed '$d' > Acne.tem
sed -i '1i\SNP\tA1\tA2\tEAF\tbeta\tse\tp\tN' Acne.tem
rm Acne
mv Acne.tem Acne
cd ../../

mkdir 3-Radial/result
mkdir 3-Radial/exposure_remove
mkdir 3-Radial/outcome_remove
####Radial MR
Rscript ../scr/RadialMR_Q_remove_v1.0_.R 2-input/exposure/Acne 2-input/outcome/Acne 3-Radial/result/Acne

####select IV after radialMR
python ../scr/remove_rad_snp.py 3-Radial/result/Acne 2-input/exposure/Acne 3-Radial/exposure_remove/Acne
python ../scr/remove_rad_snp.py 3-Radial/result/Acne 2-input/outcome/Acne 3-Radial/outcome_remove/Acne
