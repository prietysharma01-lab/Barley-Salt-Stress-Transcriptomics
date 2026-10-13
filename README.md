# Comparative Transcriptomic Analysis of Salt-Stress Responses in Barley

**An independent bioinformatics project using public RNA-seq data to explore salt-stress responses in wild and cultivated barley.**

**Focus areas:** RNA-seq quality control · Transcript quantification · Differential expression · Gene Ontology enrichment · Reproducible bioinformatics

## 1. Project Overview

Salt stress affects plant growth and productivity. Understanding differences in gene-expression responses between wild and cultivated barley may help identify candidate genes and biological processes associated with salt-stress responses.

This project reanalyses public paired-end RNA-seq data to explore transcriptional differences between wild/tolerant and cultivated/sensitive barley under control and salt-treated conditions.

The workflow covers sequencing-data retrieval, read-quality assessment, preprocessing, transcript quantification, sample-level analysis, differential-expression testing, and Gene Ontology (GO) enrichment.

The analysis is exploratory. Each experimental group contains two biological replicates, and a library-type inference discrepancy remains unresolved. Results are therefore treated as candidate signals for further investigation rather than definitive evidence of salt-tolerance mechanisms.

## 2. Research Question and Objectives

### Research question

How do transcriptional profiles differ between wild/tolerant and cultivated/sensitive barley under control and salt-treated conditions, and which differentially expressed genes and GO categories may be associated with these differences?

### Objectives

- Establish an end-to-end RNA-seq analysis workflow using public sequencing data.
- Compare salt-treated and control samples within each genotype.
- Compare wild and cultivated barley under control and salt-treated conditions.
- Identify exploratory differentially expressed gene sets.
- Explore functional categories enriched among upregulated and downregulated gene sets.
- Document the workflow, outputs, and limitations to support reproducibility.

## 3. Dataset and Experimental Design

**Data source:** NCBI Sequence Read Archive (SRA)

**SRA run accessions:** `SRR16989364`–`SRR16989371`

The eight paired-end RNA-seq runs represent four experimental groups, with two biological replicates per group.

| Group | Genotype description | Treatment | SRA accessions | Replicates |
|---|---|---|---|---:|
| TC | Wild/tolerant barley | Control | SRR16989368, SRR16989369 | 2 |
| TS | Wild/tolerant barley | Salt-treated | SRR16989370, SRR16989371 | 2 |
| SC | Cultivated/sensitive barley | Control | SRR16989364, SRR16989365 | 2 |
| SS | Cultivated/sensitive barley | Salt-treated | SRR16989366, SRR16989367 | 2 |

The study describes the wild/tolerant genotype as *Hordeum spontaneum* and the cultivated/sensitive genotype as *Hordeum vulgare*. These descriptions are retained for the analysis, with the metadata caveat discussed below.

### Original study

Gharaghanipor, N., Arzani, A., Rahimmalek, M., & Ravash, R. (2022). Physiological and Transcriptome Indicators of Salt Tolerance in Wild and Cultivated Barley. *Frontiers in Plant Science, 13*, 819282.

https://doi.org/10.3389/fpls.2022.819282

The original study is the source of the biological context and public sequencing data used in this independent reanalysis.

## 4. Bioinformatics Workflow

### Step 1 — Data retrieval

Public SRA runs were retrieved and converted into paired-end FASTQ files using the SRA Toolkit.

### Step 2 — Raw-read quality control

FastQC was used to assess raw-read quality, and MultiQC was used to aggregate quality-control reports across samples.

### Step 3 — Read preprocessing

fastp was used for adapter trimming and read filtering. FastQC and MultiQC reports were generated again to assess processed reads.

### Step 4 — Transcript quantification

Salmon was used to estimate transcript abundance from processed paired-end reads against the *Hordeum vulgare* IBSC_v2 transcript reference.

### Step 5 — Expression-matrix generation

Transcript-level estimates were imported into R using tximport. Gene-level count, TPM, and length matrices were generated for downstream analysis.

### Step 6 — Sample-level analysis

Variance-stabilised expression data were used to examine sample relationships through principal component analysis (PCA) and sample-distance heatmaps.

The first two principal components explained 58% and 22% of the variance, respectively, in the current analysis. These patterns are descriptive and do not independently establish biological differences.

### Step 7 — Differential-expression analysis

DESeq2 was used to evaluate genotype, treatment, and genotype-by-treatment effects. Genes with counts of at least 10 in at least two samples were retained, resulting in 22,242 genes for testing.

The primary significance threshold was an adjusted p-value (FDR) below 0.05. Additional gene lists were generated using a more stringent absolute log2 fold-change threshold of 1.5.

### Step 8 — Functional enrichment

Upregulated and downregulated gene lists were prepared separately for Gene Ontology enrichment using AgriGO.

