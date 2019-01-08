
# kp1/goseq analysis

## reference manual

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

check mm10 is available

```{r}
library(goseq)
supportedOrganisms()
```

```{r}
supportedOrganisms()[supportedOrganisms()$Genome=="mm10",]
```

test mm10 database

```{r}
BiocManager::install("org.Mm.eg.db", version = "3.8")
getgo('ENSMUSG00000048636.7', 'mm10', 'ensGene')
getlength('ENSMUSG00000048636.7', 'mm10', 'ensGene')
```






