## decompression
cd /mnt/data3/zhangdan/HSC_scientific_data/cache/FastQC_result/Smartseq2/fastqc
cp /mnt/raid63/HSC/mouse/singleCell/SMARTseq/SMARTseq2_HSC_MPP/fastq/QC/*.zip .
cat ../name.txt|xargs -P 10 -I {} unzip {}_*.zip

## extract base data(fastqc) to *base.txt (R1, R2)
cd /mnt/data3/zhangdan/HSC_scientific_data/cache/FastQC_result/Smartseq2/
for i in $(cat name.txt)
do
	sed -n "13,51p" fastqc/${i}_R2_fastqc/fastqc_data.txt > base/${i}.R2_base.txt
done


for i in $(cat name.txt)
do
	sed -n "13,51p" fastqc/${i}_R1_fastqc/fastqc_data.txt > base/${i}.R1_base.txt
done

## extract duplicate data(fastqc) to *duplicate.txt (R1, R2)
for i in $(cat name.txt)
do
	grep -A16 '#Duplication Level' fastqc/${i}_R1_fastqc/fastqc_data.txt > duplicate/${i}.R1_duplicate.txt
done

for i in $(cat name.txt)
do
	grep -A16 '#Duplication Level' fastqc/${i}_R2_fastqc/fastqc_data.txt > duplicate/${i}.R2_duplicate.txt
done


## extract GC%
# tmp <- fread('/mnt/data1/chenli/cell_T/FastQC_result/multiQC/multiqc_report_polyARNA_data/multiqc_fastqc.txt')
# tmp <- tmp[,.(GC = mean(`%GC`)),by=donor]
# write.table(tmp, file = "/mnt/data1/chenli/cell_T/FastQC_result/multiQC/multiqc_report_polyARNA_data/polyA_GC.txt", row.names = F, col.names=F,quote = F, sep="\t")



## calculate Q30
cd /mnt/raid63/HSC/mouse/singleCell/SMARTseq/SMARTseq2_HSC_MPP/fastq/PM-SC170049-09/Cleandata/#####change 09,10,11,12,13
for i in $(ls)
do
	python /mnt/data1/chenli/soft/q30/q30.py ./${i}/${i}_R2.fq.gz > /mnt/data3/zhangdan/HSC_scientific_data/cache/FastQC_result/Smartseq2/Q30/${i}.Q30.R2.txt
done

for i in $(ls)
do
	python /mnt/data1/chenli/soft/q30/q30.py ./${i}/${i}_R1.fq.gz > /mnt/data3/zhangdan/HSC_scientific_data/cache/FastQC_result/Smartseq2/Q30/${i}.Q30.R1.txt
done






## extract Q30
cd /mnt/data3/zhangdan/HSC_scientific_data/cache/FastQC_result/Smartseq2/Q30
for i in `ls *.txt`
do
	grep -H "q30 p" $i | awk -F "[:,(')]" '{print $1$7}' >> summary.txt
done

## Multiqc STAR
multiqc /mnt/raid63/HSC/mouse/singleCell/SMARTseq/SMARTseq2_HSC_MPP/align/*.Log.final.out

