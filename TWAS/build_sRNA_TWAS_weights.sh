#!/usr/bin/env bash
set -euo pipefail

# Build tissue-specific sRNA-TWAS prediction models using FUSION.
#
# Example:
#   bash scripts/TWAS/build_sRNA_TWAS_weights.sh \
#       --tissue Whole_Blood \
#       --expression Input_Demo/Whole_Blood.sRNA.bed.gz \
#       --sample-id Input_Demo/Whole_Blood.sample_ids.txt \
#       --covariates Input_Demo/Whole_Blood.covariates.txt \
#       --genotype Input_Demo/Whole_Blood.genotype \
#       --ldref /path/to/LDREF \
#       --output output/TWAS_weights \
#       --fusion /path/to/fusion_twas \
#       --gcta /path/to/gcta \
#       --gemma /path/to/gemma \
#       --plink /path/to/plink \
#       --num-phenotypes 1000 \
#       --task-id 1 \
#       --block-size 500

usage() {
    echo "Usage: bash $0 \
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
[--task-id <task_id>] \
[--block-size <block_size>]"
    exit 1
}

TASK_ID=1
BLOCK_SIZE=500

while [[ $# -gt 0 ]]; do
    case "$1" in
        --tissue)
            TISSUE="$2"
            shift 2
            ;;
        --expression)
            EXPRESSION_BED_GZ="$2"
            shift 2
            ;;
        --sample-id)
            SAMPLE_ID_FILE="$2"
            shift 2
            ;;
        --covariates)
            COVARIATE_FILE="$2"
            shift 2
            ;;
        --genotype)
            GENOTYPE_PREFIX="$2"
            shift 2
            ;;
        --ldref)
            LDREF_DIR="$2"
            shift 2
            ;;
        --output)
            OUTPUT_DIR_ROOT="$2"
            shift 2
            ;;
        --fusion)
            FUSION_DIR="$2"
            shift 2
            ;;
        --gcta)
            GCTA="$2"
            shift 2
            ;;
        --gemma)
            GEMMA="$2"
            shift 2
            ;;
        --plink)
            PLINK="$2"
            shift 2
            ;;
        --num-phenotypes)
            NUM_PHENOTYPES="$2"
            shift 2
            ;;
        --task-id)
            TASK_ID="$2"
            shift 2
            ;;
        --block-size)
            BLOCK_SIZE="$2"
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
    TISSUE
    EXPRESSION_BED_GZ
    SAMPLE_ID_FILE
    COVARIATE_FILE
    GENOTYPE_PREFIX
    LDREF_DIR
    OUTPUT_DIR_ROOT
    FUSION_DIR
    GCTA
    GEMMA
    PLINK
    NUM_PHENOTYPES
)

for var in "${required_vars[@]}"; do
    if [[ -z "${!var:-}" ]]; then
        echo "Error: missing required argument for ${var}"
        usage
    fi
done

OUT_DIR="${OUTPUT_DIR_ROOT}/${TISSUE}"
mkdir -p "${OUT_DIR}"

BATCH_START=$(( (TASK_ID - 1) * BLOCK_SIZE + 1 ))
BATCH_END=$(( TASK_ID * BLOCK_SIZE ))

if [[ "${BATCH_END}" -gt "${NUM_PHENOTYPES}" ]]; then
    BATCH_END="${NUM_PHENOTYPES}"
fi

BATCH_ID="${BATCH_START}_${BATCH_END}"

BATCH_DIR="${OUT_DIR}/${BATCH_ID}"
mkdir -p "${BATCH_DIR}/tmp/${BATCH_ID}"
mkdir -p "${BATCH_DIR}/hsq"
mkdir -p "${OUT_DIR}/ALL"

cd "${BATCH_DIR}"

echo "Tissue: ${TISSUE}"
echo "Task ID: ${TASK_ID}"
echo "Phenotype range: ${BATCH_START}-${BATCH_END}"
echo "Start time:"
date

zcat "${EXPRESSION_BED_GZ}" | \
awk -v s="${BATCH_START}" -v e="${BATCH_END}" 'NR==1{next} NR>=s && NR<=e' | \
while read -r PARAM; do

    CHR=$(echo "${PARAM}" | awk '{gsub(/^chr/,"",$1); print $1}')
    P0=$(echo "${PARAM}" | awk '{p=$2-500000; if(p<0) p=0; print int(p)}')
    P1=$(echo "${PARAM}" | awk '{print int($3+500000)}')
    PHENO_ID=$(echo "${PARAM}" | awk '{print $4}')

    OUT_PREFIX="tmp/${BATCH_ID}/${TISSUE}.${PHENO_ID}"
    FINAL_OUT="${OUT_DIR}/ALL/${TISSUE}.${PHENO_ID}"

    echo "Processing ${PHENO_ID}: chr${CHR}:${P0}-${P1}"

    echo "${PARAM}" | tr ' ' '\n' | tail -n +5 | \
        paste "${SAMPLE_ID_FILE}" - > "${OUT_PREFIX}.pheno"

    "${PLINK}" \
        --bfile "${GENOTYPE_PREFIX}" \
        --allow-no-sex \
        --allow-no-vars \
        --pheno "${OUT_PREFIX}.pheno" \
        --keep "${OUT_PREFIX}.pheno" \
        --chr "${CHR}" \
        --from-bp "${P0}" \
        --to-bp "${P1}" \
        --extract "${LDREF_DIR}/1000G.chr${CHR}.EUR.snp.biallelic.setID.bim" \
        --make-bed \
        --out "${OUT_PREFIX}"

    Rscript "${FUSION_DIR}/FUSION.compute_weights.R" \
        --bfile "${OUT_PREFIX}" \
        --tmp "${OUT_PREFIX}.tmp" \
        --out "${FINAL_OUT}" \
        --verbose 0 \
        --save_hsq \
        --PATH_gcta "${GCTA}" \
        --PATH_gemma "${GEMMA}" \
        --models blup,lasso,top1,enet \
        --covar "${COVARIATE_FILE}" \
        --hsq_p 0.01

    if [[ -f "${FINAL_OUT}.hsq" ]]; then
        cat "${FINAL_OUT}.hsq" >> "hsq/${BATCH_ID}.hsq"
        rm -f "${FINAL_OUT}.hsq"
    fi

    rm -f "${OUT_PREFIX}".tmp.*
    rm -f "${OUT_PREFIX}".bed "${OUT_PREFIX}".bim "${OUT_PREFIX}".fam
    rm -f "${OUT_PREFIX}".log "${OUT_PREFIX}".nosex

done

echo "End time:"
date
