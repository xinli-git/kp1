
# kp1/goseq analysis

## reference manual

https://bioconductor.org/packages/release/bioc/html/goseq.html
https://bioconductor.org/packages/devel/bioc/vignettes/goseq/inst/doc/goseq.pdf

## tutorial

https://bioconductor.org/packages/devel/bioc/vignettes/goseq/inst/doc/goseq.pdf

## install

```{bash}
which R
module avail
```

```{bash}
module load r/3.5.1
R
```

```{r}
BiocManager::install("goseq", version = "3.8")
```

* check mm10 is available

```{r}
library(goseq)
supportedOrganisms()
```

```{r}
supportedOrganisms()[supportedOrganisms()$Genome=="mm10",]
```

* install and test mm10 database
* must remove .suffix for ensembl id
* use ensGene as ID, geneSymbol is ambiguous in certain cases

```{r}
BiocManager::install("org.Mm.eg.db", version = "3.8")
getgo('ENSMUSG00000048636', 'mm10', 'ensGene')

BiocManager::install("TxDb.Mmusculus.UCSC.mm10.ensGene", version = "3.8")
getlength('ENSMUSG00000048636', 'mm10', 'ensGene')

BiocManager::install("TxDb.Mmusculus.UCSC.mm10.knownGene", version = "3.8")
getlength('Pcyox1', 'mm10', 'geneSymbol')
```

## GO analysis

```{r}
dir <- "~/projects/kp1/"
load(file="~/projects/kp1/deseq/deseq_output/kp1_deseq_11092018.RData");
```{r}

```{r}
tested = res_ddsTxi[!is.na(res_ddsTxi$lfcSE) & !is.na(res_ddsTxi$padj),]
genes = as.integer(tested$padj < 0.05)
rownames = row.names(tested)
rownames = strsplit(rownames, ".", fixed = TRUE)
rownames = sapply(rownames, "[", 1 )
names(genes) = rownames;
```

```{r}
pwf=nullp(genes,"mm10","ensGene")
head(pwf)
plotPWF(pwf, binsize="auto")
```

```{r}
GO.wall=goseq(pwf,"mm10","ensGene")
head(GO.wall)
```

```{r}
GO.samp=goseq(pwf,"mm10","ensGene",method="Sampling",repcnt=1000)
head(GO.samp)
```

```{r}
plot(log10(GO.wall[,2]), log10(GO.samp[match(GO.wall[,1],GO.samp[,1]),2]), xlab="log10(Wallenius p-values)",ylab="log10(Sampling p-values)", xlim=c(-3,0))
abline(0,1,col=3,lty=2)
```

## print results

```{r}
enriched.GO=GO.wall$category[p.adjust(GO.wall$over_represented_pvalue,method="BH")<.05]
head(enriched.GO)
```

```{r}
library(GO.db)
for(go in enriched.GO){
        print(GOTERM[[go]])
        cat("--------------------------------------\n")}
```

```{r}
save.image(file="~/projects/kp1/deseq/deseq_output/kp1_goseq_01082019.RData")
```

```{r}
write.table(GO.wall, file = file.path(dir, "docs", "goseq", "kp1_goseq_wall.txt"), append = FALSE, quote = FALSE, sep = "\t", eol = "\n", na = "NA", dec = ".", row.names = TRUE, col.names = TRUE, qmethod = c("escape", "double"), fileEncoding = "")
write.table(GO.samp, file = file.path(dir, "docs", "goseq", "kp1_goseq_samp.txt"), append = FALSE, quote = FALSE, sep = "\t", eol = "\n", na = "NA", dec = ".", row.names = TRUE, col.names = TRUE, qmethod = c("escape", "double"), fileEncoding = "")
```






































