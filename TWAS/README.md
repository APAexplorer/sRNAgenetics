### TWAS analysis

The TWAS analysis was performed in two steps.

**Step 1: Model construction**

The script `./TWAS/build_sRNA_TWAS_weights.sh` was used to build tissue-specific sRNA-TWAS prediction models using FUSION.

Example usage:

```bash
bash build_sRNA_TWAS_weights.sh \
    --tissue <tissue_name> \
    --expression <expression_bed_gz> \
    --sample-id <sample_id_file> \
    --covariates <covariates_file> \
    --genotype <genotype_prefix> \
    --ldref <ldref_dir> \
    --output <output_dir> \
    --fusion <fusion_dir> \
    --gcta <gcta_path> \
    --gemma <gemma_path> \
    --plink <plink_path> \
    --num-phenotypes <num_phenotypes> \
    --task-id <task_id> \
    --block-size <block_size>
```

Input files and parameters:

- `<tissue_name>`: tissue name used as the output prefix.
- `<expression_bed_gz>`: gzipped BED-format small RNA expression matrix.
- `<sample_id_file>`: two-column sample ID file in PLINK phenotype format.
- `<covariates_file>`: covariate file used for FUSION weight construction.
- `<genotype_prefix>`: prefix of PLINK binary genotype files.
- `<ldref_dir>`: directory containing LD reference SNP files.
- `<output_dir>`: output directory for trained sRNA-TWAS weights.
- `<fusion_dir>`: path to the FUSION software directory.
- `<gcta_path>`: path to GCTA.
- `<gemma_path>`: path to GEMMA.
- `<plink_path>`: path to PLINK.
- `<num_phenotypes>`: number of small RNA phenotypes to process.
- `<task_id>`: batch index for processing small RNA phenotypes.
- `<block_size>`: number of small RNA phenotypes processed per batch.

The script retains small RNAs with significant cis-heritability using `--hsq_p 0.01`, consistent with the TWAS model selection criterion used in the study.

**Step 2: TWAS association testing**

The trained tissue-specific sRNA-TWAS models were then used to perform TWAS association testing with GWAS summary statistics.