The analysis used *Hordeum vulgare* Genome Version 2.0, user-defined gene IDs, a custom background, Fisher's exact test, Yekutieli correction, a significance threshold of 0.05, a minimum of five mapping entries, and Complete GO.

### Step 9 — Visualisation and documentation

Figures, result tables, quality-control reports, and analysis scripts were organised to document the workflow and its outputs.

## 5. Differential-Expression Comparisons

The analysis includes five comparisons.

| Contrast | Biological question |
|---|---|
| `TS_vs_TC` | How does salt treatment affect gene expression in wild/tolerant barley? |
| `SS_vs_SC` | How does salt treatment affect gene expression in cultivated/sensitive barley? |
| `TC_vs_SC` | How do the genotypes differ under control conditions? |
| `TS_vs_SS` | How do the genotypes differ under salt treatment? |
| `Genotype × Treatment` | Does the response to salt treatment differ between genotypes? |

The genotype-by-treatment interaction evaluates whether the treatment-associated expression response differs between genotypes.

Differential-expression results are exploratory and should be interpreted in light of the small replicate count and the technical and metadata limitations described below.

## 6. Selected Results

The current analysis produced gene-expression matrices, sample-level visualisations, differential-expression tables, and GO enrichment outputs.

| Contrast | Genes with FDR below 0.05 | Upregulated | Downregulated |
|---|---:|---:|---:|
| TS_vs_TC | 10,154 | 5,126 | 5,028 |
| SS_vs_SC | 3,764 | 1,165 | 2,599 |
| TC_vs_SC | 5,294 | 2,367 | 2,927 |
| TS_vs_SS | 10,916 | 5,746 | 5,170 |
| Genotype × Treatment | 6,207 | 3,398 | 2,809 |

These counts reflect the current analysis outputs. The relatively large gene sets should not be interpreted as proof of robust biological effects, particularly given the unresolved library-type discrepancy.

The repository contains selected PCA and clustering plots, volcano plots, GO enrichment graphs, expression matrices, differential-expression summaries, sample-level QC outputs, and analysis logs.

## 7. Software and Tools

| Tool | Purpose | Version |
|---|---|---|
| SRA Toolkit | SRA retrieval and FASTQ conversion | 3.4.1 |
| FastQC | Read-quality assessment | 0.13.0 |
| MultiQC | Aggregated quality-control reports | 1.35 |
| fastp | Read preprocessing and adapter trimming | 1.4.0 |
| Salmon | Transcript quantification | 2.8.0 |
| R | Statistical analysis and visualisation | 4.6.1 |
| tximport | Import of Salmon quantification estimates | 1.40.0 |
| DESeq2 | Differential-expression analysis | 1.52.0 |
| AgriGO | Gene Ontology enrichment | Web-based; version not recorded |

Software versions reflect the documented environment used for this workflow. AgriGO was accessed as a web-based service, and its version was not recorded.

## 8. Repository Structure

The repository is organised into the following directories and files:

```text
Barley-Salt-Stress-Transcriptomics/
├── README.md
├── .gitignore
├── Figures/
│   ├── DEG_FIGURES/
│   │   ├── DEG_Genotype_Treatment_Interaction_volcano.png
│   │   ├── DEG_SS_vs_SC_volcano.png
│   │   ├── DEG_TC_vs_SC_volcano.png
│   │   ├── DEG_TS_vs_SS_volcano.png
│   │   └── DEG_TS_vs_TC_volcano.png
│   ├── GO_ENRICHMENT_FIGURES/
│   │   └── GO enrichment graphs (PDF)
│   └── SAMPLE_QC/
│       ├── PCA_samples.png
│       └── Sample_clustering_heatmap.png
├── Results/
│   ├── DEG_RESULTS/
│   │   ├── DEG tables and top-20 summaries
│   │   ├── DEG_summary.csv
│   │   ├── normalized_gene_counts.csv
│   │   ├── sample_level_QC.csv
│   │   ├── sample_metadata_checked.csv
│   │   ├── DESeq2_run.log
│   │   └── R_sessionInfo.txt
│   ├── GO_RESULTS/
│   │   └── GO enrichment result files (TXT)
│   ├── MULTIQC_RESULTS/
│   │   ├── multiqc_raw_report.html
│   │   └── multiqc_clean_report.html
│   ├── SALMON_RESULTS/
│   │   ├── gene_counts.csv
│   │   ├── gene_TPM.csv
│   │   ├── gene_lengths.csv
│   │   └── Day3_Salmon_QC.csv
│   └── analysis_metadata.csv
└── Scripts/
    ├── Scripts_README.md
    ├── 01_SRA_to_FASTQ.sh
    ├── 02_Compress_FASTQ.sh
    ├── 03_Verify_FASTQ.sh
    ├── 04_Create_Project_Folders.sh
    ├── 05_FastQC_All_Raw.sh
    ├── 06_MultiQC_Raw.sh
    ├── 07_import_salmon.R
    ├── 08_sample_QC.R
    ├── 09_differential_expression.R
    ├── 10_summarize_DEGs.R
    ├── 11_volcano_plots.R
    ├── 12_prepare_GO_gene_lists.R
    └── 13_prepare_GO_LFC15_lists.R
```

