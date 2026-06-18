
#!/usr/bin/env bash
set -euo pipefail

# Run cis-sRNA-QTL mapping using tensorQTL.
#
# Usage:
#   bash run_sRNA_QTL_mapping.sh <plink_prefix_path> <expression_bed> <covariates_file> <prefix> <output_file>
#
# Arguments:
#   plink_prefix_path : Prefix of PLINK genotype files
#   expression_bed    : BED-format small RNA expression matrix
#   covariates_file   : Tab-delimited covariate file
#   prefix            : Output prefix for tensorQTL cis-nominal results
#   output_file       : Output file for cis permutation results with q-values

if [ "$#" -ne 5 ]; then
    echo "Usage: bash $0 <plink_prefix_path> <expression_bed> <covariates_file> <prefix> <output_file>"
    exit 1
fi

plink_prefix_path=$1
expression_bed=$2
covariates_file=$3
prefix=$4
output_file=$5

# Activate tensorQTL environment
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate tensorqtl

# Step 1: cis-nominal mapping
python3 -m tensorqtl "${plink_prefix_path}" "${expression_bed}" "${prefix}" \
    --covariates "${covariates_file}" \
    --mode cis_nominal


# Step 2: cis permutation mapping and FDR calculation
python3 scripts/QTL/calculate_cis_qtl_fdr.py \
    "${plink_prefix_path}" \
    "${expression_bed}" \
    "${covariates_file}" \
    "${output_file}"
