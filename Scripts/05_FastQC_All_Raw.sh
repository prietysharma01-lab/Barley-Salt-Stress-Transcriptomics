#!/bin/bash
PROJECT="$HOME/Desktop/OIST FOLDER/01_RNAseq_Project"
FASTQ_DIR="$PROJECT/01_FASTQ"
QC_DIR="$PROJECT/03_QC_Raw/FASTQC"
FASTQC="/Applications/FastQC.app/Contents/MacOS/fastqc"

mkdir -p "$QC_DIR"

"$FASTQC" --threads 2 --outdir "$QC_DIR" "$FASTQ_DIR"/*.fastq.gz

echo "Raw-read FastQC complete."
