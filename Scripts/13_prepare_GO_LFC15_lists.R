project <- path.expand("~/Desktop/OIST FOLDER/01_RNAseq_Project")

de_dir <- file.path(project, "08_Differential_Expression")
go_dir <- file.path(project, "09_Functional_Analysis")

comparisons <- c("TS_vs_TC", "SS_vs_SC", "TC_vs_SC", "TS_vs_SS")

for (comparison in comparisons) {
  input_file <- file.path(de_dir, paste0("DEG_", comparison, ".csv"))
  results <- read.csv(input_file, check.names = FALSE)

  results <- results[
    !is.na(results$GeneID) & results$GeneID != "", ]

  output_dir <- file.path(
    go_dir, paste0("GO_", comparison), "01_Input_Gene_Lists"
  )
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  significant <- !is.na(results$padj) & results$padj < 0.05

  up <- unique(results$GeneID[
    significant & results$log2FoldChange >= 1.5
  ])

  down <- unique(results$GeneID[
    significant & results$log2FoldChange <= -1.5
  ])

  writeLines(up, file.path(output_dir, "Upregulated_FDR05_LFC15.txt"))
  writeLines(down, file.path(output_dir, "Downregulated_FDR05_LFC15.txt"))

  cat("\n", comparison, "\n")
  cat("Upregulated (FDR < 0.05, log2FC >= 1.5):", length(up), "\n")
  cat("Downregulated (FDR < 0.05, log2FC <= -1.5):", length(down), "\n")
}

cat("\nLFC 1.5 list preparation complete.\n")
