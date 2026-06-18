# GWAS summary statistics

GWAS summary statistics were used as input for TWAS association testing.

The input GWAS file should be in LDSC-compatible format with at least the following columns:

| Column | Description |
|---|---|
| `SNP` | SNP identifier, usually rsID. |
| `A1` | Effect allele. |
| `A2` | Other allele. |
| `Z` | Z-score, signed with respect to `A1`. |

GWAS summary statistics can be processed using LDSC [`munge_sumstats.py`](https://github.com/bulik/ldsc). For details on the expected TWAS input format, please refer to the [FUSION typical analysis and output](http://gusevlab.org/projects/fusion/#typical-analysis-and-output).

GWAS summary statistics are not included in this repository and can be obtained from public resources such as [FinnGen](https://r12.finngen.fi/), the [UK Biobank summary statistics from the Neale Lab](https://www.nealelab.is/uk-biobank), and the [NHGRI-EBI GWAS Catalog](https://www.ebi.ac.uk/gwas/).
