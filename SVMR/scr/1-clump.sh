mkdir 1-clump
cd ./1-clump
mkdir clump_ori_5e-8_10000 clump_sort_5e-8_10000
plink --bfile reference.file  --clump ../../../data/Carbohydrate --clump-field p --clump-kb 10000 --clump-p1 5e-8 --clump-p2 0.01 --clump-r2 0.001 --out clump_ori_5e-8_10000/Carbohydrate
python ../../scr/sort_clump.py ./clump_ori_5e-8_10000/Carbohydrate.clumped  ../../../data/Carbohydrate clump_sort_5e-8_10000/Carbohydrate
cd ../
