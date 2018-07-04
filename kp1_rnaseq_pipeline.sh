#!/bin/bash
#January 2018
#LF



#run quantification piepeline for each sample of kp1 project, example

# basecall to fastq directories

bcl2fastq_rundir=~/projects/kp1/fastq/output/runfolder  #path. change to link to my file name
bcl2fastq_cmd=~/tools/bcl2fastq2/2.20.0/bin/bcl2fastq

fastq_dir=~/projects/kp1/fastq/output
basecall_dir=~/projects/kp1/basecall
sampleSheet=~/projects/kp1/sample/SampleSheet.csv

merged_fastq_dir=~/projects/kp1/fastq/output_merged

# fastqc directories

tqc_cmd=~/tools/FastQC/fastqc
merged_fastq_dir=~/projects/kp1/fastq/output_merged/
fastqc_output_dir=~/projects/kp1/fastqc/output

# picard directories

star_bam_output=~/projects/kp1/star/output_bam
picard_script=~/projects/kp1/picard/picard_kp1.sh

# star directories

merged_fastq_dir=~/projects/kp1/fastq/output_merged/
star_index=~/projects/mapping/star/star_index/Mus_musculus.GRCm38.92.vM17.overhang74.index/
star_script=~/projects/kp1/star/star_alignment_kp1.sh
star_bam_output=~/projects/kp1/star/output_bam

# rsem directories

star_bam_output=~/projects/kp1/star/output_bam
rsem_script=~/projects/kp1/rsem/rsem_kp1.sh
rsem_output=~/projects/kp1/rsem/rsem_output

# skipped step
# adapter is already cut in bcl2fastq
cutadapt_script=/users/lfresard/repos/rare_disease/scripts/fastq_handling/trim_adapters_150bpreads.sh

date

# adapter sequence can be found in the samplesheet
# bcl2fastq2 already trims the adapter, this step can be skipped

echo 'convert bcl to fastq, de-multiplexing, cutadapter'
echo 'finishing de-multiplexing'

echo 'start trimming'
echo 'done trimming'

echo 'star fastqc'
echo 'done fastqc'

echo 'star picard mark duplicates'
echo 'done mark duplicates'

echo "start mapping"
echo "mapping finished"

echo "start quantifying"
echo "finished quantifying"

echo "start rna-seqc quality control"
echo "done rna-seqc"

date

