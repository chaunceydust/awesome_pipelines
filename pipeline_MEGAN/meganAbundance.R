library(tidyverse)
# library(phyloseq)


# argument ----------------------------------------------------------------

parser <- argparse::ArgumentParser()
parser$add_argument(
  "--working_directory", 
  type = "character",
  default = "",
  help = "taxonomy annotation file with full path"
)
parser$add_argument(
  "--pop", 
  type = "character",
  default = "AMR",
  help = ""
)
parser$add_argument(
  "--sep", 
  type = "character",
  default = "_",
  help = ""
)
parser$add_argument(
  "--mapping", 
  type = "character",
  default = "Total.cds.seqid2representid.txt",
  help = ""
)
parser$add_argument(
  "--abundance", 
  type = "character",
  default = "AMR.clean.allsample.relativeGeneAbundance.txt",
  help = ""
)
parser$add_argument(
  "--rank",
  type = "character",
  default = "Phylum;Class;Order;Family;Genus;Species;TaxonomyLineage",
  help = "EGGNOG;EC;GTDB;INTERPRO2GO;SEED"
)
args <- parser$parse_args()

setwd(args$working_directory)

mysep <- args$sep # "_"
mypop <- args$pop # "AMR
Ranks <- str_split(
    args$rank,
    pattern = ";",
    simplify = FALSE
) %>% .[[1]]
print(paste0("Levels: ", Ranks))

mappingFile <- args$mapping  # "Total.cds.seqid2representid.txt"
abundanceFile <- args$abundance # "AMR.clean.allsample.relativeGeneAbundance.txt"
ori2repIDmapping <- read_tsv(mappingFile) %>% 
  filter(!is.na(ori.seqid) & !is.na(repre.seqid)) 
Abundata <- read_tsv(abundanceFile)

ifelse(dir.exists("reads"), print("reads directory has exited"), dir.create("reads"))

# 2 -----------------------------------------------------------------------
myPath <- getwd()

for (myRank in Ranks) {
  mydata <- list.files(
    myPath,
    pattern = c(paste0("Reads2", myRank, ".txt", '$')),
    recursive = FALSE,
    full.names = TRUE,
    ignore.case = TRUE
  ) %>% read_tsv()
  
  mydata2 <- mydata %>% 
    left_join(
      ., ori2repIDmapping,
      by = c("Gene_ID" = "repre.seqid")
    ) %>% 
    select(
      -Gene_ID
    ) %>% 
    separate(
      ., col = "ori.seqid",
      into = c("StrainID", "GeneID"),
      sep = mysep
    ) %>% 
    mutate(
      GeneID = paste0(StrainID, "_", GeneID)
    ) %>% 
    left_join(
      ., Abundata,
      by = c("GeneID" = "gene.id")
    )
  mydata2$relat.abundance[is.na(mydata2$relat.abundance)] <- 0
  
  
  StrainList <- unique(mydata2$StrainID)
  
  for (list in StrainList) {
    tmp <- mydata2 %>% 
      filter(StrainID == list) %>% 
      write_tsv(
        ., file = paste0("reads/", list, ".", myRank, ".reads.txt")
      )
  }
  
  colnames(mydata2)[1] <- "ID"
  mydata2 %>% 
    group_by(
      ID, StrainID
    ) %>%
    summarise(
      abun = sum(relat.abundance)
    ) %>% 
    ungroup() %>% 
    pivot_wider(
      names_from = "StrainID",
      values_from = "abun",
      values_fill = 0
    ) %>% 
    write_tsv(
      .,
      paste0(mypop, ".", myRank, ".related.abundance.txt")
    )
}

