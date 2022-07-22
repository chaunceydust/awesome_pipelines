
library(tidyverse)

# Argument parsing --------------------------------------------------------

parser <- argparse::ArgumentParser()
parser$add_argument("--taxonomy", type="character", 
                    default="/project/zhouxingchen/bins/ref_genomes_gene_taxanomy.txt",
                    help = "taxonomy annotation file") 
parser$add_argument("--working_directory", type="character", 
                    default="",
                    help = "")
args <- parser$parse_args()


taxdata <- read_tsv(args$taxonomy)
setwd(args$working_directory)

myFiles <- list.files("04_Annotation/")

for (myfile in 1:length(myFiles)) {
 data <- read_tsv(paste0("04_Annotation/", myFiles[myfile])) %>% 
  rename(Gene_ID = Query) %>% 
  left_join(taxdata) %>% 
  select(Gene_ID, BestHit, Type,
         Phylum, Class, Order,
         Family, Genus, Species, Strain,
         everything())

  data[is.na(data)] <- "unclassified"

  outname <- str_replace(myFiles[myfile], pattern = "Annotation", replacement = "Annotation_taxonomy")

  write_tsv(data, paste0("05_taxonomy/", outname)) 
}
