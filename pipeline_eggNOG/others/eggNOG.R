library(tidyverse)

data <- read_tsv("JPN.eggnog.related.abundance.txt")
data[2:ncol(data)] <- t(t(data[2:ncol(data)])/rowSums(t(data[2:ncol(data)])))

data <- data[1:9]
colnames(data)[2:9] <- paste0("sample", 1:8)

data$ID <- str_replace(data$ID,
                       "([A-Z])__",
                       "\\[\\1\\] ")
data$ID[which(data$ID == "Function_unknown")] <- c("[S] Function_unknown")

data2 <- data %>% 
  pivot_longer(
    starts_with("sample"), 
    names_to = "Sample",
    values_to = "abundance"
  )

p <- ggplot(data2, aes(Sample, abundance, group = ID)) +
  geom_bar(
    aes(fill = ID),
    stat = "identity",
    position = "stack"
  ) +
  labs(
    title = "eggNOG Annotation Graph",
    x = "Sample ID",
    y = "Percent(%)"
  ) +
  scale_y_continuous(
    breaks = c(0, 0.25, 0.5, 0.75, 1),
    labels = c(0, 25, 50, 75, 100)
  ) +
  # scale_fill_brewer(
  #   # type = "qual",
  #   palette = "OrRd"
  # ) +
  theme_classic(base_size = 15) +
  theme(
    axis.text.x.bottom = element_text(
      angle = 60,
      hjust = 1,
      vjust = 1
    ),
    legend.title = element_blank(),
    legend.text = element_text(size = 12)
  ) +
  guides(fill = guide_legend(ncol = 1, byrow = TRUE))
ggsave("eggNOG.png", p,
       width = 12, height = 10)
