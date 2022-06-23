
# Transfer files from multiple Casava directories to one new directory, while
# also naming the filenames to include their sampleID, flow cell, lane, and
# index.

# https://bitbucket.org/jdblischak/ngspipeline/src
library("ngspipeline")

start_loc <- "/media/Seagate Backup Plus Drive/DATA/flow_cells/TB"
end_loc <- "/media/Seagate Backup Plus Drive/DATA/flow_cells/jdblischak@uchicago.edu"

flow_cells <- read.csv("../data/flow-cells.csv", stringsAsFactors = FALSE)

for (i in 1:nrow(flow_cells)) {
  print(flow_cells$name[i])
  fc_dir <- list.files(path = start_loc, pattern = flow_cells$name[i],
                       full.names = TRUE)
  fc_dir <- file.path(fc_dir, "Demultiplexed")
  lanes_to_keep <- strsplit(x = flow_cells$lanes[i], split = ";")[[1]]
  lanes_to_keep <- as.numeric(lanes_to_keep)
  sort_casava(casava_dir = fc_dir, new_dir = end_loc, single_dir = TRUE,
              limit_lanes = lanes_to_keep, add_sample_name = TRUE,
              copy = TRUE)
}

# Check the that files transferred correctly I ran md5sum on both the files
# transferred to the external hard drive and the files as I have them organized
# on the cluster. I stored the results in md5sum_transferred.txt and
# md5sum_original.txt, respectively.

# Run on transferred files:
# md5sum /media/Seagate\ Backup\ Plus\ Drive/DATA/flow_cells/jdblischak@uchicago.edu/*fastq.gz > ../data/md5sum_transferred.txt

# Run on original files on cluster:
# echo "md5sum ~/tb/data/fastq/*.fastq.gz > ../data/md5sum_original.txt" | qsub -l h_vmem=32g -j y -o check_md5 -cwd

md5sum_orig <- read.table("../data/md5sum_original.txt",
                          stringsAsFactors = FALSE)
md5sum_trans <- read.table("../data/md5sum_transferred.txt",
                           stringsAsFactors = FALSE)

bad_transfers <- which(md5sum_orig$V1 != md5sum_trans$V1)
stopifnot(length(bad_transfers) == 0)
# md5sum_orig[bad_transfers, ]
# md5sum_trans[bad_transfers, ]

# Rename files so that they have more identifying information
anno <- read.table("../data/annotation.txt", header = TRUE, sep = "\t",
                   stringsAsFactors = FALSE)
fq_names <- list.files(path = end_loc, pattern = "*fastq.gz")
fq_names_split <- strsplit(fq_names, "-")
fq_id <- sapply(fq_names_split, function(x) x[1])
fq_id <- as.numeric(fq_id)
file.create("../data/rename_record.txt")
for (i in seq_along(fq_names)) {
  new_name <- paste(anno$ind[fq_id[i]],  anno$bact[fq_id[i]],
                    anno$time[fq_id[i]], fq_names[i], sep = "-")
  new_name <- file.path(end_loc, new_name)
  old_name <- file.path(end_loc, fq_names[i])
  cat(sprintf("%s\t%s\n", old_name, new_name), file = "../data/rename_record.txt",
      sep = "", append = TRUE)
  file.rename(from = old_name, to = new_name)
}

# Create Samples table for GEO submission
md5sum_combined <- read.table("../data/md5sum_combined.txt",
                              stringsAsFactors = FALSE)
colnames(md5sum_combined) <- c("md5sum", "filename")
rownames(md5sum_combined) <- sub(".fastq.gz", "", md5sum_combined$filename)
# head(md5sum_combined)
title <- paste(anno$ind, anno$bact, anno$time, sep = "-")
geo <- data.frame(name = anno$dir,
                  title = title,
                  source = "monocyte-derived macrophages",
                  organism = "Homo sapiens",
                  ind = anno$ind,
                  bact = anno$bact,
                  time = anno$time,
                  batch = anno$extr,
                  rin = anno$rin,
                  index = anno$index,
                  molecule = "RNA",
                  raw_file = paste0(title, ".fastq.gz"),
                  file_type = "fastq",
                  checksum = md5sum_combined[title, "md5sum"],
                  instrument = "HiSeq 2500",
                  read_length = 50,
                  seq_type = "single",
                  stringsAsFactors = FALSE)
# head(geo)
write.table(geo, "../data/geo-sample-description.txt", sep = "\t",
            row.names = FALSE, quote = FALSE)

# Checksum the gene expression matrix, table-s1.txt
tools::md5sum("../data/table-s1.txt")