The figure and result directories contain the actual output files, including individual GO PDFs and contrast-specific result tables.

Raw FASTQ files, SRA files, the Salmon index, and large reference files are not included. Their sources and accessions should be documented when reproducing the analysis.

## 9. How to Use This Repository

The repository provides analysis scripts, selected outputs, figures, and workflow documentation.

### To inspect the completed analysis

1. Review the figures in `Figures/`.
2. Review differential-expression tables and summaries in `Results/DEG_RESULTS/`.
3. Review GO enrichment outputs in `Results/GO_RESULTS/` and `Figures/GO_ENRICHMENT_FIGURES/`.
4. Inspect raw and processed-read QC reports in `Results/MULTIQC_RESULTS/`.
5. Review `DESeq2_run.log` and `R_sessionInfo.txt` for analysis and software-session documentation.

### To reproduce the analysis

1. Clone or download the repository.
2. Install the required command-line tools and R packages.
3. Retrieve the public sequencing data using the listed SRA accessions.
4. Obtain the appropriate barley transcript reference and annotation files, documenting their source and version.
5. Configure the input and output paths in the scripts for the local environment.
6. Run the workflow in sequence: data retrieval, quality control, preprocessing, quantification, expression import, differential-expression analysis, and functional enrichment.
7. Review the generated tables, figures, and quality-control reports.

**Path configuration:** The current scripts reference the original local analysis directory, `~/Desktop/OIST FOLDER/01_RNAseq_Project`, and some shell scripts use local executable paths. They are not fully portable as committed. Update these paths before attempting to reproduce the workflow on another machine.

The repository should therefore be treated as a documented analysis project with selected outputs, rather than a plug-and-play pipeline. Reproduction requires the original sequencing data, reference files, software dependencies, and correctly configured input paths.

## 10. Limitations and Reproducibility

### Library-type inference discrepancy

Salmon was run using automatic library-type inference (`libType = A`). The inferred library type was `IU` for `SRR16989364` and `SRR16989365`, while the other six samples were inferred as `ISR`.

Both IU-inferred samples belong to the cultivated-control group (SC). The original study describes a stranded mRNA library-preparation protocol, making this discrepancy important to document.

The discrepancy remains unresolved, and the current quantification and differential-expression analyses have not been rerun to address it. Potential technical confounding therefore cannot be excluded, and the results should be interpreted as exploratory.

### Organism metadata discrepancy

The SRA organism field lists *Hordeum vulgare* for all eight runs, while the study describes wild and cultivated genotypes. The genotype assignments used here follow the study's descriptions; the inconsistency in the SRA organism metadata remains documented.

### Biological replication

Each experimental group contains two biological replicates. This limits statistical power and the stability of differential-expression estimates.

### Reference and annotation

Quantification and functional interpretation depend on the selected transcript reference, transcript-to-gene mapping, and gene annotations. Candidate genes and enriched GO categories require further scrutiny before strong biological conclusions are drawn.

### Interpretation

GO enrichment identifies categories overrepresented in a selected gene list relative to the chosen background; it does not establish causation. PCA separation and differential-expression results likewise do not independently establish biological mechanisms.

The current results have been retained without rerunning quantification or DESeq2. The main outcome is a documented computational workflow and a set of candidate expression patterns for further investigation.

## 11. Future Directions

Potential extensions of this project include:

- **Candidate-gene prioritisation:** Prioritise salt-responsive genes using adjusted p-values, effect sizes, expression patterns, annotation confidence, and biological relevance.
- **Comparative evolutionary analysis:** Investigate sequence conservation and variation in prioritised candidate genes between wild and cultivated barley.
- **Regulatory analysis:** Explore promoter sequences and potential cis-regulatory elements associated with candidate stress-responsive genes.
- **Functional validation:** Compare candidate genes with independent datasets and published evidence; experimental validation could be considered where feasible.
- **Robustness assessment:** Verify library strandedness and evaluate how technical and metadata uncertainties affect the current findings.

These are proposed extensions, not completed analyses. They aim to connect transcriptomic observations with potential evolutionary and regulatory explanations for differences in salt-stress responses.

## 12. Acknowledgement

This project uses publicly available RNA-seq data from the NCBI Sequence Read Archive and builds on the original study cited above. The original authors should receive credit for the biological study and data generation; the computational reanalysis and its interpretations are independent work.
