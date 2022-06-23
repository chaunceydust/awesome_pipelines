#!/usr/bin/env Rscript

# Run count_reads.R -h for command-line options.

suppressMessages(library(argparse))
library(Rsubread)

parse_args <- function(cline = commandArgs(trailingOnly = TRUE)) {
  #
  parser <- ArgumentParser(description  = "Counts reads per gene.")
  parser$add_argument("bamfile", nargs = 1, help = "mapped reads in bam format")
  parser$add_argument("exons", nargs = 1, help = "exons in SAF format")
  parser$add_argument("-s", "--stat", default = TRUE, action = "store_true",
                      help = "Output summary statistics of count results. Default: TRUE")
  parser$add_argument("-l", "--len", nargs = 1,
                      help = "file to save lengths (only writes if file does not exist)")
  parser$add_argument("-o", "--outdir", nargs = 1,
                      help = "Write output to this directory.")
  return(parser$parse_args(cline))
}

main <- function(cline = commandArgs(trailingOnly = TRUE)) {
  args <- parse_args(cline)
  results <- featureCounts(files = args$bamfile, annot.ext = args$exons)
  counts <- data.frame(results$annotation$GeneID, results$counts[, 1])
  colnames(counts) <- c("gene", results$targets)
  if (is.null(args$outdir)) {
    out_name <- sub(".bam$", ".counts", args$bamfile)
  } else {
    dir.create(args$outdir, showWarnings = FALSE)
    out_name <- file.path(args$outdir, basename(args$bamfile))
    out_name <- sub(".bam$", ".counts", out_name)
  }
  fname_counts <- paste0
  write.table(counts, file = out_name,
              quote = FALSE, sep = "\t", row.names = FALSE)
  
  if(args$stat) {
    write.table(results$stat, file = sub(".counts$", ".stat", out_name),
                quote = FALSE, sep = "\t", row.names = FALSE)
  }
  
  if(!is.null(args$len)) {
    if (!file.exists(args$len)) {
      gene_len <- data.frame(gene = results$annotation$GeneID,
                             len = results$annotation$Length)
      write.table(gene_len, file = args$len, quote = FALSE, sep = "\t",
                  row.names = FALSE)
    }
  }
}

main()