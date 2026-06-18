# sRNAgenetics
sRNA-QTL mapping and tissue-specific sRNA-TWAS models based on GTEx v10 small RNA-seq data.

About
====================
This repository contains the analysis workflow and source code for the study **"Genetic regulation of small RNAs across human tissues and its contribution to human diseases"**. The study used GTEx v10 data, including 16,054 small RNA-seq samples from 49 human tissues of 942 donors, for sRNA-QTL mapping and tissue-specific sRNA-TWAS model construction.

## Software requirements
The analyses were performed using the following publicly available software:

- [PLINK 2.0](https://www.cog-genomics.org/plink/2.0/) (v2.00a2.3)
- [FUSION](http://gusevlab.org/projects/fusion/) (no formal release version; accessed January 15, 2026)
- [LDSC](https://github.com/bulik/ldsc) (v1.0.1)
- [tensorQTL](https://github.com/broadinstitute/tensorqtl) (v1.0.10)
- [SuSiE](https://github.com/stephenslab/susieR) (v0.14.2)

R (v4.3.1) was used for downstream data processing, genomic annotation, statistical analysis and visualization, with the following packages:
- [data.table](https://cran.r-project.org/package=data.table) (v1.17.8)
- [dplyr](https://cran.r-project.org/package=dplyr) (v1.1.4)
- [stringr](https://cran.r-project.org/package=stringr) (v1.5.1)
- [tidyverse](https://cran.r-project.org/package=tidyverse) (v2.0.0)
- [liftOver](https://bioconductor.org/packages/liftOver/) (v1.26.0)
- [GenomicRanges](https://bioconductor.org/packages/GenomicRanges/) (v1.54.1)
- [rtracklayer](https://bioconductor.org/packages/rtracklayer/) (v1.62.0)
- [ggplot2](https://cran.r-project.org/package=ggplot2) (v3.5.1)
- [locuscomparer](https://github.com/boxiangliu/locuscomparer) (v1.0.0)
- [qqman](https://cran.r-project.org/package=qqman) (v0.1.9)
