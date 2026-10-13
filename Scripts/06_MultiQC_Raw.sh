#!/bin/bash
PROJECT="$HOME/Desktop/OIST FOLDER/01_RNAseq_Project"
QC_DIR="$PROJECT/03_QC_Raw/FASTQC"
MULTIQC_DIR="$PROJECT/03_QC_Raw/MultiQC"

mkdir -p "$MULTIQC_DIR"
multiqc "$QC_DIR" --outdir "$MULTIQC_DIR" --force

echo "MultiQC report generated."
