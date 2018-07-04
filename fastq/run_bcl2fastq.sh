#!/bin/bash


runName=$1                # e.g. 180317_NS500418_0806_AHVCGWBGX3 
runLabel=$2               # e.g. label I want to name my job

bcl2fastq_rundir=~/projects/kp1/fastq/output/runfolder  #path. change to link to my file name
bcl2fastq_cmd=~/tools/bcl2fastq2/2.20.0/bin/bcl2fastq


fastq_dir=~/projects/kp1/fastq/output
basecall_dir=~/projects/kp1/basecall
sampleSheet=~/projects/kp1/sample/SampleSheet.csv


	cmd="${bcl2fastq_cmd} \
		--sample-sheet $sampleSheet \
		--input-dir ${basecall_dir} \
    		--runfolder-dir ${bcl2fastq_rundir} \
    		--output-dir ${fastq_dir} \
    		--minimum-trimmed-read-length 50 \
    		--stats-dir ${fastq_dir}/Stats/ \
    		--reports-dir ${fastq_dir}/Reports/"
	
echo ${cmd}
$cmd




