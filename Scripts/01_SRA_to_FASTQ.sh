#!/bin/bash
PROJECT="$HOME/Desktop/OIST FOLDER/01_RNAseq_Project"
SRA_DIR="$PROJECT/SRA"
FASTQ_DIR="$PROJECT/01_FASTQ"
SRA_TOOLKIT="$HOME/Desktop/OIST FOLDER/sratoolkit.3.4.1-mac-arm64/bin/fasterq-dump"

mkdir -p "$FASTQ_DIR"

for accession in SRR16989364 SRR16989365 SRR16989366 SRR16989367 SRR16989368 SRR16989369 SRR16989370 SRR16989371
do
    echo "Converting $accession ..."
    "$SRA_TOOLKIT" "$SRA_DIR/$accession/$accession.sra" --split-files -O "$FASTQ_DIR"
done

echo "All SRA files have been converted."
