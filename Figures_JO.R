## some libraries
library(ggplot2)
library(dplyr)
library(survival)
library(scales)

## import data set
dd <- readRDS("Dataset/extinction.week.Rdata")

## glimpse at data set
str(dd)
summary(dd)

## add body mass to data set
bodysize <- read.csv("Dataset/sizes.csv")
dd <- bodysize %>%
  select(species = spp.names2, mass) %>%
  right_join(dd, by = "species")

## visualize how long species persisted stratified by experimental conditions
dd$condition <- paste0("Temperature: ", dd$temp,
                       "°C x Energy: ", dd$energy)

doged_plot = ggplot(data = dd, aes(x = week.persist, fill = condition)) +
  geom_bar(aes( x = week.persist),
               position=position_dodge2(width = 0.9, preserve = "single")) +
  geom_area(stat = "count",alpha = 0.3,
                aes(y = ..count..,
                    x = week.persist,
                group = condition,
                fill = condition),
                position=position_dodge2(width = 0.9, preserve = "single")) +
  facet_wrap(~ species, ncol = 4) +
  #xlim(-0.5,8.5) +
  labs(x = "Weeks persisted", fill = "") +
  guides(fill = guide_legend(ncol = 2)) +
  theme_bw() +
  theme(legend.position = "top") 
  
ggsave("Figures/vis_JO.pdf", doged_plot)

