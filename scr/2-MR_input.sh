mkdir 2-input/exposure
mkdir 2-input/outcome
#### outcome data
for i in `cat outcome`
do
	mkdir 2-input/exposure/${i}
	mkdir 2-input/outcome/${i}
	for j in `cat exposure`
	do
		python ../scr/extract_outcome_snp.py 1-clump/clump_sort_5e-8_10000/${j} ~/data/diet/${i} 2-input/outcome/${i}/${j}
	done
done

#### exposure data
for i in `cat outcome`
do
	for j in `cat exposure`
	do
		python ../scr/extract_exposure_snp.py 2-input/outcome/${i}/${j} 1-clump/clump_sort_5e-8_10000/${j} 2-input/exposure/${i}/${j}
	done
done
