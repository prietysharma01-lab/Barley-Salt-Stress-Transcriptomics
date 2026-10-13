#!/bin/bash
PROJECT="$HOME/Desktop/OIST FOLDER/01_RNAseq_Project"

mkdir -p "$PROJECT/02_Metadata" "$PROJECT/03_QC_Raw/FASTQC" "$PROJECT/03_QC_Raw/MultiQC" "$PROJECT/04_Preprocessing" "$PROJECT/05_QC_Clean" "$PROJECT/06_Alignment" "$PROJECT/07_Quantification" "$PROJECT/08_Differential_Expression" "$PROJECT/09_Functional_Analysis" "$PROJECT/10_Figures" "$PROJECT/11_Reports" "$PROJECT/12_Scripts"

echo "Project folders created."
