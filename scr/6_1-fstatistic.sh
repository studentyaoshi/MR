cd ./3-Radial/
mkdir fstatistic
for i in `cat ../outcome`
do
	mkdir ./fstatistic/${i}
	cd ./fstatistic/${i}
	for j in `cat ../../../exposure`
	do
		python ../../../../scr/fstatistic_2.py ../../exposure_remove/${i}/${j} ${j}
	done
	cd ../
done

for i in `cat ../../outcome`
do
	python ../../../scr/fstatistic_sort.py ./${i}/ ../ ${i}_fstatistic ${i}
done
