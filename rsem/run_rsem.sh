#!/bin/bash



star_bam_output=~/projects/kp1/star/output_bam
picard_script=~/projects/kp1/picard/picard_kp1.sh

# RD014.Aligned.sortedByCoord.out.bam
# RD014.Aligned.toTranscriptome.out.bam


merged_fastq_dir=~/projects/kp1/fastq/output_merged/
star_index=~/projects/mapping/star/star_index/Mus_musculus.GRCm38.92.vM17.overhang74.index/
star_script=~/projects/kp1/star/star_alignment_kp1.sh


rsem_script=~/projects/kp1/rsem/rsem_kp1.sh
rsem_output=~/projects/kp1/rsem/rsem_output



ls -1 $star_bam_output/*.toTranscriptome.out.bam | awk '{match($1, /[/]*(RD[0-9]+.*)\.out\.bam/, arr); print arr[1]}' | sort | uniq | \
awk -v star_bam_output=$star_bam_output -v rsem_output=$rsem_output 'BEGIN{OFS="\t"}{print star_bam_output"/"$1".out.bam", rsem_output"/"$1}' | \
parallel --jobs 24 --col-sep "\t" "${rsem_script} {1} {2}"







