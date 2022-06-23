#!/usr/bin/env Rscript

# Run map_fastq.R -h for command-line options.

suppressMessages(library(argparse))
library(ngspipeline)

parse_args <- function(cline = commandArgs(trailingOnly = TRUE)) {
  #
  parser <- ArgumentParser(description  = "Maps a fastq file.")
  parser$add_argument("fastq", nargs = 1, help = "fastq file")
  parser$add_argument("genome", nargs = 1, help = "indexed genome")
  return(parser$parse_args(cline))
}

main <- function(cline = commandArgs(trailingOnly = TRUE)) {
  args <- parse_args(cline)
  map_reads(index = args$genome, readfile1 = args$fastq)
}

main()