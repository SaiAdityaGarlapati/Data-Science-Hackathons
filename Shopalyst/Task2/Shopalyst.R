library(readxl)
library(data.table)
library(dplyr)
library(ggplot2)
library(reshape2)
library(plotly)
library(tidyr)
library(gridExtra)
library(caret)
library(forecast)

adcamp = read.csv('C:/Users/Aditya/Documents/Hackathons/Shopalyst/Task2/Campaign data.csv')

problem1 = adcamp %>% 
  group_by(Campaign.id) %>% 
  arrange(Campaign.id,Date)

View(adcamp)
View(problem1)

problem2 = adcamp %>% 
  group_by(Campaign.id) %>%
  summarize(count_days = n())%>%
  arrange(-count_days)

View(problem2)

anomaly_counts = adcamp %>% 
  group_by(Campaign.id,Date) %>%
  summarize(Max_click = max(Click.count))%>%
  arrange(-Max_click)
write.csv(anomaly_counts,'C:/Users/Aditya/Documents/Hackathons/Shopalyst/Task2/anomaly_counts.csv')




anomaly_counts_group = adcamp %>% 
  group_by(Campaign.id) %>%
  summarize(Max_click = max(Click.count))%>%
  arrange(-Max_click)
write.csv(anomaly_counts_group,'C:/Users/Aditya/Documents/Hackathons/Shopalyst/Task2/anomaly_counts_group.csv')


anomaly_counts_total = adcamp %>% 
  group_by(Campaign.id) %>%
  summarize(total_clicks = sum(Click.count))%>%
  arrange(-total_clicks)
write.csv(anomaly_counts_total,'C:/Users/Aditya/Documents/Hackathons/Shopalyst/Task2/anomaly_counts_total.csv')


filter_top10_campaigns = adcamp %>% 
  filter(Campaign.id %in% c(3001, 13003, 8801, 12502, 11801, 12501, 13001, 12505, 13002, 12503)) %>%
  group_by(Campaign.id,Date) %>%
  arrange(Campaign.id,Date)
write.csv(filter_top10_campaigns,'C:/Users/Aditya/Documents/Hackathons/Shopalyst/Task2/filter_top10_campaigns.csv')

write.csv(problem2,'C:/Users/Aditya/Documents/Hackathons/Shopalyst/Task2/problem2.csv')



filter_top1_campaign = adcamp %>% 
  filter(Campaign.id %in% c(3001)) %>%
  group_by(Campaign.id,Date) %>%
  arrange(Campaign.id,Date)

View(filter_top1_campaign)

install.packages("caret")
library(caret)
library(forecast)
## Warning: package 'caret' was built under R version 3.4.4
## Loading required package: lattice
## Loading required package: ggplot2
## Warning: package 'ggplot2' was built under R version 3.4.4
fit = nnetar(filter_top1_campaign$Click.count)

plot(forecast(fit,h=30))

