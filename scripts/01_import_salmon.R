library(tximport)

project <- path.expand("~/Desktop/OIST FOLDER/01_RNAseq_Project")

samples <- paste0("SRR169893", 64:71)

files <- file.path(
  project, "07_Quantification", samples, "quant.sf"
)
names(files) <- samples

stopifnot(all(file.exists(files)))

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

dir.create(
  file.path(project, "08_Differential_Expression"),
  showWarnings = FALSE,
  recursive = TRUE
)

write.csv(
  txi$counts,
  file.path(project, "08_Differential_Expression/gene_counts.csv")
)

write.csv(
  txi$abundance,
  file.path(project, "08_Differential_Expression/gene_TPM.csv")
)

write.csv(
  txi$length,
  file.path(project, "08_Differential_Expression/gene_lengths.csv")
)

cat("Samples imported:", ncol(txi$counts), "\n")
cat("Genes imported:", nrow(txi$counts), "\n")
cat("Sample columns:", paste(colnames(txi$counts), collapse = ", "), "\n")
