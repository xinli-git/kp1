#!/bin/bash
#LF
#1/Filter for MAPQ>30
#2/Filter for PCR duplicates


bam_file=$1
mapq_sorted=$bam_file
# mapq_suf=$(basename $bam_file .bam)_mapq30.bam
# mapq_sorted=$(basename $mapq_suf .bam)_sorted
dedup_suf=~/projects/kp1/picard/picard_output/$(basename $mapq_sorted .out.bam)_markdup.bam
dedup_metrix=~/projects/kp1/picard/picard_output/$(basename $mapq_sorted .out.bam)_markdup_metrix.txt
# sortedbam=$(basename $dedup_suf .bam)_byread
log_file=~/projects/kp1/picard/picard_output/$(basename $bam_file .out.bam)_filter_bam.log

date > $log_file

# 1/ MAPQ30
# echo 'Filter for mapping quality over 30' >>$log_file

# samtools view -h $bam_file | awk '($5>=30)||($1=="@SQ")'| samtools view -Sbh - > $mapq_suf
# wait
# samtools sort -m 10G $mapq_suf $mapq_sorted
# wait
# rm $mapq_suf

# wait
# 2/ Remove PCR duplicates
# samtools rmdup $mapq_suf $dedup_suf
# rm $mapq_suf

echo 'Mark PCR duplicates' >>$log_file
echo $cmd >> $log_file

cmd="java -Xmx8g -jar ~/tools/picard/picard.jar MarkDuplicates\
	INPUT=$mapq_sorted \
	OUTPUT=$dedup_suf\
	CREATE_INDEX=true \
	VALIDATION_STRINGENCY=SILENT \
	METRICS_FILE=$dedup_metrix \
	REMOVE_DUPLICATES=false \
	TAGGING_POLICY=All"

echo $cmd

# eval not necessary here, will create one more level of expansion e.g. cmd=ls;tmp=cmd;eval \$${tmp} 
eval $cmd >>$log_file 2>&1

# wait

# rm $mapq_sorted.bam
# echo 'sort bam files by read names'>>$log_file
# 3 Sort bam files by read name
# samtools sort -n -m 8G $dedup_suf $sortedbam

# wait
# rm $dedup_suf
# echo 'All done'>>$log_file

date>>$log_file

