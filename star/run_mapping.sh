#!/bin/bash

merged_iastq_dir=~/projects/kp1/fastq/output_merged/
star_index=~/projects/mapping/star/star_index/Mus_musculus.GRCm38.92.vM17.overhang74.index/
star_script=~/projects/kp1/star/star_alignment_kp1.sh
star_bam_output=~/projects/kp1/star/output_bam

ls -1 ${merged_fastq_dir} | awk '{match($1, /[/]*(RD[0-9]+)_merge_R[12]/, arr); print arr[1]}' | sort | uniq | \
awk -v fastq_dir=${merged_fastq_dir} -v bam_output=${star_bam_output} 'BEGIN{OFS="\t"}{print fastq_dir"/"$1"_merge_R1.fastq.gz", fastq_dir"/"$1"_merge_R2.fastq.gz", bam_output"/"$1}' | \
parallel --jobs 5 --col-sep "\t" "${star_script} {1} {2} {3} ${star_index}"



