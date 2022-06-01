####sort input data
for i in `cat outcome`
do
	cd 2-input/exposure/${i}
	for j in `cat ../../../exposure`
	do
		sort -k 1 ${j} |sed '$d' > ${j}.tem
		sed -i '1i\SNP\tA1\tA2\tEAF\tbeta\tse\tp\tN' ${j}.tem
		rm ${j}
		mv ${j}.tem ${j}
	done
	cd ../../../
done
for i in `cat outcome`
do
	cd 2-input/outcome/${i}
	for j in `cat ../../../exposure`
	do
		sort -k 1 ${j} |sed '$d' > ${j}.tem
		sed -i '1i\SNP\tA1\tA2\tEAF\tbeta\tse\tp\tN' ${j}.tem
		rm ${j}
		mv ${j}.tem ${j}
	done
	cd ../../../
done
mkdir 3-Radial/result
mkdir 3-Radial/exposure_remove
mkdir 3-Radial/outcome_remove
####Radial MR
for i in `cat outcome`
do
	mkdir 3-Radial/result/${i}
	for j in `cat exposure`
	do
		Rscript ../scr/RadialMR_Q_remove_v1.0_.R 2-input/exposure/${i}/${j} 2-input/outcome/${i}/${j} 3-Radial/result/${i}/${j}
	done
done

####select IV after radialMR
for i in `cat outcome`
do
	mkdir 3-Radial/exposure_remove/${i}
	mkdir 3-Radial/outcome_remove/${i}
	for j in `cat exposure`
	do
		python ../scr/remove_rad_snp.py 3-Radial/result/${i}/${j} 2-input/exposure/${i}/${j} 3-Radial/exposure_remove/${i}/${j}
		python ../scr/remove_rad_snp.py 3-Radial/result/${i}/${j} 2-input/outcome/${i}/${j} 3-Radial/outcome_remove/${i}/${j}
	done
done

