library(DESeq2)
library(ggplot2)
library(pheatmap)

project <- path.expand("~/Desktop/OIST FOLDER/01_RNAseq_Project")

counts <- read.csv(
  file.path(project, "08_Differential_Expression/gene_counts.csv"),
  row.names = 1,
  check.names = FALSE
)
metadata <- read.csv(
  file.path(project, "02_Metadata/sample_metadata.csv"),
  row.names = 1
)

metadata <- metadata[colnames(counts), , drop = FALSE]
stopifnot(identical(rownames(metadata), colnames(counts)))

metadata$Group <- factor(metadata$Group, levels = c("SC", "SS", "TC", "TS"))

dds <- DESeqDataSetFromMatrix(
  countData = round(as.matrix(counts)),
  colData = metadata,
  design = ~ Genotype + Treatment
)

dds <- estimateSizeFactors(dds)
vsd <- vst(dds, blind = TRUE)

dir.create(file.path(project, "10_Figures"), showWarnings = FALSE)

p <- plotPCA(vsd, intgroup = c("Group")) +
  ggtitle("Barley RNA-seq: sample PCA") +
  theme_minimal(base_size = 12)

ggsave(
  file.path(project, "10_Figures/PCA_samples.png"),
  p, width = 8, height = 6, dpi = 300
)

sample_dist <- dist(t(assay(vsd)))
sample_mat <- as.matrix(sample_dist)
rownames(sample_mat) <- colnames(sample_mat) <- colnames(counts)

png(file.path(project, "10_Figures/Sample_clustering_heatmap.png"),
    width = 1800, height = 1500, res = 200)
pheatmap(
  sample_mat,
  main = "Sample-to-sample distance (VST counts)",
  border_color = NA
)
dev.off()

write.csv(
  as.data.frame(colData(dds)),
  file.path(project, "08_Differential_Expression/sample_metadata_checked.csv")
)

cat("PCA and clustering heatmap saved.\n")
cat("PCA: 10_Figures/PCA_samples.png\n")
cat("Heatmap: 10_Figures/Sample_clustering_heatmap.png\n")
