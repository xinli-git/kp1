
# run quantification piepeline for kp1 project

```{bash}
working_dir=~/projects/kp1/
```

## basecall to fastq directories
```{bash}
bcl2fastq_rundir=${working_dir}/fastq/output/runfolder  #path. change to link to my file name
bcl2fastq_cmd=~/tools/bcl2fastq2/2.20.0/bin/bcl2fastq

fastq_dir=${working_dir}/fastq/output
basecall_dir=${working_dir}/basecall
sampleSheet=${working_dir}/sample/SampleSheet.csv

merged_fastq_dir=${working_dir}/fastq/output_merged
```

## fastqc directories
```{bash}
fastqc_cmd=~/tools/FastQC/fastqc
merged_fastq_dir=${working_dir}/fastq/output_merged/
fastqc_output_dir=${working_dir}/fastqc/output
```

## picard directories
```{bash}
star_bam_output=${working_dir}/star/output_bam
picard_script=${working_dir}/picard/picard_kp1.sh
```

## star directories
```{bash}
merged_fastq_dir=${working_dir}/fastq/output_merged/
star_index=~/projects/mapping/star/star_index/Mus_musculus.GRCm38.92.vM17.overhang74.index/
star_script=${working_dir}/star/star_alignment_kp1.sh
star_bam_output=${working_dir}/star/output_bam
```

## rsem directories
```{bash}
star_bam_output=${working_dir}/star/output_bam
rsem_script=${working_dir}/rsem/rsem_kp1.sh
rsem_output=${working_dir}/rsem/rsem_output
```

## rna-seqc directories
```{bash}
star_bam_output=${working_dir}/star/output_bam
seqc_script=${working_dir}/rna_seqc/rna_seqc_kp1.sh
rna_seqc_output=${working_dir}/rna_seqc/rna_seqc_output
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

