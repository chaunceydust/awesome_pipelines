#!/usr/bin/env Rscript

library(tidyverse)
library(ComplexUpset)
#-------------------------------------------------------------------------------------------------------------------------------
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

#-------------------------------------------------------------------------------------------------------------------------------


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

set_size(8, 6)

data6 <- fromList(data5)
upset(
  data6, colnames(data4)[c(5, 13, 15, 38, 43, 46)], 
  name='', 
  width_ratio=0.1,
  # group_by='sets',
  sort_intersections_by=c('degree', 'cardinality')
)
ggsave("upset.pdf",
       width = 23, height = 6)
ggsave("upset.png",
       width = 23, height = 6)
ggsave("upset.tiff",
       width = 23, height = 6)
