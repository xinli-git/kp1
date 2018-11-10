#!/bin/bash
#LF
#RSEM quantification on filtered bam files (transcriptome ref) for rare disease samples
input_bam=$1 #.Aligned.toTranscriptome.out_mapq30_sorted_dedup.bam format
rsem_dir=~/tools/RSEM-1.3.0/
rsem_reference_prefix=~/projects/quantification/rsem/rsem_reference/Mus_musculus.GRCm38.92.vM17/Mus_musculus.GRCm38.92.vM17
N_THREADS=4
sample_name=$2
log_file=${sample_name}_rsem.log




date>$log_file

cmd="$rsem_dir/rsem-calculate-expression \
	--num-threads $N_THREADS \
	--fragment-length-max 1000 \
	--paired-end \
	--no-bam-output \
	--estimate-rspd \
	--strandedness reverse \
	--seed 12345 \
	--alignments \
	$input_bam \
	$rsem_reference_prefix \
	$sample_name"

echo $cmd
echo $cmd >>$log_file
eval $cmd >>$log_file 2>&1

date>> $log_file


# --strandedness <none|forward|reverse>
# This option defines the strandedness of the RNA-Seq reads. It recognizes three values: 'none', 'forward', and 'reverse'. 'none' refers to non-strand-specific protocols. 'forward' means all (upstream) reads are derived from the forward strand. 'reverse' means all (upstream) reads are derived from the reverse strand. If 'forward'/'reverse' is set, the '--norc'/'--nofw' Bowtie/Bowtie 2 option will also be enabled to avoid aligning reads to the opposite strand. For Illumina TruSeq Stranded protocols, please use 'reverse'. (Default: 'none')



