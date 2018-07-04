#!/bin/bash
#LF
#RSEM quantification on filtered bam files (transcriptome ref) for rare disease samples
input_bam=$1 #.Aligned.toTranscriptome.out_mapq30_sorted_dedup.bam format
rsem_dir=~/tools/RSEM-1.3.0/
rsem_reference_prefix=~/projects/quantification/rsem/rsem_reference/Mus_musculus.GRCm38.92.vM17
N_THREADS=4
output_dir_name=$2
sample_name=$(basename ${output_dir_name})
log_file=${output_dir_name}_rnaseqc.log

# reference downloaded from ensembl gencode folder, chr* attached contig names
ref_genome='<(zcat ~/projects/gene_model/mus_musculus_vM17/GRCm38.primary_assembly.genome.fa.gz)'
# gencode=~/projects/gene_model/mus_musculus_vM17/gencode.vM17.primary_assembly.annotation.gtf.gz
gencode='<(gunzip --to-stdout ~/projects/gene_model/mus_musculus_vM17/gencode.vM17.annotation.gtf.gz)'


ref_genome=temp_files/temp.fa
gencode=temp_files/temp1.gtf
# sed -e '/\tgene\t/ s/gene_id \(.ENSMUSG[0-9]*.[0-9]*..\)/\0 transcript_id \1/' temp.gtf
# star and rna_seqc cannot process .gz files
# also <() does not work as file parameter for of star, nor knowning why
# must create intermediate files


# reference downloaed from ensembl, release folder
# ref_genome=~/projects/ref_sequence/GRCm38/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz
# gencode=~/projects/ref_sequence/GRCm38/Mus_musculus.GRCm38.92.gtf.gz

# ref_genome=~/projects/ref_sequence/GRCm38.82/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz
# gencode=~/projects/ref_sequence/GRCm38.82/Mus_musculus.GRCm38.82.gtf.gz


# human hg19 reference and gtf on durga
# ref_genome=/mnt/lab_data/montgomery/shared/genomes/hg19/hg19.fa
# gencode=/mnt/lab_data/montgomery/shared/annotations/gencode.v19.annotation.gtf

rnaseqc_dir=~/tools/RNA-SeQC_1.1.9

# must use java1.7, 1.8 will throw runtime error
java_1_7=/srv/persistent/bliu2/tools/jre1.7.0_80/bin/java


date>$log_file


# Output directory (will be created if doesn't exist).

samtools index ${input_bam}

cmd="${java_1_7} -Xmx20g -jar $rnaseqc_dir/RNA-SeQC.jar \
	-o ${output_dir_name} \
	-n 1000 \
	-t ${gencode} \
	-r ${ref_genome} \
	-noDoC \
	-strictMode \
	-gatkFlags --allow_potentially_misencoded_quality_scores \
	-s $sample_name,$input_bam,$sample_name"
	

	# -ttype 2 #The column in GTF to use to look for rRNA transcript type. Mainly used for running on Ensembl GTF (specify "-ttype 2"). Otherwise, for spec-conforming GTF files, disregard.



echo $cmd
echo $cmd >>$log_file
eval $cmd >>$log_file 2>&1

date>> $log_file


