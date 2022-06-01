for i in `cat ./outcome`
do
	mkdir 9-Steiger/${i}
	for j in `cat ./exposure`
	do
		Rscript ../scr/MR_twmr_Steiger_filtering_.R  ./3-Radial/exposure_remove/${i}/${j} ./3-Radial/outcome_remove/${i}/${j} 9-Steiger/${i}/${j}
	done
done
