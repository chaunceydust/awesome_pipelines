# Obtain the seed used to create the model with the highest log-likelihood.
# Jobs are dispatched using batch_submit_cormotif.sh, which calls
# run_cormotif.R. The seeds are used in joint_analysis.Rmd.

source("cormotif.R") # my fork of Cormotif v 1.9.2

options(digits = 15)
find_best_model <- function (path, pattern) {
  filenames <- list.files(path, pattern, full.names = TRUE)
  info <- strsplit(filenames, split = "_")
  loglike <- sapply(info, function(x) x[5])
  # remove trailing file extension
  loglike <- sub(pattern = ".rds$", replacement = "", loglike)
  loglike <- as.numeric(loglike)
  best_model <- which(loglike == max(loglike))
  print(best_model)
  stopifnot(length(best_model) == 1)
  cm <- readRDS(filenames[best_model])
  return(cm)
}

cm_all_14 <- find_best_model("../data/cormotif", "cormotif_04.18.48_14")
plotMotif(cm_all_14)
cm_all_14$seed

cm_all_6 <- find_best_model("../data/cormotif", "cormotif_04.18.48_6")
plotMotif(cm_all_6)
cm_all_6$seed

cm_18 <- find_best_model("../data/cormotif", "cormotif_18")
plotMotif(cm_18)
cm_18$seed

cm_48 <- find_best_model("../data/cormotif", "cormotif_48")
plotMotif(cm_48)
cm_48$seed
