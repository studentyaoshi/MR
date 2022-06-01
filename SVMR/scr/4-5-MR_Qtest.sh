####MR analysis using twosampleMR
cd 3-Radial
for i in `cat ../outcome`
do
	mkdir ../4-MR/${i}
	mkdir ../5-Qtest/${i}
	for j in `cat ../exposure`
	do
		Rscript ../../scr/MR_twmr_hete_v1.0_.R ./exposure_remove/${i}/${j} ./outcome_remove/${i}/${j} ../4-MR/${i}/${j}_W-median ../4-MR/${i}/${j}_IVW ../4-MR/${i}/${j}_Egger ../4-MR/${i}/${j}_WM ../4-MR/${i}/${j}_Egger-int ../5-Qtest/${i}/${j}_egger_Q ../5-Qtest/${i}/${j}_IVW_Q
		Rscript ../../scr/raps.R ./exposure_remove/${i}/${j} ./outcome_remove/${i}/${j} ../4-MR/${i}/${j}_raps
		Rscript ../../scr/MR_twmr_Qtest_v1.2_.R ./exposure_remove/${i}/${j} ./outcome_remove/${i}/${j} ../5-Qtest/${i}/${j}_Q-Q_p
	done
done
cd ../

####sort MR result
for i in `cat outcome`
do
	cd ./4-MR/${i}
	mkdir IVW
	mkdir Egger
	mkdir W-median
	mkdir WM
	mkdir Egger-int
	mkdir raps
	mv *_IVW IVW
	mv *_W-median W-median
	mv *_Egger Egger
	mv *_WM WM
	mv *_Egger-int Egger-int
	mv *_raps raps
	python ../../../scr/summary.py ./IVW/ ./ IVW ${i}
	python ../../../scr/summary.py ./Egger/ ./ Egger ${i}
	python ../../../scr/summary.py ./W-median/ ./ W-median ${i}
	python ../../../scr/summary.py ./WM/ ./ WM ${i}
	python ../../../scr/summary.py ./Egger-int/ ./ Egger-int ${i}
	python ../../../scr/summary.py ./raps/ ./ raps ${i}
done
cd ../../
for i in `cat outcome`
do
	cd ./5-Qtest/${i}
	mkdir final
	mkdir IVW_Q
	mkdir egger_Q
	mv *_Q-Q_p final
	mv *_IVW_Q IVW_Q
	mv *_egger_Q egger_Q
	python  ../../../scr/Qtest_summary.py ./final/ ./ Q-Q_p ${i}
	python ../../../scr/Qtest_summary_2.py ./IVW_Q/ ./ IVW_Q ${i}
	python ../../../scr/Qtest_summary_2.py ./egger_Q/ ./ egger_Q ${i}
done
