library(vegan)
library(ggplot2)


#Load Data: following Dan Knights youtube tutorial, samples are in rows and OTU/taxa are in columns. Same style as mothur output.
species <- read.csv("Species_040122_2_kb.csv", header=TRUE, sep=";", row.names=1)
meta <- read.csv("Meta_2022-04.csv", header=TRUE, sep=";", row.names=1)


#Alpha-diversity
##Shannon-diversity typically a normally distributed metric (might be checked by Shapiro Wilk normality test before)
shannon_species <- diversity(species, index="shannon", MARGIN=1, base=exp(1))
write.csv(shannon_species, "species_shannon_2022_kb.csv")

##Shapiro Test for normality and plotting result 
shapiro.test(shannon_species)
hist(shannon_species, main="Shannon diversity_species", xlab="", breaks=10)

##Anova as statistic test when 3 or more groups are compared, when data is roughly normal, perform for meta$Cancer.Type|Cachectic.State|Antibiotic.Exposure
aov_shannon_species <- aov(shannon_species ~ meta$Cachectic.State, data=meta)
summary(aov_shannon_species)

##plot alpha-diversity
par(mfrow=c(1,1))
boxplot(shannon_species ~ meta$Cachectic.State, data=meta, ylab="Shannon's diversity", xlab="")

##plot alpha-diversity_tiff
tiff("Shannon_CancerType.tiff",units="cm", width=15, res=400, pointsize=12)
par(mfrow=c(1,1))
boxplot(shannon_species ~ meta$Cachectic.State, data=meta, ylab="Shannon's diversity", xlab="")
dev.off()



#Beta-diversity
##Bray-Curtis algorithm
BC.dist_s=vegdist(species, distance="bray")

##PERMANOVA, result output is written into console
adonis(BC.dist_s ~ Cancer.Type, data=meta, permutations=1000)
adonis(BC.dist_s ~ Cachectic.State, data=meta, permutations=1000)
adonis(BC.dist_s ~ Antibiotic.Exposure, data=meta, permutations=1000)

##PCoA Plots, Beta-diversity visualization 
### eigenvalues
pcao.bray.eig <- cmdscale(BC.dist_s, k = 2, eig = TRUE)
explainvar1 <- round(pcao.bray.eig$eig[1]/sum(pcao.bray.eig$eig), 2)*100
explainvar2 <- round(pcao.bray.eig$eig[2]/sum(pcao.bray.eig$eig), 2)*100

###calculate bray-curtis-distance and coordinates
BC.dist_s <- cmdscale(BC.dist_s, k = 2)
colnames(BC.dist_s) <- c("PC1", "PC2")
BC.dist_s <- as.data.frame(BC.dist_s)

###merge metadata with coordinates
bc.pcoa <- merge(meta, BC.dist_s, by = 0)

###PLOT, perform for meta$Cancer.Type|Cachectic.State|Antibiotic.Exposure
Cachexiacol <- c("Cachexia" = "red","No Cachexia" = "green")
Antibiosiscol <- c("No Antibiotics" = "blue","Antibiotics" = "orange")
Cancercol <- c("Pancreatic Cancer" = "blue","Gastric Cancer" = "orange", "Peritoneal Cancer" = "purple", "Colorectal Cancer" = "red", "Liver Cancer" = "green")

####PLOT label ID 
p <- ggplot(bc.pcoa, aes(PC1, PC2)) +
  geom_text(aes(label=Patient_NR.1), color="black", vjust=-1.2, hjust=1.2, size=3, check_overlap = FALSE) +
  ggtitle("Beta-Diversity", subtitle = "Bray-Curtis-Dissimilarity_species") +
  xlab(paste("PCoA 1 (" ,explainvar1, "%)", sep = "")) +
  ylab (paste("PCoA 2 (", explainvar2, "%)", sep = ""))
p + theme_bw()

####PLOT label meta groups
p <- ggplot(bc.pcoa, aes(PC1, PC2, color=Cachectic.State)) + geom_point(size=3) + labs(color = "Cachectic State") + scale_color_manual(values = Cachexiacol) + 
  ggtitle("Beta-Diversity", subtitle = "Bray-Curtis-Dissimilarity_species") +
  xlab(paste("PCoA 1 (" ,explainvar1, "%)", sep = "")) +
  ylab (paste("PCoA 2 (", explainvar2, "%)", sep = ""))
p
p + theme_bw()

###PLOT tiff, label meta groups
tiff("PCoA_s_CachecticState.tiff",units="px", width=3000, height=2000, res=400)
p <- ggplot(bc.pcoa, aes(PC1, PC2, color=Cachectic.State)) + geom_point(size=3) + labs(color = "Cachectic State") + scale_color_manual(values = Cachexiacol) + 
  ggtitle("Beta-Diversity", subtitle = "Bray-Curtis-Dissimilarity_species") +
  xlab(paste("PCoA 1 (" ,explainvar1, "%)", sep = "")) +
  ylab (paste("PCoA 2 (", explainvar2, "%)", sep = ""))
p
p + theme_bw()
dev.off()