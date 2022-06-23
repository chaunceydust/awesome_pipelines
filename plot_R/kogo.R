setwd("D:/Work/zhouxingchen/mywork/Analysis_yigoustrain")

library(tidyverse)
library(ComplexUpset)
#数据展示

#设置绘图区域函数
set_size = function(w, h, factor=1.5) {
  s = 1 * factor
  options(
    repr.plot.width=w * s,
    repr.plot.height=h * s,
    repr.plot.res=100 / factor,
    jupyter.plot_mimetypes='image/png',
    jupyter.plot_scale=1
  )
}

reflect <- read_tsv("reflect.txt",
                    col_names = FALSE)


data <- read_tsv("GeneCounts.tab") %>% 
  .[-c(2:4, 18:19)]

# data[2:14] <- data[2:14] >= 1

colnames(data)[2:14] <- reflect$X2[match(colnames(data)[2:14], reflect$X1)]

data <- data[c(1, 2, 6, 10, 13,
               3, 7, 8, 11,
               4, 5, 9, 12, 14)]

data2 <- data[1]
data2$`C.albicans` <- rowSums(data[c(2:5)])
data2$`C.auri` <- rowSums(data[6:9])
data2$`Mala` <- rowSums(data[10:14])

data2[2:4] <- data[2:4] >= 1

data2 <- data2[-which(rowSums(data2[2:4]) == 0),]

set_size(8, 6)
upset(
  data2, colnames(data2)[2:4], 
  name='', 
  width_ratio=0.1,
  # group_by='sets',
  sort_intersections_by=c('degree', 'cardinality')
)



# Function ----------------------------------------------------------------

# 自定义函数1
fromList <- function (input) {
  elements <- unique(unlist(input))
  data <- unlist(lapply(input, function(x) {
    x <- as.vector(match(elements, x))
  }))
  data[is.na(data)] <- as.integer(0)
  data[data != 0] <- as.integer(1)
  data <- data.frame(matrix(data, ncol = length(input), byrow = F))
  data <- data[which(rowSums(data) != 0), ]
  names(data) <- names(input)
  row.names(data) <- elements
  return(data)
}

# 自定义函数2
get_intersect_members <- function (x, ...){
  require(dplyr)
  require(tibble)
  x <- x[,sapply(x, is.numeric)][,0<=colMeans(x[,sapply(x, is.numeric)],na.rm=T) & colMeans(x[,sapply(x, is.numeric)],na.rm=T)<=1]
  n <- names(x)
  x %>% rownames_to_column() -> x
  l <- c(...)
  a <- intersect(names(x), l)
  ar <- vector('list',length(n)+1)
  ar[[1]] <- x
  i=2
  for (item in n) {
    if (item %in% a){
      if (class(x[[item]])=='numeric'){   #Now uses numeric instead of integer
        ar[[i]] <- paste(item, '>= 1')
        i <- i + 1
      }
    } else {
      if (class(x[[item]])=='numeric'){
        ar[[i]] <- paste(item, '== 0')
        i <- i + 1
      }
    }
  }
  do.call(filter_, ar) %>% column_to_rownames() -> x
  return(x)
}

library(tidyverse)
data3 <- data2 %>% 
  column_to_rownames("OCGID")

data3$C.albicans <- as.numeric(data3$C.albicans)
data3$C.auri <- as.numeric(data3$C.auri)
data3$Mala <- as.numeric(data3$Mala)

Cab <- get_intersect_members(data3, "C.albicans") 
myCab <- data.frame(gene = rownames(Cab))
write_tsv(myCab, "Cab_unique.txt")

Cauri <- get_intersect_members(data3, "C.auri") 
myCauri <- data.frame(gene = rownames(Cauri))
write_tsv(myCauri, "Cauri_unique.txt")

Mala <- get_intersect_members(data3, "Mala") 
myMala <- data.frame(gene = rownames(Mala))
write_tsv(myMala, "Mala_unique.txt")

Cab_Cauri <- get_intersect_members(data3, "C.albicans", "C.auri") 
myCab_Cauri <- data.frame(gene = rownames(Cab_Cauri))
write_tsv(myCab_Cauri, "Cab_Cauri.txt")

Cab_Mala <- get_intersect_members(data3, "C.albicans", "Mala") 
myCab_Mala <- data.frame(gene = rownames(Cab_Mala))
write_tsv(myCab_Mala, "Cab_Mala.txt")

Cauri_Mala <- get_intersect_members(data3, "C.auri", "Mala") 
myCauri_Mala <- data.frame(gene = rownames(Cauri_Mala))
write_tsv(myCauri_Mala, "Cauri_Mala.txt")

Total <- get_intersect_members(data3, "C.albicans", "C.auri", "Mala") 
myTotal <- data.frame(gene = rownames(Total))
write_tsv(myTotal, "Total.txt")

# kogo --------------------------------------------------------------------

Goannotation <- read_tsv("eggNOG/parsed.emapper.annotations/GOannotation.tsv")
KOannotation <- read_tsv("eggNOG/parsed.emapper.annotations/KOannotation.tsv")
GOinfo <- read_tsv("eggNOG/go.tb")

Goannotation2 <- left_join(
  Goannotation,
  GOinfo
)

### Cab
for (dat in c("Cab_unique.txt", "Cauri_unique.txt", "Mala_unique.txt", "Cab_Cauri.txt","Cab_Mala.txt", "Cauri_Mala.txt",  "Total.txt")) {
  
  tmp <- read_tsv(dat)
  plot.data.Cab <- inner_join(
    Goannotation2, tmp
  ) %>% 
    filter(!is.na(level)) %>% 
    group_by(
      level, Description
    ) %>% 
    summarise(
      counts = n()
    ) %>% 
    ungroup() %>% 
    arrange(desc(counts)) %>% 
    slice_head(n = 20)
  plot.data.Cab$Description <- factor(
    plot.data.Cab$Description,
    levels = rev(plot.data.Cab$Description)
  )
  
  ggplot(plot.data.Cab,
         aes(reorder(Description, counts), counts)) +
    geom_bar(
      aes(
        fill = level,
        color = level
      ),
      stat = "identity"
    ) +
    coord_flip() +
    labs(
      title = dat,
      x = ""
    ) +
    theme_classic(
      base_size = 12
    ) -> p
  ggsave(paste0(dat, ".pdf"),
         width = 8, height = 6)
  ggsave(paste0(dat, ".tiff"),
         width = 8, height = 6)
}


for (dat in c("Cab_unique.txt", "Cauri_unique.txt", "Mala_unique.txt", "Cab_Cauri.txt","Cab_Mala.txt", "Cauri_Mala.txt",  "Total.txt")) {
# dat <- "Cab_unique.txt"
tmp <- read_tsv(dat)
plot.data.Cab <- inner_join(
  KOannotation, tmp
) %>% 
  group_by(
    description
  ) %>% 
  summarise(
    counts = n()
  ) %>% 
  ungroup() %>% 
  arrange(desc(counts))  %>% 
  slice_head(n = 20)


ggplot(plot.data.Cab,
       aes(reorder(description, counts), counts)) +
  geom_bar(
    # aes(
    #   fill = level,
    #   color = level
    # ),
    stat = "identity"
  ) +
  coord_flip() +
  labs(
    title = dat,
    x = ""
  ) +
  theme_classic(
    base_size = 12
  ) -> p
ggsave(paste0(dat, ".KO.pdf"),
       width = 8, height = 6)
ggsave(paste0(dat, ".KO.tiff"),
       width = 8, height = 6)
}
