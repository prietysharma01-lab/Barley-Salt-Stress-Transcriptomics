#!/bin/bash
PROJECT="$HOME/Desktop/OIST FOLDER/01_RNAseq_Project"
FASTQ_DIR="$PROJECT/01_FASTQ"
accessions=(SRR16989364 SRR16989365 SRR16989366 SRR16989367 SRR16989368 SRR16989369 SRR16989370 SRR16989371)

cd "$FASTQ_DIR" || exit 1

for accession in "${accessions[@]}"
do
    for read in 1 2
    do
        file="${accession}_${read}.fastq.gz"
        if [ ! -f "$file" ]; then
            echo "MISSING: $file"
        elif gzip -t "$file"; then
            echo "OK: $file"
        else
            echo "CORRUPTED: $file"
        fi
    done
done
