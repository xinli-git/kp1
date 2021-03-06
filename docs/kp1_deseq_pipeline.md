
# kp1/deseq2 analysis

## 1. prepare deseq2 input from rsem output

https://bioconductor.org/packages/3.7/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#transcript-abundance-files-and-tximport-input

http://bioconductor.org/packages/release/bioc/vignettes/tximport/inst/doc/tximport.html#rsem

check which R is compatible with tximport,
use if none compatible /users/lfresard/R_3.3.2/bin/R
```{r}
which R
module avail
```

```{bash}
module load r/3.4.2
R
```

install deseq and dependent packages (if first time run)
```{r}
source("https://bioconductor.org/biocLite.R")
biocLite("tximport")
biocLite("readr")
biocLite("DESeq2")
biocLite("pcaExplorer")
biocLite("regionReport")
biocLite("ReportingTools")
biocLite("EnsDb.Mmusculus.v79")
```

load sample file
```{r}
dir <- "~/projects/kp1/"
samples <- read.table(file.path(dir, "sample", "kp1_sample_table.txt"), header=TRUE)
```

prepare deseq input data structure
```{r}
library("tximport")
library("readr")
files <- file.path(dir, "rsem", "rsem_output", paste0(samples$rna_lib, ".Aligned.toTranscriptome.genes.results"))
names(files) <- paste0("rna_", samples$rna_lib)
txi.rsem <- tximport(files, type = "rsem", txIn = FALSE, txOut = FALSE)
head(txi.rsem$counts)

files <- file.path(dir, "rsem", "rsem_output", paste0(samples$rna_lib, ".Aligned.toTranscriptome.isoforms.results"))
names(files) <- paste0("rna_", samples$rna_lib)
txi_isoform.rsem <- tximport(files, type = "rsem", txIn = TRUE, txOut = TRUE)
```

https://support.bioconductor.org/p/92763/
edit effect length 0
```{r}
txi.rsem$length[txi.rsem$length == 0] <- 1
```

```{r}
write.table(txi.rsem$abundance, file = file.path(dir, "docs", "rsem", "kp1_fpkm.txt"), append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")
```

## 2. deseq2 and p-values

* by default, last design variable is used for contrast, other used as covariates
* https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#note-on-factor-levels
* https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#multi-factor-designs
```{r}
library("DESeq2")

ddsTxi <- DESeqDataSetFromTximport(txi.rsem, colData = samples, design = ~ tissue + age + condition)
ddsTxi$condition <- relevel(ddsTxi$condition, ref = "WT")

ddsTxi <- DESeq(ddsTxi)

resTxi_WTvsHET = results(ddsTxi, contrast = c("condition", "WT", "Het"))
resTxi_WTvsKO = results(ddsTxi, contrast = c("condition", "WT", "KO"))
```

```{r}
save.image(file="~/projects/kp1/deseq/deseq_output/kp1_deseq_11092018.RData")
savehistory("~/projects/kp1/deseq/deseq_output/kp1_deseq.Rhistory")
```

```{r}
P1_samples = samples[samples[,"age"] == 'P1',];
P1_rna = P1_samples[,'rna_lib'];
P1_txi.rsem = txi.rsem; P1_txi.rsem$abundance = P1_txi.rsem$abundance[,P1_rna]; P1_txi.rsem$counts = P1_txi.rsem$counts[,P1_rna]; P1_txi.rsem$length = P1_txi.rsem$length[,P1_rna];
P1_ddsTxi <- DESeqDataSetFromTximport(P1_txi.rsem, colData = P1_samples, design = ~ condition)
P1_ddsTxi$condition <- relevel(P1_ddsTxi$condition, ref = "WT")
P1_ddsTxi <- DESeq(P1_ddsTxi)

res_P1_ddsTxi = results(P1_ddsTxi);
res_P1_ddsTxi$padj = res_P1_ddsTxi$padj * 0.99 + res_P1_ddsTxi$pvalue * 0.01;
```

```{r}
write.table(res_ddsTxi, file = file.path(dir, "docs", "deseq", "kp1_pvalue.txt"), append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")
```


## 3. ma plot, html report

https://bioconductor.org/packages/3.7/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#rich-visualization-and-reporting-of-results

```{r}
load("~/projects/kp1/deseq/deseq_output/kp1_deseq.RData")
```

### regionReport html report
http://bioconductor.org/packages/release/bioc/html/regionReport.html
* exported results are ranked by adj-pvalue, not distinguishable near 1, do not rank by adj-pvalue, add some variation
* supply the res= augument, otherwise run results by default contrast
```{r}
library('ggplot2')
library('regionReport')
dir_deseq <- file.path(dir, "docs", "regionReport")
dir.create(dir_deseq, showWarnings = FALSE, recursive = TRUE)
report <- DESeq2Report(ddsTxi, res = res_ddsTxi, project = 'kp1 DESeq2 HTML report', nBest = min(500,nrow(ddsTxi)), nBestFeatures = 20,  
    intgroup = c('tissue', 'age', 'condition'), outdir = dir_deseq,
    output = 'kp1_deseq_index', theme = theme_bw())
```
https://xinli-git.github.io/kp1/regionReport/kp1_deseq_index.html

