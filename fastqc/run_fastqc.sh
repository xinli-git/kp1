
#!/bin/bash

fastqc_cmd=~/tools/FastQC/fastqc
merged_fastq_dir=~/projects/kp1/fastq/output_merged/
fastqc_output_dir=~/projects/kp1/fastqc/output


for i in $(ls -1 ${merged_fastq_dir}/*_merge_*.fastq.gz)
do
echo $i
if [[ $i =~ (RD[0-9]+.+)\.fastq\.gz ]]; then
	file_prefix=${BASH_REMATCH[1]};
	echo ${file_prefix};
	${fastqc_cmd} --outdir=${fastqc_output_dir} ${merged_fastq_dir}/${file_prefix}.fastq.gz & > ${fastqc_output_dir}/${file_prefix}.fastqc.log ;
fi
done


