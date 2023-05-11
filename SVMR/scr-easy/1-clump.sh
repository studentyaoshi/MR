mkdir 1-clump
cd ./1-clump
mkdir clump_ori_5e-8_10000 clump_sort_5e-8_10000
plink --bfile /home/zhangkun/data/1000G/ref/EUR/merge/eur.merge  --clump ../../../data/acne.sig.ma --clump-field p --clump-kb 10000 --clump-p1 5e-8 --clump-p2 0.01 --clump-r2 0.001 --out clump_ori_5e-8_10000/Acne
python ../../scr/sort_clump.py ./clump_ori_5e-8_10000/Acne.clumped  ../../../data/acne.sig.ma clump_sort_5e-8_10000/Acne
cd ../
