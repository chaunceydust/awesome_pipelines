#!/usr/bin/env Rscript

# Run organize_files.R -h for command-line options.

suppressMessages(library(argparse))
library(ngspipeline)

parse_args <- function(cline = commandArgs(trailingOnly = TRUE)) {
  #
  parser <- ArgumentParser(description  = "Sorts fastq files.")
  parser$add_argument("fc", nargs = 1, help = "List of flow cells (csv file)")
  parser$add_argument("new_dir", nargs = 1, help = "The directory to create symlinks")
  return(parser$parse_args(cline))
}

main <- function(cline = commandArgs(trailingOnly = TRUE)) {
  args <- parse_args(cline)
  fc <- read.csv(args$fc, stringsAsFactors = FALSE)
#   for (path in fc$path) {print(path); print(list.files(path, include.dirs = TRUE))}
#   stop()
  if (nrow(fc) < 1) {
    stop(sprintf("%s is empty.", args$fc))
  }
  for (i in 1:nrow(fc)) {
    lanes <- unlist(strsplit(fc[i, "lanes"], ";"))
    sort_casava(fc[i, "path"], args$new_dir, limit_lanes = lanes,
                add_sample_name = TRUE)
  }
}

# main()
main(c("data/flow-cells.csv", "samples/"))