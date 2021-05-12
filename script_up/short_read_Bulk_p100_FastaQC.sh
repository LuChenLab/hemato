## zhangdan run fastqc

cd /mnt/data3/zhangdan/HSC_scientific_data/cache/fastq
for i in `cat name.txt`
do 
	bash /mnt/raid61/Personal_data/lizhidan/scripts/rnaPipeline/bash/01_01_fastqc.bash \
		-i /mnt/raid63/HSC/mouse/bulk/SMARTseq2_HSC_MPP/fastq/ANNO_ANYWSC170049_PM-YWSC170049-02_2019-11-04/Cleandata/$i \
		-o ./ -p 8 -n $i
done
multiqc ./*_fastqc.zip -o ./


cd /mnt/data3/zhangdan/HSC_scientific_data/cache/fastq2
for i in `cat ../name.txt`
do 
	bash /mnt/raid61/Personal_data/lizhidan/scripts/rnaPipeline/bash/01_01_fastqc.bash \
		-i /mnt/raid63/HSC/mouse/bulk/SMARTseq2_HSC_MPP/fastq/p100/Cleandata/$i \
		-o ./ -p 8 -n $i
done
multiqc ./*_fastqc.zip -o ./mnt/data3/zhangdan/HSC_scientific_data/cache/FastQC_result/Bulk_p100/MultiQC/multiqc_data 



## decompression
cd /mnt/data3/zhangdan/HSC_scientific_data/cache/
cat ../name.txt|xargs -P 7 -I {} unzip {}_*.zip

## extract base data(fastqc) to *base.txt (R1, R2)
for i in $(cat /mnt/data3/zhangdan/HSC_scientific_data/cache/FastQC_result/Bulk_p100/name.txt)
do
	sed -n "13,51p" ./${i}_R2_fastqc/fastqc_data.txt > ../base/${i}.R2_base.txt
done

## extract duplicate data(fastqc) to *duplicate.txt (R1, R2)
for i in $(cat /mnt/data3/zhangdan/HSC_scientific_data/cache/FastQC_result/Bulk_p100/name.txt)
do
	grep -A16 '#Duplication Level' ./${i}_R1_fastqc/fastqc_data.txt > ../duplicate/${i}.R1_duplicate.txt
done


## extract GC%
# tmp <- fread('/mnt/data1/chenli/cell_T/FastQC_result/multiQC/multiqc_report_polyARNA_data/multiqc_fastqc.txt')
# tmp <- tmp[,.(GC = mean(`%GC`)),by=donor]
# write.table(tmp, file = "/mnt/data1/chenli/cell_T/FastQC_result/multiQC/multiqc_report_polyARNA_data/polyA_GC.txt", row.names = F, col.names=F,quote = F, sep="\t")



## calculate Q30
cd /mnt/raid63/HSC/mouse/bulk/SMARTseq2_HSC_MPP/fastq/ANNO_ANYWSC170049_PM-YWSC170049-02_2019-11-04/Cleandata
for i in $(ls)
do
	python /mnt/data1/chenli/soft/q30/q30.py ./${i}/${i}_R2.fq.gz > /mnt/data3/zhangdan/HSC_scientific_data/cache/FastQC_result/Bulk_p100/Q30/${i}.Q30.R2.txt
done


cd /mnt/raid63/HSC/mouse/bulk/SMARTseq2_HSC_MPP/fastq/ANNO_ANYWSC170049_PM-YWSC170049-02_2019-11-04/Cleandata
for i in $(ls)
do
	python /mnt/data1/chenli/soft/q30/q30.py ./${i}/${i}_R1.fq.gz > /mnt/data3/zhangdan/HSC_scientific_data/cache/FastQC_result/Bulk_p100/Q30/${i}.Q30.R1.txt
done



cd /mnt/raid63/HSC/mouse/bulk/SMARTseq2_HSC_MPP/fastq/p100/Cleandata
for i in $(ls)
do
	python /mnt/data1/chenli/soft/q30/q30.py ./${i}/${i}_R2.fq.gz > /mnt/data3/zhangdan/HSC_scientific_data/cache/FastQC_result/Bulk_p100/Q30/${i}.Q30.R2.txt
done

cd /mnt/raid63/HSC/mouse/bulk/SMARTseq2_HSC_MPP/fastq/p100/Cleandata
for i in $(ls)
do
	python /mnt/data1/chenli/soft/q30/q30.py ./${i}/${i}_R1.fq.gz > /mnt/data3/zhangdan/HSC_scientific_data/cache/FastQC_result/Bulk_p100/Q30/${i}.Q30.R1.txt
done


## extract Q30
cd /mnt/data3/zhangdan/HSC_scientific_data/cache/FastQC_result/Bulk_p100/Q30
for i in `ls *.txt`
do
	grep -H "q30 p" $i | awk -F "[:,(')]" '{print $1$7}' >> summary.txt
done


# Multiqc
multiqc /mnt/raid63/HSC/mouse/bulk/SMARTseq2_HSC_MPP/align/*.Log.final.out
