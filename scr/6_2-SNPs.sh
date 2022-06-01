cd ./3-Radial/
mkdir SNPs
for j in `cat ../outcome`
do
	mkdir ./SNPs/${j}
	cd ./SNPs/${j}
	for i in `cat ../../../exposure`
	do
		cp ../../exposure_remove/${j}/${i} ${i}
		sed -i '1d' ${i}
		awk '{print $1}' ${i} > ${i}_1
		wc -l ${i}_1 > ${i}_nsnp
		awk '{print $1}' ${i}_nsnp > ${i}_n
		cat ${i}_1 | xargs > ${i}_2
		sed -i 's/ /,/g' ${i}_2
		paste ${i}_n ${i}_2 > ${i}_3
		rm ${i}
		rm ${i}_1
		rm ${i}_2
		rm ${i}_nsnp
		rm ${i}_n
		mv ${i}_3 ${i}
	done
	cd ../
done

for i in `cat ../../outcome`
do
	python ../../../scr/SNPs.py ./${i}/ ../ ${i}_SNP ${i}
done
