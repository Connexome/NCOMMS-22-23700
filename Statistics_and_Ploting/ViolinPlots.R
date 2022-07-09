library(ggplot2)
library(ggpubr)
library(rstatix)
library(tidyverse)


data <- read.csv('DatenKohorten.csv')


svg('ViolinBMI.svg')
my_comparisons <- list( c('Cachexia', 'no Chachexia'))
ggplot(data, aes(x=Cachexia,y=BMI, fill=Cachexia))+
  geom_violin(trim=FALSE)+
  geom_boxplot(width=0.1,fill="white")+
  stat_compare_means(method = "t.test")+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1,size = 25))+
  theme(axis.text.y = element_text(size = 25),
        axis.title=element_text(size=25))+
  theme(axis.title.x = element_blank())+
  scale_fill_manual(values=c("#d11141", "#414487FF"))

dev.off()
  
svg('ViolinAge.svg')
ggplot(data, aes(x=Cachexia,y=Age, fill=Cachexia))+
  geom_violin(trim=FALSE)+
  geom_boxplot(width=0.1,fill="white")+
  stat_compare_means(method = "t.test")+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1,size = 25))+
  theme(axis.text.y = element_text(size = 25),
        axis.title=element_text(size=25))+
  theme(axis.title.x = element_blank())+
  scale_fill_manual(values=c("#d11141", "#414487FF"))

dev.off()

data_noC <- subset(data,Cachexia=='no Cachexia')
data_C <- subset(data,Cachexia=='Cachexia')

median(data_noC$BMI)
quantile(data_noC$BMI)

median(data_noC$Age)
quantile(data_noC$Age)

median(data_C$BMI)
quantile(data_C$BMI)

median(data_C$Age)
quantile(data_C$Age)

  t.test(data$BMI~data$Cachexia)
t.test(data$Age~data$Cachexia)
