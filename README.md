# sRNAgenetics
sRNA-QTL mapping and tissue-specific sRNA-TWAS models based on GTEx v10 small RNA-seq data.

About
====================
This repository contains the analysis workflow and source code for the study **"Genetic regulation of small RNAs across human tissues and its contribution to human diseases"**. The study used GTEx v10 data, including 16,054 small RNA-seq samples from 49 human tissues of 942 donors, for sRNA-QTL mapping and tissue-specific sRNA-TWAS model construction.

## Software requirements and installation
The analyses were performed using the following publicly available software. Installation instructions are available through the corresponding software links:

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

## Demo data
Individual-level GTEx v10 genotype and small RNA-seq data used in this study are controlled-access and are not included in this repository.

Demo datasets and tutorials for the main analysis steps are available from the original software resources:
- [FUSION](http://gusevlab.org/projects/fusion/) provides TWAS example data and tutorials.
- [tensorQTL](https://github.com/broadinstitute/tensorqtl) provides QTL mapping example data and tutorials, including the [GTEx v8 example notebook](https://github.com/broadinstitute/tensorqtl/blob/master/example/GTEx_v8_example.ipynb).

These demo datasets can be used to test software installation, expected input formats and example workflows. 

## Analysis workflow

The analysis scripts are organized into four main modules:

### QTL analysis

Scripts in `scripts/QTL/` were used to identify cis-sRNA-QTLs using tensorQTL.

### TWAS analysis

Scripts in `scripts/TWAS/` were used to build tissue-specific sRNA-TWAS prediction models and perform TWAS association analyses.

### GWAS integration

Scripts in `scripts/GWAS_integration/` were used to process GWAS summary statistics for downstream TWAS, colocalization and fine-mapping analyses.

### Plotting

Scripts in `scripts/Plotting/` were used to generate main and supplementary figures.
