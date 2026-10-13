project <- path.expand("~/Desktop/OIST FOLDER/01_RNAseq_Project")

de_dir <- file.path(project, "08_Differential_Expression")
go_dir <- file.path(project, "09_Functional_Analysis")

comparisons <- c("SS_vs_SC", "TC_vs_SC", "TS_vs_SS")

for (comparison in comparisons) {
  input_file <- file.path(de_dir, paste0("DEG_", comparison, ".csv"))
  results <- read.csv(input_file, check.names = FALSE)

  results <- results[!is.na(results$GeneID) & results$GeneID != "", ]

  output_dir <- file.path(go_dir, paste0("GO_", comparison),
                          "01_Input_Gene_Lists")
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  up <- results$GeneID[
    !is.na(results$padj) &
    results$padj < 0.05 &
    results$log2FoldChange > 0
  ]

  down <- results$GeneID[
    !is.na(results$padj) &
    results$padj < 0.05 &
    results$log2FoldChange < 0
  ]

  background <- unique(results$GeneID)

  writeLines(unique(up), file.path(output_dir, "Upregulated_FDR05.txt"))
  writeLines(unique(down), file.path(output_dir, "Downregulated_FDR05.txt"))
  writeLines(background, file.path(output_dir, "Background_All_Tested_Genes.txt"))

  cat("\n", comparison, "\n")
  cat("Upregulated:", length(unique(up)), "\n")
  cat("Downregulated:", length(unique(down)), "\n")
  cat("Background:", length(background), "\n")
}

cat("\nGene-list preparation complete.\n")
