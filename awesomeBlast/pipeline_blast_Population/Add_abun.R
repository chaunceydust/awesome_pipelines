arg <- commandArgs(T)
if(length(arg) < 3){
  cat("Argument: relat_abunFile outDir \n")
  quit('no')
}
print(arg)

relat_abunFile <- arg[1]; # "HADZA_allIndi.clean.aln.relativeGeneAbundance.txt" 
outDir <- arg[2];
setwd(outDir)

CoverLength=as.numeric(arg[3:length(arg)])

library(tidyverse)

relat_abun <- read_tsv(relat_abunFile)

Files <- list.files(path = "./",
                    pattern = "Annotation_\\S+.tsv",
                    all.files = TRUE)

for (myFile in 1:length(Files)) {
  
  myname <- basename(Files[myFile]) %>% 
    str_remove(pattern = ".tsv")
  
  data <- read_tsv(Files[myFile]) %>% 
    left_join(., relat_abun) %>% 
    select(Pop_ID, Indi_id, gene_id,
           BestHit, Type, relat_abundance,
           everything()) %>% 
    mutate(
      QueryCover = as.numeric(HSPlength)/as.numeric(QueryLength),
      HitCover = as.numeric(HSPlength)/as.numeric(HitLength)
    )
  
  data$relat_abundance[is.na(data$relat_abundance)] <- 0
  
  for (L in 1:length(CoverLength)) {
    mydata <- data %>% 
      filter(
        QueryCover >= CoverLength[L]/100 & HitCover >= CoverLength[L]/100
      ) 
      
    write_tsv(mydata,
              paste0(myname, "_L", CoverLength[L], "_relAbun.tsv"))
  }
  
}
