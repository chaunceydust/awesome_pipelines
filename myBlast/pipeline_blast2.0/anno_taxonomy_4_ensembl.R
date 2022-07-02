
library(tidyverse)

# Argument parsing --------------------------------------------------------

parser <- argparse::ArgumentParser()
parser$add_argument("--taxonomy", type="character", 
                    default="/project/Ref_database/Ensembl/release-51/fungi/TaxonomyLineage_species_EnsemblFungi_release51.txt",
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
  mutate(
    `#ID` = str_split(.$Query, pattern = "\\|", simplify = TRUE)[,1]
  ) %>%
  rename(Gene_ID = Query) %>% 
  left_join(taxdata) %>% 
  select(Gene_ID, BestHit, Type,
         phylum, class, order,
         family, genus, species, strain,
         everything())

  data[is.na(data)] <- "unclassified"

  outname <- str_replace(myFiles[myfile], pattern = "Annotation", replacement = "Annotation_taxonomy")

  write_tsv(data, paste0("05_taxonomy/", outname)) 
}
