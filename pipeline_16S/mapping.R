
library(tidyverse);
(files <- list.files(pattern = "*.asvclass.txt"))

RESULT <- data.frame(char = character(),
                     freq = numeric(),
                     Sample = character())

extractRANK <- function(myfile) {
  library(jiebaR)
  
  flg <- sub(".asvclass.txt", "", myfile)
  
  asv <- read.delim(myfile, sep = "\t")
  report <- read.delim(paste0(flg, ".kreport2"), 
                       header = FALSE, sep = "\t")
  report <- report[4:5]
  colnames(report) <- c("Rank", "spid")
  
  data <- merge(asv, report, all.x = TRUE)
  result <- freq(data$Rank)
  result$Sample <- flg
  
  return(result)
}

ccc <- lapply(files, extractRANK)

for (i in 1:length(files)) {
  RESULT <- rbind(RESULT, ccc[[i]])
}

RESULT$char <- str_sub(RESULT$char, 1, 1)

RESULT %<>% 
  group_by(Sample, char) %>% 
  summarise(
    freq = sum(freq)
  ) %>% 
  ungroup()

total <- RESULT %>% 
  group_by(Sample) %>% 
  summarise(
    total = sum(freq)
  ) %>% 
  ungroup()

RESULT <- full_join(RESULT, total)
RESULT$RATIO <- RESULT$freq / RESULT$total * 100

unique(RESULT$char)

RESULT$char <- factor(RESULT$char,
                      levels = c("D", "P", "C", "O",
                                 "F", "G", "S"),
                      labels = c("Domain",
                                 "Phylum",
                                 "Class", 
                                 "Order",
                                 "Family",
                                 "Genus",
                                 "Species"))

ggplot(RESULT,
       aes(Sample, RATIO,
           fill = char)) +
  geom_bar(stat = "identity",
           position = "stack") +
  theme_classic() +
  theme(
    axis.text.x.bottom = element_text(angle = 60,
                                      hjust = 1)
  )
ggsave("species_ratio.pdf",
       width = 6, height = 4)

RESULTn <- RESULT[c(1, 2, 5)] %>% 
  pivot_wider(names_from = char,
              values_from = RATIO,
              values_fill = 0)

write.table(RESULTn, "ratio.txt",
            col.names = TRUE, row.names = FALSE,
            quote = FALSE, sep = '\t')



# mapping area ------------------------------------------------------------

(files <- list.files(pattern = "*scv"))
MAP <- data.frame(V1 = character(),
                  V2 = numeric(),
                  flg = character())

for (m in files) {
  flg <- sub(".scv", "", m)
  map <- read.csv(m, header = FALSE)
  map$sample <- flg
  
  MAP <- rbind(MAP, map)
}
colnames(MAP)[1:2] <- c("map", "freq")
MAP2 <- MAP %>% 
  pivot_wider(names_from = sample,
              values_from = freq,
              values_fill = 0)

MAP2 <- MAP2[-which(rowSums(MAP2[-1]) == 0),]

library(pheatmap)
plot.data <- as.matrix(MAP2[-1])
rownames(plot.data) <- MAP2$map


p1 <- pheatmap(plot.data,
               # main = '',
               fontsize = 15,
               border_color = 'grey',   #yellow
               cluster_rows = F,cluster_cols = F,
               scale = 'column',
               # gaps_col = c(9,9,9,11,11,11),
               # gaps_row = cumsum(No$N[1]),
               # annotation_col = annocol.card,
               # annotation_row = anno_genus,
               color = colorRampPalette(c("#00FF00", "white", "#EE0000"))(100),
               # color = colorRampPalette(c("navy", "white", "firebrick3"))(500),
               cellwidth = 20,cellheight = 14,
               fontsize_col = 15,fontsize_row = 15,
               # display_numbers = plot.card ,
               # legend = T,legend_breaks = c(0,2.5,5)
               # leg
               # legend_labels = c("S","I","R")
)
pdf("MAParea.pdf", width = 8, height = 6)
p1
dev.off()