```{r}
pdf(file.path(dir_deseq, "ENSMUSG00000030020.13.pdf"))
plotCounts_gg("ENSMUSG00000030020.13", dds = ddsTxi, intgroup = c('tissue', 'age', 'condition'))
dev.off()
```

### ReportingTools html report
http://bioconductor.org/packages/release/bioc/html/ReportingTools.html
```{r}
library(ReportingTools)
library(EnsDb.Mmusculus.v79)
dir_report <- file.path(dir, "docs", "reportingTools")
setwd(file.path(dir_deseq))
report_rt <- HTMLReport(shortName = 'kp1_RNAseq_analysis_with_DESeq2',
	title = 'kp1 RNA-seq analysis of differential expression using DESeq2',
	reportDirectory = dir_report)
publish(ddsTxi, report_rt, pvalueCutoff=0.95, n=min(500,nrow(ddsTxi)),
	annotation.db="EnsDb.Mmusculus.v79", factor = colData(ddsTxi)$condition,
	reportDir=dir_report)
finish(report_rt)
```
https://xinli-git.github.io/kp1/reportingTools/kp1_RNAseq_analysis_with_DESeq2.html

### pcaExplorer
* need browser interface, can be skipped
* http://bioconductor.org/packages/release/bioc/vignettes/pcaExplorer/inst/doc/pcaExplorer.html
```{r}
library("pcaExplorer")
pcaExplorer(dds = ddsTxi)
```

## 4. pca among samples

* https://bioconductor.org/packages/3.7/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#principal-component-plot-of-the-samples
* https://bioconductor.org/packages/3.7/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#data-quality-assessment-by-sample-clustering-and-visualization

### CountClust
* https://bioconductor.org/packages/release/bioc/html/CountClust.html
* load data from this paper (https://www.nature.com/articles/sdata2017185)
https://www.ebi.ac.uk/arrayexpress/experiments/E-MTAB-6081/
* combine RPKM/TPM tables of two studies, need to use normalized data for pca
```{r}
load("~/projects/kp1/deseq/deseq_output/kp1_deseq_11092018.RData")
library(stringr)
kp1_mouse_fpkm <- txi.rsem$abundance
rownames(kp1_mouse_fpkm) <- str_extract(rownames(kp1_mouse_fpkm), '[^.]+')
dir_countclust <- "~/projects/kp1/countclust"
atlas_rpkm <- read.table(file.path(dir_countclust, "data_space", "mouse_rpkm.txt"), header=TRUE)
atlas_design <- read.table(file.path(dir_countclust, "data_space", "mouse_design.txt"), header=TRUE)
merged_rpkm <- merge(kp1_mouse_fpkm, atlas_rpkm, by = "row.names")
rownames(merged_rpkm) <- merged_rpkm$Row.names
merged_rpkm$Row.names <- {}
temp <- atlas_design[, c('group', 'comparison', 'comparison', 'sample')]
colnames(temp) <- c('tissue', 'condition', 'age', 'rna_lib')
merged_design <- rbind(samples[, c('tissue', 'condition', 'age', 'rna_lib')], temp[, c('tissue', 'condition', 'age', 'rna_lib')])
merged_design$compound <- paste(merged_design$tissue, merged_design$age, merged_design$condition)
```

```{r}
source("http://bioconductor.org/biocLite.R")
biocLite("CountClust")
library(CountClust)
kp1.FitGoM <- FitGoM(t(merged_rpkm),
            K=6, tol=1)
```
```{r}
omega <- kp1.FitGoM$clust_6$omega

annotation <- data.frame(
    sample_id = merged_design$rna_lib,
    tissue_label = factor(merged_design$compound,
                          levels = rev(unique(merged_design$compound) ) ) );

pdf(file.path(dir, "docs", "kp1_countclust.pdf"))
StructureGGplot(omega = omega,
                annotation = annotation,
                palette = RColorBrewer::brewer.pal(8, "Accent"),
                yaxis_label = "Mouse Tissues",
                order_sample = TRUE,
                axis_tick = list(axis_ticks_length = .1,
                                 axis_ticks_lwd_y = .1,
                                 axis_ticks_lwd_x = .1,
                                 axis_label_size = 7,
                                 axis_label_face = "bold"))
dev.off()
```
https://xinli-git.github.io/kp1/countclust/kp1_countclust.pdf


## 5. vst (variance stablizing transformation)

https://bioconductor.org/packages/3.7/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#variance-stabilizing-transformation

## 6. gene ontology





