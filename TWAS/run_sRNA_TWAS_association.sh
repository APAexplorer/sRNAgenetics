#!/usr/bin/env bash
set -euo pipefail

# Run sRNA-TWAS association testing using trained tissue-specific FUSION weights.
#
# This script runs TWAS association testing across GWAS summary statistics,
# tissues and chromosomes.
#
# The GWAS list should contain two columns:
#   1) GWAS summary statistics file name
#   2) GWAS sample size
#
# Example GWAS list:
#   T2D_example.sumstats.gz 1812017
#   CAD_example.sumstats.gz 122733
#
# Example tissue list:
#   Adipose_Subcutaneous.v10
#   Pituitary.v10
#   Muscle_Skeletal.v10
#   Pancreas.v10
#
# Example usage:
#   bash scripts/TWAS/run_sRNA_TWAS_association.sh \
#       --sumstats-list Input_Demo/gwas_sumstats.list \
#       --tissue-list Input_Demo/tissue.list \
#       --chr 1 \
#       --weight-root output/TWAS_weights \
#       --sumstats-root Input_Demo/GWAS \
#       --ldref-prefix /path/to/LDREF/1000G.EUR. \
#       --fusion /path/to/fusion_twas \
#       --output output/TWAS_results \
#       --p-cutoff 0.0005

usage() {
    echo "Usage: bash $0 \
--sumstats-list <gwas_sumstats_list> \
--tissue-list <tissue_list> \
--chr <chromosome> \
--weight-root <weight_root> \
--sumstats-root <sumstats_root> \
--ldref-prefix <ldref_prefix> \
--fusion <fusion_dir> \
--output <output_root> \
[--p-cutoff <p_cutoff>]"
    exit 1
}

P_CUTOFF=0.0005

while [[ $# -gt 0 ]]; do
    case "$1" in
        --sumstats-list)
            SUMSTATS_LIST="$2"
            shift 2
            ;;
        --tissue-list)
            TISSUE_LIST="$2"
            shift 2
            ;;
        --chr)
            CHR="$2"
            shift 2
            ;;
        --weight-root)
            WEIGHT_ROOT="$2"
            shift 2
            ;;
        --sumstats-root)
            SUMSTATS_ROOT="$2"
            shift 2
            ;;
        --ldref-prefix)
            LDREF_PREFIX="$2"
            shift 2
            ;;
        --fusion)
            FUSION_DIR="$2"
            shift 2
            ;;
        --output)
            OUTPUT_ROOT="$2"
            shift 2
            ;;
        --p-cutoff)
            P_CUTOFF="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown argument: $1"
            usage
            ;;
    esac
done

required_vars=(
    SUMSTATS_LIST
    TISSUE_LIST
    CHR
    WEIGHT_ROOT
    SUMSTATS_ROOT
    LDREF_PREFIX
    FUSION_DIR
    OUTPUT_ROOT
)

for var in "${required_vars[@]}"; do
    if [[ -z "${!var:-}" ]]; then
        echo "Error: missing required argument for ${var}"
        usage
    fi
done

# Use the customized FUSION association script that supports --coloc_P and --GWASN.
FUSION_ASSOC_TEST="${FUSION_DIR}/FUSION.assoc_test.R"

mkdir -p "${OUTPUT_ROOT}"

while read -r gwas_file gwas_sample_size; do

    [[ -z "${gwas_file}" ]] && continue
    [[ "${gwas_file}" =~ ^# ]] && continue

    if [[ -z "${gwas_sample_size:-}" ]]; then
        echo "Error: sample size is missing for GWAS file: ${gwas_file}"
        echo "Each line in ${SUMSTATS_LIST} should contain: <gwas_sumstats_file> <sample_size>"
        exit 1
    fi

    sumstats="${SUMSTATS_ROOT}/${gwas_file}"
    gwas_name="${gwas_file%.sumstats.gz}"

    echo "Processing GWAS: ${gwas_name}"
    echo "Sample size: ${gwas_sample_size}"

    while read -r tissue; do

        [[ -z "${tissue}" ]] && continue
        [[ "${tissue}" =~ ^# ]] && continue

        tissue="${tissue%/}"

        weights_pos="${WEIGHT_ROOT}/${tissue}/${tissue}.pos"
        weights_dir="${WEIGHT_ROOT}/${tissue}/"

        output_dir="${OUTPUT_ROOT}/${gwas_name}/${tissue}"
        mkdir -p "${output_dir}"

        output_file="${output_dir}/${gwas_name}.${tissue}.chr${CHR}.dat"

        echo "Running TWAS: GWAS=${gwas_name}, tissue=${tissue}, chr=${CHR}"

        Rscript "${FUSION_ASSOC_TEST}" \
            --sumstats "${sumstats}" \
            --weights "${weights_pos}" \
            --weights_dir "${weights_dir}" \
            --ref_ld_chr "${LDREF_PREFIX}" \
            --chr "${CHR}" \
            --coloc_P "${P_CUTOFF}" \
            --GWASN "${gwas_sample_size}" \
            --out "${output_file}"

    done < "${TISSUE_LIST}"

done < "${SUMSTATS_LIST}"
