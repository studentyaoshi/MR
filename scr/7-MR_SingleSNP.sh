for i in `cat ./outcome`
do
	mkdir 7-SingleSNP_MR/${i}
	for j in `cat ./exposure`
	do
		Rscript ../scr/MR_twmr_SStable_v1.0_.R ./3-Radial/exposure_remove/${i}/${j} ./3-Radial/outcome_remove/${i}/${j} ./7-SingleSNP_MR/${i}/${j}_SS
	done
done
