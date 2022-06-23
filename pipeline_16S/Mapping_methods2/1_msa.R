#!/usr/bin/env Rscript

library(ggmsa)
library(tidyverse)
options(stringsAsFactors = FALSE)


get_region <- function(data) {
  
  data <- as.vector(data)
  
  m <- 1
  while (TRUE) {
    temp1 <- data[1:m]
    if (length(which(as.vector(temp1) != "-")) 
        == 1) {
      break
    }
    m <- m + 1
  }
  
  whitespace <- m
  sLen <- length(which(as.vector(data) != "-"))
  
  
  while (TRUE) {
    n <- sLen + whitespace
    temp2 <- data[1:n]
    
    if (length(which(as.vector(temp2) != "-")) 
        == sLen) {
      break
      print("he")
    }
    whitespace <- length(which(as.vector(temp2) 
                               == "-"))
  }
  
  return(c(m, n))
}

get_area <- function(data, myName) {
  pos <- as.data.frame(
    t(apply(Data2[-1,], 1, get_region))
  )
  
  result <- data.frame(
    name = myName,
    
    R1_mean = mean(pos$V1[which(pos$V1 <= fivenum(pos$V1)[4] + 1.5*IQR(pos$V1) & pos$V1 >= fivenum(pos$V1)[2] - 1.5*IQR(pos$V1))]),
    R1_sd = sd(pos$V1[which(pos$V1 <= fivenum(pos$V1)[4] + 1.5*IQR(pos$V1) & pos$V1 >= fivenum(pos$V1)[2] - 1.5*IQR(pos$V1))]),
    
    R2_mean = mean(pos$V2[which(pos$V2 <= fivenum(pos$V2)[4] + 1.5*IQR(pos$V2) & pos$V2 >= fivenum(pos$V2)[2] - 1.5*IQR(pos$V2))]),
    R2_sd = sd(pos$V2[which(pos$V2 <= fivenum(pos$V2)[4] + 1.5*IQR(pos$V2) & pos$V2 >= fivenum(pos$V2)[2] - 1.5*IQR(pos$V2))])
  )
  
  return(result)
  
}

result <- data.frame(
  name = NULL,
  
  R1_mean = NULL,
  R1_sd = NULL,
  
  R2_mean = NULL,
  R2_sd = NULL
)

fileslist <- list.files(path = "./",pattern = "*_n100.align.fasta")

for (sequences in fileslist) {
  Data <-  tidy_msa(paste0("./", sequences), 
                    start = NULL, end = NULL) %>% 
    spread(key = position, 
           value = character, fill = NA)
  
  Data2 <- select(Data, -c(1, which(Data[1,] == "-")))
  
  filename <- str_split(sequences, pattern = "_")[[1]][1]
  
  result <- rbind(result,
                  get_area(Data2[-1,], 
                           myName = filename))
}

# str_split(result$name[2])
# str_match(result$name[2], pattern = "*.([12])")
# strsplit(result$name[2], split = "[.]")

result2 <- result %>% 
  separate(col = name,
           into = c("name", "side"),
           sep = "[.]")

result2$pairs <- paste0("pair", result2$side)

write_tsv(result2,
          "mapping_area.tsv")

pic <- ggplot(result2) +
  geom_segment( aes(x=name, xend=name, 
                    y=R1_mean, yend=R2_mean,
                    )) +
  geom_point( aes(x=name, y=R1_mean,
                  ),
              
              size=3 ) +
  geom_point( aes(x=name, y=R2_mean,
                  ), 
              size=3 ) +
  coord_flip()+
  facet_wrap(facets = .~pairs) +
  theme_bw(base_size = 15) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "none",
  ) +
  ylab("16S rRNA gene region") +
  xlab("Samples")

pdf("mapping_region.pdf", width = 12, height = 10)
pic
dev.off()




