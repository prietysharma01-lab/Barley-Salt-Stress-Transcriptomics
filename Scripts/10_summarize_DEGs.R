project <- path.expand("~/Desktop/OIST FOLDER/01_RNAseq_Project")
outdir <- file.path(project, "08_Differential_Expression")

files <- c(
  "DEG_TS_vs_TC.csv",
  "DEG_SS_vs_SC.csv",
  "DEG_TC_vs_SC.csv",
  "DEG_TS_vs_SS.csv",
  "DEG_Genotype_Treatment_Interaction.csv"
)

summary_list <- list()

for (f in files) {
  d <- read.csv(file.path(outdir, f), check.names = FALSE)
  d <- d[!is.na(d$padj), ]

  sig <- d[d$padj < 0.05, ]
  up <- sig[sig$log2FoldChange > 0, ]
  down <- sig[sig$log2FoldChange < 0, ]
  strong <- sig[abs(sig$log2FoldChange) >= 1, ]

  summary_list[[f]] <- data.frame(
    Comparison = sub("\\.csv$", "", f),
    Genes_with_adjusted_p_values = nrow(d),
    Significant_FDR_0.05 = nrow(sig),
    Upregulated = nrow(up),
    Downregulated = nrow(down),
    Significant_with_abs_log2FC_at_least_1 = nrow(strong)
  )

  sig <- sig[order(sig$padj), ]
  write.csv(
    head(sig, 20),
    file.path(outdir, paste0(sub("\\.csv$", "", f), "_top20.csv")),
    row.names = FALSE
  )
}

summary_df <- do.call(rbind, summary_list)

write.csv(
  summary_df,
  file.path(outdir, "DEG_summary.csv"),
  row.names = FALSE
)

print(summary_df, row.names = FALSE)
cat("\nSummary saved to:", file.path(outdir, "DEG_summary.csv"), "\n")
