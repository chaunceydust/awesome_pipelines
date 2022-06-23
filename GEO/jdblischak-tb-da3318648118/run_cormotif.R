#!/usr/bin/env Rscript

# Run run_cormotif.R -h for command-line options.

# To parallelize, run from with code directory:
# for i in {1..1000}
# do
# echo "Rscript run_cormotif.R 5 $i" | qsub -l h_vmem=2g -cwd -N cormotif.5.$i -j y -V
# done

suppressMessages(library(argparse))
source("cormotif.R")
suppressMessages(library("Biobase"))
suppressMessages(library("edgeR"))

parse_args <- function(cline = commandArgs(trailingOnly = TRUE)) {
  #
  parser <- ArgumentParser(description  = "Runs cormotif.")
  parser$add_argument("exprs", nargs = 1, help = "expression data")
  parser$add_argument("anno", nargs = 1, help = "annotation data")
  parser$add_argument("K", nargs = 1, help = "number of motifs",
                      type = "integer")
  parser$add_argument("seed", nargs = 1, help = "integer for set.seed",
                      type = "integer")
  parser$add_argument("-o", "--out", nargs = 1, help = "Output directory",
                      default = ".")
  parser$add_argument("-t", "--time", nargs = "+", help = "Restrict to timepoints",
                      default = c(4, 18, 48), type = "integer")
  return(parser$parse_args(cline))
}

cline_test <- c("../data/table-s1.txt", "../data/annotation.txt",
                "5", "1", "-o", "../data/cormotif", "-t", "18")
args_test <- parse_args(cline_test)
# str(args_test)

main <- function(cline = commandArgs(trailingOnly = TRUE)) {
  args <- parse_args(cline)
  dat_cpm <- read.table(args$exprs, header = TRUE, sep = "\t")
  # The first two columns are gene information
  rownames(dat_cpm) <- dat_cpm$id
  dat_cpm[, c("id", "name")] <- list(NULL)
  dat_cpm <- as.matrix(dat_cpm)
  
  anno <- read.table(args$anno, header = TRUE, stringsAsFactors = FALSE)
  # Order the bacteria
  anno$bact <- ordered(anno$bact, levels = c("none", "Rv", "Rv+", "GC", "BCG",
                                             "Smeg", "Yers", "Salm", "Staph"))
  # Create a factor for the experiments, with the levels ordered such that
  # as.numeric converts them to numbers in a defined manner
  group_fac <- factor(paste(anno$bact, anno$time, sep = "."),
                      levels = c("none.4", "Rv.4", "Rv+.4", "GC.4", "BCG.4",
                                 "Smeg.4", "Yers.4", "Salm.4", "Staph.4", "none.18",
                                 "Rv.18", "Rv+.18", "GC.18", "BCG.18", "Smeg.18",
                                 "Yers.18", "Salm.18", "Staph.18", "none.48",
                                 "Rv.48", "Rv+.48", "GC.48", "BCG.48", "Smeg.48",
                                 "Yers.48", "Salm.48"))
  groupid <- as.numeric(group_fac)
  stopifnot(which(group_fac == "none.4") == which(groupid == 1),
            which(group_fac == "none.18") == which(groupid == 10),
            which(group_fac == "none.48") == which(groupid == 19))
  compid <- data.frame(Cond1 = rep(c(1, 10, 19), each = 8),
                       Cond2 = c(2:9, 11:18, 20:27))
  compid <- compid[-24, ] # Remove last row b/c no 48 hr Staph sample
  
  # Subset analysis to time points based on args$time
  keep_experiments <- NULL
  if (4 %in% args$time) {
    keep_experiments <- 1:8
  }
  if (18 %in% args$time) {
    keep_experiments <- c(keep_experiments, 9:16)
  }
  if (48 %in% args$time) {
    keep_experiments <- c(keep_experiments, 17:23)
  }
  compid <- compid[keep_experiments, ]
  stopifnot(nrow(compid) > 0)
  
  # Run the analysis
  set.seed(args$seed)
  result <- cormotiffit(exprs = dat_cpm, groupid = groupid, compid = compid,
                        K = args$K, max.iter = 500)
  result$seed <- args$seed
  time_name <- paste(formatC(args$time, format = "d", width = 2, flag = "0"),
                     collapse = ".")
  filename <- sprintf("cormotif_%s_%d_%03d_%f.rds", time_name, args$K,
                      args$seed, result$loglike[2])
  # browser()
  # plotMotif(result)
  # result$loglike
  
  # Save the result
  if (!file.exists(args$out)) {
    dir.create(args$out)
  }
  saveRDS(result, file = file.path(args$out, filename))
}

if (interactive()) {
  x <- main(cline_test)
} else {
  main()
}
