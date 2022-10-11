#Comparisons of Guadua by habitat
library(readxl)
library(RRPP)
library(tidyverse)

mydat <- read_xlsx("data/raw/Guadua_palea_macro.xlsx")

view(mydat)

species <- as.factor(mydat$Species)
hab <- as.factor(mydat$Habitat)
habit <- as.factor(mydat$Habit)
region <- as.factor(mydat$Region)
ind <- as.factor(mydat$Specimen)
morph <- as.matrix(mydat[,c(18:23)]) #NOTE: not sure which you want, so I grabbed them all

view(morph)


# Ordination: 
pca <- ordinate(morph)
plot(pca, pch=21, bg = hab)
  legend("topright",pch=22, pt.bg = unique(hab), legend = levels(hab))
pca$rot  #NOTE: PC1 is almost all 'Palea_length'.  Probably need to size-s


pca <- ordinate(morph)
plot(pca, pch=21, bg = habit)
legend("topright",pch=22, pt.bg = unique(habit), legend = levels(habit))
pca$rot  

pca <- ordinate(morph)
plot(pca, pch=21, bg = region)
legend("topright",pch=22, pt.bg = unique(region), legend = levels(region))
pca$rot


### PERMUTATION-BASED MANOVA

#1: naive approach
rdf <- rrpp.data.frame(morph=morph,species=species, hab=hab, ind=ind)
fit1 <- lm.rrpp(morph ~ hab, data = rdf)
anova(fit1)

#NOTE: individual explains 86% of all variation! Must account for it
anova(lm.rrpp(morph~ind))

#2: mixed-model to account for individual
fit2 <- lm.rrpp(morph ~ hab/ind, data = rdf, SS.type = "III")
anova(fit2,error = c("hab:ind", "Residuals"))


