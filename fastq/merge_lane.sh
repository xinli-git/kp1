#!/bin/bash

fastq_dir=~/projects/kp1/fastq/output
merged_fastq_dir=~/projects/kp1/fastq/output_merged

#suffix of input fastq files
SUF_R1=_R1_001.fastq.gz
SUF_R2=_R2_001.fastq.gz
#suffix of output files
OUT1_SUF=merge_R1.fastq.gz
OUT2_SUF=merge_R2.fastq.gz

# If array is present, it is cleared, and then the zeroth element of array is set to the entire portion of string matched by regexp. If regexp contains parentheses, the integer-indexed elements of array are set to contain the portion of string matching the corresponding parenthesized subexpression. 

indiv=$(ls -1 ${fastq_dir}/RD*_001.fastq.gz | awk '{ match($0, /(RD[0-9]+)_/, arr); print arr[1]}' | sort | uniq)

for i in $indiv
do
	echo $i
	zcat $FASTQ_DIR/${i}_*L00*${SUF_R1} | gzip >${merged_fastq_dir}/${i}_${OUT1_SUF} 
	zcat $FASTQ_DIR/${i}_*L00*${SUF_R2} | gzip >${merged_fastq_dir}/${i}_${OUT2_SUF}
done




