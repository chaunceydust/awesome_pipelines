library(tidyverse)

data <- xlsx::read.xlsx(
  "growthCurveData.xlsx",
  sheetIndex = 1
)

data2 <- data %>% 
  group_by(Strain, Time) %>% 
  summarise(
    myCount = n(),
    myMEAN = mean(OD600),
    mySD = sd(OD600),
    mySE = mySD / sqrt(myCount)
  ) %>% 
  ungroup()

data2$Time <- reorder(
  data2$Time,
  data2$Time
)


ggplot(data2, 
       aes(Time, myMEAN, group = Strain)) +
  geom_smooth(
    # color = "grey",
    alpha = .9
  ) +
  geom_errorbar(
    aes(x = Time, ymin = myMEAN - mySD, ymax = myMEAN + mySD),
    width = .6,
    size = 1
  ) +
  geom_point(
    size = 2.8
  ) +
  labs(
    x = "Time(h)",
    y = "OD600"
  ) +
  facet_wrap(.~Strain) +
  theme_bw(base_size = 12)
ggsave("growthCurve.pdf",
       width = 10, height = 6.5)
ggsave("growthCurve.png",
       width = 10, height = 6.5)
ggsave("growthCurve.tiff",
       width = 10, height = 6.5)
