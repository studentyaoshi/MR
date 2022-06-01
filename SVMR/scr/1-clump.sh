cd ./1-clump
mkdir clump_ori_5e-8_10000 clump_sort_5e-8_10000
for i in `cat ../exposure`
do
	plink --bfile reference.file  --clump ../../../data/${i} --clump-field p --clump-kb 10000 --clump-p1 5e-8 --clump-p2 0.01 --clump-r2 0.001 --out clump_ori_5e-8_10000/${i}
	python ../../scr/sort_clump.py ./clump_ori_5e-8_10000/${i}.clumped  ../../../data/${i} clump_sort_5e-8_10000/${i}
done
