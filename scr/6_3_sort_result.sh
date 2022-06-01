mkdir ./6-Result/tem
for i in `cat outcome`
do
	cd  ./4-MR/${i}
	sort -k 1 -u ${i}_IVW.txt > ${i}_IVW.txt_1
	sort -k 1 -u ${i}_W-median.txt > ${i}_W-median.txt_1
	sort -k 1 -u ${i}_WM.txt > ${i}_WM.txt_1
	sort -k 1 -u ${i}_Egger.txt > ${i}_Egger.txt_1
	sort -k 1 -u ${i}_Egger-int.txt > ${i}_Egger-int.txt_1
	sort -k 1 -u ${i}_raps.txt > ${i}_raps.txt_1
	awk -F'[\t]' '{print $1}' ${i}_WM.txt_1 >  ../../6-Result/tem/${i}
	cd  ../../6-Result/tem
	sed -i 's/_WM//g' *
	cd  ../../5-Qtest/${i}
	sort -k 1 -u ${i}_IVW_Q.txt > ${i}_IVW_Q.txt_1
	sort -k 1 -u ${i}_egger_Q.txt > ${i}_egger_Q.txt_1
	sort -k 1 -u ${i}_Q-Q_p.txt > ${i}_Q-Q_p.txt_1
	cd  ../../
	python  ../scr/sort_SNPs.py ./3-Radial/${i}_SNP  ./6-Result/tem/${i} ./3-Radial/${i}_SNP_1
        python ../scr/sort_fstatistic.py ./3-Radial/${i}_fstatistic ./6-Result/tem/${i} ./3-Radial/${i}_fstatistic_1
	paste ./4-MR/${i}/${i}_IVW.txt_1 ./4-MR/${i}/${i}_W-median.txt_1 ./4-MR/${i}/${i}_WM.txt_1 ./4-MR/${i}/${i}_raps.txt_1 ./4-MR/${i}/${i}_Egger.txt_1 ./4-MR/${i}/${i}_Egger-int.txt_1 ./5-Qtest/${i}/${i}_IVW_Q.txt_1  ./5-Qtest/${i}/${i}_egger_Q.txt_1 ./5-Qtest/${i}/${i}_Q-Q_p.txt_1  ./3-Radial/${i}_SNP_1 ./3-Radial/${i}_fstatistic_1 > 6-Result/${i}_result.txt
done
