project <- path.expand("~/Desktop/OIST FOLDER/01_RNAseq_Project")
indir <- file.path(project, "08_Differential_Expression")
figdir <- file.path(project, "10_Figures")

dir.create(figdir, showWarnings = FALSE, recursive = TRUE)

files <- c(
  "DEG_TS_vs_TC.csv",
  "DEG_SS_vs_SC.csv",
  "DEG_TC_vs_SC.csv",
  "DEG_TS_vs_SS.csv",
  "DEG_Genotype_Treatment_Interaction.csv"
)

for (f in files) {
  d <- read.csv(file.path(indir, f))
  d <- d[!is.na(d$padj) & !is.na(d$log2FoldChange), ]

  d$negLog10FDR <- -log10(pmax(d$padj, 1e-300))
  d$status <- "Not significant"

  d$status[d$padj < 0.05 & d$log2FoldChange >= 1] <- "Upregulated"
  d$status[d$padj < 0.05 & d$log2FoldChange <= -1] <- "Downregulated"

  png(
    file.path(figdir, paste0(sub("\\.csv$", "", f), "_volcano.png")),
    width = 1800, height = 1400, res = 180
  )

  plot(
    d$log2FoldChange, d$negLog10FDR,
    pch = 16, cex = 0.45,
    col = ifelse(
      d$status == "Upregulated", "firebrick",
      ifelse(d$status == "Downregulated", "steelblue", "grey75")
    ),
    xlab = "log2 fold change",
    ylab = "-log10 adjusted p-value",
    main = sub("\\.csv$", "", f)
  )

  abline(h = -log10(0.05), lty = 2)
  abline(v = c(-1, 1), lty = 2)

  legend(
    "topright",
    legend = c("Upregulated", "Downregulated", "Not significant"),
    col = c("firebrick", "steelblue", "grey75"),
    pch = 16, cex = 0.8, bty = "n"
  )

  dev.off()
}

cat("Volcano plots saved in:", figdir, "\n")
