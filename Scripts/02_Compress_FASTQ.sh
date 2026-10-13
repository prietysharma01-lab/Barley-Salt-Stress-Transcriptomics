#!/bin/bash
PROJECT="$HOME/Desktop/OIST FOLDER/01_RNAseq_Project"
FASTQ_DIR="$PROJECT/01_FASTQ"
cd "$FASTQ_DIR" || exit 1

for file in *.fastq
do
    [ -e "$file" ] || continue
    echo "Compressing $file ..."
    gzip "$file"
done

echo "FASTQ compression complete."
