# Input demo data

The GTEx v10 genotype and small RNA-seq data used in this study are controlled-access data and are not included in this repository.

This folder is intended to describe the expected input files for the cis-sRNA-QTL analysis. Users with authorized access to GTEx v10 data can prepare the required genotype, expression and covariate files following the tensorQTL input format.

For testing the workflow, users can refer to the tensorQTL example tutorial and download the GTEx v8 demo data provided by tensorQTL:

- [tensorQTL GTEx v8 example notebook](https://github.com/broadinstitute/tensorqtl/blob/master/example/GTEx_v8_example.ipynb)

The GTEx v8 demo data can be used to test software installation, input formatting and example QTL mapping commands. These demo files are not the GTEx v10 small RNA-seq data used in this study.

## Expected input files

The QTL mapping script expects the following input files:

- PLINK genotype files with a shared prefix, including `.pgen`, `.pvar` and `.psam` files.
- BED-format small RNA expression matrix.
- Tab-delimited covariate file.

These files should be prepared according to the tensorQTL documentation and examples.
