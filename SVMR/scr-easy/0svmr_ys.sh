# original path: /home/ys/lib/project/mr/svmr/scr/
# COPY THE PIPELINE IN THE FILEPATH YOU WANT TO GET THE RESULT!
echo 'exposure gwas: '$1 #test: ./getma/GCST90094687.ma
echo 'outcome gwas: '$3 #test: ../ibd.ma
echo 'exposure name: '$2 #test: GCST90094687
echo 'outcome name: '$4 #test: ibd
echo 'clump path:'$5

##1# Selection of the genetic instrumental variables (IVs)#
###plink --silent --bfile /home/zhangkun/data/1000G/ref/EUR/merge/eur.merge --clump $1 --clump-field P --clump-kb 10000 --clump-p1 5e-8 --clump-p2 0.01 --clump-r2 0.001 --out $2
# Note: 
# input 1: exposure gwas summary
# input 2: exposure name
###mv $2.log $2.missingtopvariant
###rm $2.nosex 
python /home/ys/lib/project/mr/svmr/scr/sort_clump.py $5/$2.clumped $1 $2

##2# Get outcome #
python /home/ys/lib/project/mr/svmr/scr/extract_outcome_snp.py $2 $3 $2.$4.outcome
python /home/ys/lib/project/mr/svmr/scr/extract_exposure_snp.py $2.$4.outcome $2 $2.$4.exposure
cut -f 1 $2.$4.exposure|while read line
do grep -w $line $2.$4.outcome
done > $2.$4.outcome.sort
mv $2.$4.outcome.sort $2.$4.outcome
# Note:
# input 3: outcome gwas summary
# input 4: outcome name
grep -F -v -f $2.$4.exposure $2|cut -f 1 > $2.$4.outcomemissing
###if test -s $2.$4.outcomemissing
###then
###        echo "The following IVs for $2 can not be found in $4 GWAS summary and thus calculatetheir LD proxy"
###        cat $2.$4.outcomemissing
###        cat $2.$4.outcomemissing|while read snp
###do
###        plink --silent --bfile /home/zhangkun/data/1000G/ref/EUR/merge/eur.merge --r2 --ld-snp $snp --ld-window-kb 1000 --ld-window 99999 --ld-window-r2 0.8 --out $2.$snp
###        rm $2.$snp.log $2.$snp.nosex
###        sort -rk7 $2.$snp.ld|awk '$6!="$snp" && $6!="SNP_B"{print$6}' > $2.$snp.ldsort
###        python /home/ys/lib/project/mr/svmr/scr/getreplace.py $2.$snp.ldsort $1 $3 $2.$snp.use
###        replacesnp=`cat $2.$snp.use|head -1`
###        if [ -z "$replacesnp" ];then
###                echo "SNPs in proxy with $snp can not found in the $4 gwas summary"
###        elif [ -n "$replacesnp" ];then
###		echo $snp $replacesnp >> $2.$4.replaces
###        fi
        ###rm $2.$snp.ld $2.$snp.ldsort $2.$snp.use
###done
###        if test -s $2.$4.replaces
###        then
###                python /home/ys/lib/project/mr/svmr/scr/replacesnp_ys.py $2.$4.exposure $2.$4.replaces $1 $2.$4.newexposure
###                python /home/ys/lib/project/mr/svmr/scr/extract_outcome_snp.py $2.$4.newexposure $3 $2.$4.newoutcome
###                cut -f 1 $2.$4.newexposure|while read line
###                do
###                        grep -w $line $2.$4.newoutcome
###                done > $2.$4.newoutcome.sort
###                mv $2.$4.newexposure $2.$4.exposure
###                mv $2.$4.newoutcome.sort $2.$4.outcome
###                rm $2.$4.newoutcome
###        else
###                echo "All SNPs in proxy with those IVs can not found in the $4 gwas summary"
###        fi
###else
###        echo "All IVs can be found in the outcome GWAS"
###fi

##3# Remove outcome significant IVs #
awk '$7<5E-8{print$1}' $2.$4.outcome > $2.$4.outcomesig.snp
if test -s $2.$4.outcomesig.snp
then
        echo "These IVs should be removed due to significant associated with the outcome:"
        cat $2.$4.outcomesig.snp
        python /home/ys/lib/project/mr/svmr/scr/rmsnp_ys.py $2.$4.outcomesig.snp $2.$4.exposure $2.$4.newexposure
        python /home/ys/lib/project/mr/svmr/scr/rmsnp_ys.py $2.$4.outcomesig.snp $2.$4.outcome $2.$4.newoutcome
        mv $2.$4.newexposure $2.$4.exposure
        mv $2.$4.newoutcome $2.$4.outcome
else
        echo "All IVs are not associated with the outcome."
fi

##4# Remove outlier pleiotropic IVs #
Rscript /home/ys/lib/project/mr/svmr/scr/RadialMR_Q_remove_v1.0_.R $2.$4.exposure $2.$4.outcome $2.$4.radial
if test -s $2.$4.radial
then
        echo "These IVs should be removed due to MR radial test:"
        cat $2.$4.radial
        python /home/ys/lib/project/mr/svmr/scr/rmsnp_ys.py $2.$4.radial $2.$4.exposure $2.$4.newexposure
        python /home/ys/lib/project/mr/svmr/scr/rmsnp_ys.py $2.$4.radial $2.$4.outcome $2.$4.newoutcome
        mv $2.$4.newexposure $2.$4.exposure
        mv $2.$4.newoutcome $2.$4.outcome
else
        echo "No IVs were removed due to MR radial test."
fi

##5# MR analyses #
Rscript /home/ys/lib/project/mr/svmr/scr/MR_ys.R $2.$4.exposure $2.$4.outcome $2.$4.MR $2.$4.MRSS $2.$4.LOO

