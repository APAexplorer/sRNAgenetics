#!/usr/bin/env python3

import argparse
import pandas as pd
import torch
import tensorqtl
from tensorqtl import pgen, cis, post


def main():
    parser = argparse.ArgumentParser(
        description="Run cis permutation mapping and FDR calculation for sRNA-QTL analysis using tensorQTL."
    )
    parser.add_argument("plink_prefix_path", help="Prefix of PLINK genotype files.")
    parser.add_argument("expression_bed", help="BED-format small RNA expression matrix.")
    parser.add_argument("covariates_file", help="Tab-delimited covariate file.")
    parser.add_argument("output_file", help="Output file for cis permutation results with q-values.")
    parser.add_argument("--seed", type=int, default=3042235018, help="Random seed for permutation mapping.")
    parser.add_argument("--nperm", type=int, default=10000, help="Number of permutations.")
    parser.add_argument("--fdr", type=float, default=0.05, help="FDR threshold.")
    parser.add_argument("--qvalue-lambda", type=float, default=0.85, help="Lambda parameter for q-value calculation.")

    args = parser.parse_args()

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"torch: {torch.__version__} (CUDA {torch.version.cuda}), device: {device}")
    print(f"pandas: {pd.__version__}")

    phenotype_df, phenotype_pos_df = tensorqtl.read_phenotype_bed(args.expression_bed)
    covariates_df = pd.read_csv(args.covariates_file, sep="\t", index_col=0).T

    pgr = pgen.PgenReader(args.plink_prefix_path)
    genotype_df = pgr.load_genotypes()
    variant_df = pgr.variant_df

    cis_df = cis.map_cis(
        genotype_df,
        variant_df,
        phenotype_df,
        phenotype_pos_df,
        covariates_df=covariates_df,
        seed=args.seed,
        nperm=args.nperm,
    )

    post.calculate_qvalues(
        cis_df,
        fdr=args.fdr,
        qvalue_lambda=args.qvalue_lambda,
    )

    cis_df = cis_df.sort_values("qval")
    cis_df.to_csv(args.output_file, sep="\t", index=True)


if __name__ == "__main__":
    main()
