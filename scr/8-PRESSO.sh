for i in `cat ./outcome`
do
	mkdir ./8-PRESSO/${i}
	for j in `cat ./exposure`
	do
		Rscript ../scr/MR_PRESSO_v1.1_.R ./3-Radial/exposure_remove/${i}/${j} ./3-Radial/outcome_remove/${i}/${j} 300 8-PRESSO/${i}/${j}
	done
done

