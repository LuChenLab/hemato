
# 01. qc

NanoComp --fastq V959-0101_clean.fastq.gz V959-S01-0101_clean.fastq.gz V959-S01-0102_clean.fastq.gz V959-S01-0103_clean.fastq.gz V959-S01-0104_clean.fastq.gz V959-S01-0105_clean.fastq.gz  \
     --outdir /mnt/raid62/Personal_data/zhangdan/Mouse_HSC/personal/xumengying/analysis/00.QC/01.NanoComp/bam/  \
     --raw --store --tsv_stats -p nanopore



NanoComp --fastq P04DY19171604-1_r64031_20191206_091315_4_G022.ccs.fastq.gz P04DY19171605-1_r64031_20191206_091315_4_G022.ccs.fastq.gz P04DY19171606-1_r64031_20191206_091315_4_G022.ccs.fastq.gz  \
     --outdir /mnt/raid62/Personal_data/zhangdan/Mouse_HSC/personal/xumengying/analysis/00.QC/01.NanoComp/bam/  \
     --raw --store --tsv_stats -p pacbio

# 02. align

## minimap nanopore
for i in $(ls *fastq.gz | awk -F "." '{print $1}');do
  minimap2 -ax splice /mnt/raid64/ref_genomes/MusMus/release93/minimap_index/Mus_musculus.GRCm38.dna.primary_assembly.mmi ./$i.fastq.gz  | samtools view -Sb | samtools sort > /mnt/raid62/Personal_data/zhangdan/Mouse_HSC/personal/xumengying/data/minimap2/Nanopore/$i.sorted.bam
done

## minimap pacbio
for i in $(ls | awk -F "." '{print $1}');do
  minimap2 -ax splice:hq -uf /mnt/raid64/ref_genomes/MusMus/release93/minimap_index/Mus_musculus.GRCm38.dna.primary_assembly.mmi ./$i.ccs.fastq.gz  | samtools view -Sb | samtools sort > /mnt/raid62/Personal_data/zhangdan/Mouse_HSC/personal/xumengying/data/minimap2/Pacbio/$i.sorted.bam
done


# 03. visualized transcript 

## gata2 Chromosome 6: 88,193,891-88,207,032
for i in *bam
do
 samtools view -b  ${i}  6:88193891-88207032 \
 | bedtools bamtobed -bed12 -split \
 | bedToGenePred /dev/stdin /dev/stdout\
 | genePredToGtf  file /dev/stdin   ./ppp/Gata2_${i}.gtf
done

## myc Chromosome 15: 61,985,391-61,990,374 
for i in *bam
do
 samtools view -b  ${i}  15:61986879-61988754 \
 | bedtools bamtobed -bed12 -split \
 | bedToGenePred /dev/stdin /dev/stdout\
 | genePredToGtf  file /dev/stdin   ./Myc_${i}.gtf
done


# 04. sashimi with NGS data

python /mnt/raid61/Personal_data/zhangyiming/code/pysashimi/main.py plot -e  6:88198638-88199522:- \
                     -b /mnt/data3/zhangdan/HSC_scientific_data/Bulk_p100/03sashimi/bam.txt \
                     -g /mnt/data3/zhangdan/HSC_scientific_data/Bulk_p100/03sashimi/Mus_musculus.GRCm38.93.sorted.gtf  \
                     -o /mnt/data3/zhangdan/HSC_scientific_data/Bulk_p100/03sashimi/6_88198638_88199522:-.pdf \
                     --color-factor 3 --no-gene -t 5 \
                     --indicator-lines 88198664,88199789

python /mnt/raid61/Personal_data/zhangyiming/code/pysashimi/main.py plot -e  15:61985303-61985587:- \
                     -b /mnt/data3/zhangdan/HSC_scientific_data/Bulk_p100/03sashimi/bam.txt \
                     -g /mnt/data3/zhangdan/HSC_scientific_data/Bulk_p100/03sashimi/Mus_musculus.GRCm38.93.sorted.gtf  \
                     -o /mnt/data3/zhangdan/HSC_scientific_data/Bulk_p100/03sashimi/15:61985303-61985587:-.pdf \
                     --color-factor 3 --no-gene -t 5 \
                     --indicator-lines 61985564  
