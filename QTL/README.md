### QTL analysis

The script `scripts/QTL/run_sRNA_QTL_mapping.sh` was used to identify cis-sRNA-QTLs using tensorQTL.

Example usage:

```bash
bash scripts/QTL/run_sRNA_QTL_mapping.sh \
    <plink_prefix_path> \
    <expression_bed> \
    <covariates_file> \
    <prefix> \
    <output_file>
``` 

Input files and parameters:

- `<plink_prefix_path>`: prefix of PLINK genotype files.
- `<expression_bed>`: BED-format small RNA expression matrix.
- `<covariates_file>`: tab-delimited covariate file.
- `<prefix>`: output prefix for cis-nominal tensorQTL results.
- `<output_file>`: output file for cis permutation results with q-values.
