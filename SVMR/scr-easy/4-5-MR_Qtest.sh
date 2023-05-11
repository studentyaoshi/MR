mkdir 4-MR 5-Qtest
####MR analysis using twosampleMR
cd 3-Radial
Rscript ../../scr/MR_twmr_hete_v1.0_.R ./exposure_remove/Acne ./outcome_remove/Acne ../4-MR/Acne_W-median ../4-MR/Acne_IVW ../4-MR/Acne_Egger ../4-MR/Acne_WM ../4-MR/Acne_Egger-int ../5-Qtest/Acne_egger_Q ../5-Qtest/Acne_IVW_Q
Rscript ../../scr/raps.R ./exposure_remove/Acne ./outcome_remove/Acne ../4-MR/Acne_raps
Rscript ../../scr/MR_twmr_Qtest_v1.2_.R ./exposure_remove/Acne ./outcome_remove/Acne ../5-Qtest/Acne_Q-Q_p
cd ../

####sort MR result
cd ./4-MR/
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
python ../../scr/summary.py ./IVW/ ./ IVW MDD
python ../../scr/summary.py ./Egger/ ./ Egger MDD
python ../../scr/summary.py ./W-median/ ./ W-median MDD
python ../../scr/summary.py ./WM/ ./ WM MDD
python ../../scr/summary.py ./Egger-int/ ./ Egger-int MDD
python ../../scr/summary.py ./raps/ ./ raps MDD
cd ../
cd ./5-Qtest
mkdir final
mkdir IVW_Q
mkdir egger_Q
mv *_Q-Q_p final
mv *_IVW_Q IVW_Q
mv *_egger_Q egger_Q
python ../../scr/Qtest_summary.py ./final/ ./ Q-Q_p MDD
python ../../scr/Qtest_summary_2.py ./IVW_Q/ ./ IVW_Q MDD
python ../../scr/Qtest_summary_2.py ./egger_Q/ ./ egger_Q MDD
