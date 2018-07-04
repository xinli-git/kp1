#!/bin/bash
#LF
#STAR_2.4.0j
set -o nounset -o pipefail



# read command line arguments: 
read1=$1
read2=$2
prefix=$3
INDEX_DIRECTORY=$4 #~/projects/mapping/star/star_index/Mus_musculus.GRCm38.92.vM17.overhang74.index

cmd=\
"STAR \
    --genomeDir $INDEX_DIRECTORY \
    --readFilesIn $read1 $read2 \
	--outFileNamePrefix ${prefix}. \
	--readFilesCommand zcat \
	--outSAMattributes NH HI AS nM NM MD jM jI\
	--outFilterType BySJout \
	--runThreadN 8 \
	--outBAMsortingThreadN 8 \
	--outSAMtype BAM SortedByCoordinate \
	--outSAMunmapped Within \
	--quantMode TranscriptomeSAM\
	--genomeLoad LoadAndKeep \
	--limitBAMsortRAM 15000000000 \
	--chimSegmentMin 20 \
	--outSAMattrRGline ID:${prefix} SM:${1}_${2} CN:kevin_smith LB:kp1_axelrod"
    
date
echo $cmd
$cmd
date

