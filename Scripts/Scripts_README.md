# RNA-seq Analysis Scripts

This directory contains shell scripts for sequencing-data preparation and quality control, followed by R scripts for expression-matrix generation, sample-level analysis, differential-expression analysis, result summarisation, visualisation, and GO gene-list preparation.

The scripts document the workflow used for the barley salt-stress transcriptomic project. They currently reference the original local analysis directory and may require path changes before execution on another computer.

## 1. Shell Scripts

Run these scripts in the documented workflow order only when the required inputs and software are available.

| Script | Purpose |
|---|---|
| `01_SRA_to_FASTQ.sh` | Convert SRA files into paired-end FASTQ files using `fasterq-dump --split-files`. |
| `02_Compress_FASTQ.sh` | Compress uncompressed FASTQ files using `gzip`. |
| `03_Verify_FASTQ.sh` | Check expected paired-end FASTQ files and test gzip integrity. |
| `04_Create_Project_Folders.sh` | Create the analysis project's directory structure. |
| `05_FastQC_All_Raw.sh` | Run FastQC on compressed raw-read files. |
| `06_MultiQC_Raw.sh` | Aggregate raw-read FastQC reports with MultiQC. |

### Expected input and output locations

The scripts were developed around the original local project directory:

`~/Desktop/OIST FOLDER/01_RNAseq_Project`

The original workflow uses the following locations:

- SRA input files: `00_SRA/` in the original project.
- FASTQ files: `01_FASTQ/`.
- Raw FastQC reports: `03_QC_Raw/FASTQC/`.
- Raw MultiQC reports: `03_QC_Raw/MultiQC/`.
- Preprocessed reads: `04_Preprocessing/`.
- Clean-read QC: `05_QC_Clean/`.

The scripts currently contain environment-specific paths. In particular, `01_SRA_to_FASTQ.sh` currently specifies `SRA/` rather than the original `00_SRA/` directory. Verify and correct this path before using that script.

The SRA Toolkit and FastQC executable paths may also need to be updated for another machine.

Do not decompress `.fastq.gz` files solely to run FastQC; FastQC can read gzip-compressed FASTQ files directly.

**Important:** These scripts were documented after the data-preparation workflow had been completed. Do not rerun data retrieval, conversion, compression, or preprocessing merely to inspect the repository's existing outputs.

## 2. R Analysis Scripts

| Script | Purpose |
|---|---|
| `07_import_salmon.R` | Import Salmon quantification estimates using tximport and generate gene-level count, TPM, and length matrices. |
| `08_sample_QC.R` | Perform sample-level QC, including PCA and sample-clustering visualisation, and write checked sample metadata. |
| `09_differential_expression.R` | Run DESeq2 differential-expression analysis for genotype, treatment, and interaction effects. |
| `10_summarize_DEGs.R` | Summarise significant DEGs and generate top-20 result tables. |
| `11_volcano_plots.R` | Generate volcano plots for the differential-expression comparisons. |
| `12_prepare_GO_gene_lists.R` | Prepare upregulated and downregulated gene lists for GO enrichment. |
| `13_prepare_GO_LFC15_lists.R` | Prepare additional GO gene lists using an absolute log2 fold-change threshold of 1.5. |

### Main analysis inputs

The R scripts reference files from the original analysis project, including:

- Salmon quantification outputs under `07_Quantification/`.
- Sample metadata under `02_Metadata/`.
- Transcript-to-gene mapping under `06_Alignment/Reference/`.
- Differential-expression outputs under `08_Differential_Expression/`.

The scripts write outputs to the original project's differential-expression, functional-analysis, and figure directories. These paths do not automatically point to the `Results/` and `Figures/` directories in this GitHub repository.

Before executing the R scripts in a new environment, review the project path, input files, reference files, package dependencies, and output destinations.

## 3. Software and Dependencies

The documented workflow uses:

- SRA Toolkit 3.4.1
- FastQC 0.13.0
- MultiQC 1.35
- fastp 1.4.0
- Salmon 2.8.0
- R 4.6.1
- tximport 1.40.0
- DESeq2 1.52.0
- ggplot2
- pheatmap
- AgriGO (web-based GO enrichment; version not recorded)

The R scripts use packages including `tximport`, `DESeq2`, `ggplot2`, and `pheatmap`. Install compatible package versions before executing the corresponding scripts.

## 4. Reproducibility Notes

- The repository contains selected results and figures; it does not contain the original raw FASTQ files, SRA files, Salmon index, or all reference and annotation files.
- SRA accessions and the original study are documented in the main `README.md`.
- The scripts use local paths and are not fully portable without configuration.
- The Salmon library-type inference discrepancy remains unresolved, as described in the main README.
- Each experimental group has two biological replicates, so the differential-expression results should be interpreted as exploratory.
- Existing outputs were retained without rerunning quantification or DESeq2 during repository organisation.

The scripts and outputs are intended to document the analysis and support further inspection. A fresh clone should not be assumed to run end-to-end until all paths, input files, references, and dependencies have been configured and verified.
