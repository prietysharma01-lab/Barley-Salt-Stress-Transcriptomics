library(tximport)
library(DESeq2)

project <- path.expand("~/Desktop/OIST FOLDER/01_RNAseq_Project")

samples <- paste0("SRR169893", 64:71)

files <- file.path(
  project, "07_Quantification", samples, "quant.sf"
)
names(files) <- samples

stopifnot(all(file.exists(files)))

metadata <- read.csv(
  file.path(project, "02_Metadata/sample_metadata.csv"),
  stringsAsFactors = FALSE
)
rownames(metadata) <- metadata$Sample
metadata <- metadata[samples, , drop = FALSE]

stopifnot(identical(rownames(metadata), samples))

metadata$Genotype <- factor(
  metadata$Genotype,
  levels = c("Cultivated", "Wild")
)
metadata$Treatment <- factor(
  metadata$Treatment,
  levels = c("Control", "Salt")
)

tx2gene <- read.delim(
  file.path(project, "06_Alignment/Reference/transcript_to_gene.tsv"),
  header = FALSE,
  sep = "\t",
  col.names = c("TXNAME", "GENEID"),
  stringsAsFactors = FALSE
)

txi <- tximport(
  files,
  type = "salmon",
  tx2gene = tx2gene,
  ignoreTxVersion = FALSE
)

dds <- DESeqDataSetFromTximport(
  txi,
  colData = metadata,
  design = ~ Genotype + Treatment + Genotype:Treatment
)

keep <- rowSums(counts(dds) >= 10) >= 2
dds <- dds[keep, ]

dds <- DESeq(dds)

outdir <- file.path(project, "08_Differential_Expression")
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

# Salt response in cultivated barley
res_SS_vs_SC <- results(
  dds,
  name = "Treatment_Salt_vs_Control"
)

# Salt response in wild barley: treatment effect + interaction
res_TS_vs_TC <- results(
  dds,
  contrast = list(c(
    "Treatment_Salt_vs_Control",
    "GenotypeWild.TreatmentSalt"
  ))
)

# Wild vs cultivated under control conditions
res_TC_vs_SC <- results(
  dds,
  name = "Genotype_Wild_vs_Cultivated"
)

# Wild vs cultivated under salt: genotype effect + interaction
res_TS_vs_SS <- results(
  dds,
  contrast = list(c(
    "Genotype_Wild_vs_Cultivated",
    "GenotypeWild.TreatmentSalt"
  ))
)

# Does the salt response differ by genotype?
res_interaction <- results(
  dds,
  name = "GenotypeWild.TreatmentSalt"
)

save_result <- function(res, filename) {
  df <- as.data.frame(res)
  df$GeneID <- rownames(df)
  df <- df[order(df$padj, na.last = TRUE), ]
  write.csv(
    df,
    file.path(outdir, filename),
    row.names = FALSE
  )
}

save_result(res_SS_vs_SC, "DEG_SS_vs_SC.csv")
save_result(res_TS_vs_TC, "DEG_TS_vs_TC.csv")
save_result(res_TC_vs_SC, "DEG_TC_vs_SC.csv")
save_result(res_TS_vs_SS, "DEG_TS_vs_SS.csv")
save_result(res_interaction, "DEG_Genotype_Treatment_Interaction.csv")

write.csv(
  as.data.frame(counts(dds, normalized = TRUE)),
  file.path(outdir, "normalized_gene_counts.csv")
)

write.csv(
  as.data.frame(metadata),
  file.path(outdir, "analysis_metadata.csv")
)

writeLines(
  capture.output(sessionInfo()),
  file.path(outdir, "R_sessionInfo.txt")
)

cat("Analysis complete.\n")
cat("Genes tested:", nrow(dds), "\n")
cat("Samples:", ncol(dds), "\n")
cat("Results saved to:", outdir, "\n")
cat("DESeq2 result names:\n")
print(resultsNames(dds))
