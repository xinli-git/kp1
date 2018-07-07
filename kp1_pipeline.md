
# run quantification piepeline for each sample of kp1 project, example

## basecall to fastq directories
```{bash}
bcl2fastq_rundir=~/projects/kp1/fastq/output/runfolder  #path. change to link to my file name
bcl2fastq_cmd=~/tools/bcl2fastq2/2.20.0/bin/bcl2fastq

fastq_dir=~/projects/kp1/fastq/output
basecall_dir=~/projects/kp1/basecall
sampleSheet=~/projects/kp1/sample/SampleSheet.csv

merged_fastq_dir=~/projects/kp1/fastq/output_merged
```

## fastqc directories
```{bash}
tqc_cmd=~/tools/FastQC/fastqc
merged_fastq_dir=~/projects/kp1/fastq/output_merged/
fastqc_output_dir=~/projects/kp1/fastqc/output
```

## picard directories
```{bash}
star_bam_output=~/projects/kp1/star/output_bam
picard_script=~/projects/kp1/picard/picard_kp1.sh
```

## star directories
```{bash}
merged_fastq_dir=~/projects/kp1/fastq/output_merged/
star_index=~/projects/mapping/star/star_index/Mus_musculus.GRCm38.92.vM17.overhang74.index/
star_script=~/projects/kp1/star/star_alignment_kp1.sh
star_bam_output=~/projects/kp1/star/output_bam
```

## rsem directories
```{bash}
star_bam_output=~/projects/kp1/star/output_bam
rsem_script=~/projects/kp1/rsem/rsem_kp1.sh
rsem_output=~/projects/kp1/rsem/rsem_output
```

## rna-seqc directories
```{bash}
_seqc_script=~/projects/kp1/rna_seqc/rna_seqc_kp1.sh
rna_seqc_output=~/projects/kp1/rna_seqc/rna_seqc_output
```


## skipped steps
adapter is already cut in bcl2fastq
```{bash}
cutadapt_script=/users/lfresard/repos/rare_disease/scripts/fastq_handling/trim_adapters_150bpreads.sh
date

# adapter sequence can be found in the samplesheet
# bcl2fastq2 already trims the adapter, this step can be skipped

echo 'convert bcl to fastq, de-multiplexing, cutadapter'
echo 'finishing de-multiplexing'

echo 'star trimming'
echo 'end trimming'

echo "start rna-seqc quality control"
echo "done rna-seqc"

date
```

