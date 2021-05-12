# Rseqc
## genebody coverage
cd /mnt/data3/zhangdan/HSC_scientific_data/cache/RSEQc_result/Smartseq2
cat name.txt|xargs -P 8 -I {} python /mnt/data1/chenli/soft/geneBody_coverage.py \
	 -i /mnt/raid63/HSC/mouse/singleCell/SMARTseq/SMARTseq2_HSC_MPP/align/{}.Aligned.sortedByCoord.out.bam \
	  -r /mnt/raid64/ref_genomes/MusMus/release93/Mus_musculus.GRCm38.93.sorted.bed12 \
	   -o gene_body/{}


## reads distribution
cd /mnt/data3/zhangdan/HSC_scientific_data/cache/RSEQc_result/Smartseq2/read_distribution
cat name.txt | awk '{print "read_distribution.py -i /mnt/raid63/HSC/mouse/singleCell/SMARTseq/SMARTseq2_HSC_MPP/align/"$1".Aligned.sortedByCoord.out.bam -r /mnt/raid64/ref_genomes/MusMus/release93/Mus_musculus.GRCm38.93.sorted.bed12 >"$1"_result.txt" }' >> read_distribution.sh
mv read.distribution.sh read.distribution/
bash read.distribution.sh

cd /mnt/data3/zhangdan/HSC_scientific_data/cache/RSEQc_result/Smartseq2/read_distribution
ls|awk -F "_" '{print $1}' | awk '{print "sed -n '5,15p' "$1"_result.txt > "$1".UTR.txt"}' >> UTR.sh
bash UTR.sh


## extract various gene regions
cd /mnt/data3/zhangdan/HSC_scientific_data/cache/RSEQc_result/Smartseq2/read_distribution
for i in $(cat ../name.txt)
do
	sed -n "5,15p" ./${i}_result.txt > ${i}.UTR.txt
done


## TIN (transcript integrity number)
cd /mnt/data3/zhangdan/HSC_scientific_data/cache/RSEQc_result/Smartseq2/TIN
cat ../name.txt | xargs -P 8 -I {} tin.py -i /mnt/raid63/HSC/mouse/singleCell/SMARTseq/SMARTseq2_HSC_MPP/align/{}.Aligned.sortedByCoord.out.bam \
	-r /mnt/raid64/ref_genomes/MusMus/release93/Mus_musculus.GRCm38.93.sorted.bed12 
cat *.summary.txt|awk '!(NR%2){print}' >TIN_summary.txt
