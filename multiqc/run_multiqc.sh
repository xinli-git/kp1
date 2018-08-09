#!/bin/bash


module load multiqc/1.5
# multiqc ../fastqc/output ../rna_seqc/rna_seqc_output ../star/output_bam ../rsem/rsem_output ../picard/picard_output
multiqc ../data_scratch/fastqc ../data_scratch/rna_seqc ../data_scratch/star ../data_scratch/rsem ../data_scratch/picard


