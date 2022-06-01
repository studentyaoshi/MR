for i in `cat outcome`
do
	for j in `cat exposure`
	do
		python ../scr/remove.py rm_snp.list ./2-input/exposure/${i}/${j} ./2-input/exposure/${i}/${j}_1
		rm ./2-input/exposure/${i}/${j}
		mv ./2-input/exposure/${i}/${j}_1 ./2-input/exposure/${i}/${j}
		python ../scr/remove.py rm_snp.list ./2-input/outcome/${i}/${j} ./2-input/outcome/${i}/${j}_1
		rm ./2-input/outcome/${i}/${j}
		mv ./2-input/outcome/${i}/${j}_1 ./2-input/outcome/${i}/${j}
	done
done

