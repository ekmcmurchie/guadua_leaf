#Comparisons of Guadua by habitat
library(readxl)
library(RRPP)
library(tidyverse)

mydat <- read_xlsx("../data/raw/Guadua_palea_macro.xlsx")

view(mydat)

species <- as.factor(mydat$Species)
hab <- as.factor(mydat$Habitat)
habit <- as.factor(mydat$Habit)
region <- as.factor(mydat$Region)
ind <- as.factor(mydat$Specimen)
morph <- as.matrix(mydat[,c(19:23)]) #NOTE: excludes lemma length

view(morph)
view(hab)



# Ordination: 
# PCA for habitat

palette(c("#7b3294", "#1b7837", "#f1a340"))

pca <- ordinate(morph)
plot(pca, pch=21, bg = hab)
  legend("topright",pch=22, pt.bg = unique(hab), legend = levels(hab))
pca$rot  #NOTE: PC1 is almost all 'Palea_length'.  Probably need to size-s


# PCA for habit (out of curiosity)
pca <- ordinate(morph)
plot(pca, pch=21, bg = habit)
legend("topright",pch=22, pt.bg = unique(habit), legend = levels(habit))
pca$rot  


palette(c("#7b3294", "#1b7837", "#f1a340", "#af8dc3"))

# PCA for region (out of curiosity)
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

# mixed-model for habit
fit2habit <- lm.rrpp(morph ~ habit/ind, data = rdf, SS.type = "III")
anova(fit2habit,error = c("habit:ind", "Residuals"))

# mixed-model for region
fit2region <- lm.rrpp(morph ~ region/ind, data = rdf, SS.type = "III")
anova(fit2region,error = c("region:ind", "Residuals"))


###### ADDED BY DCA

# Pairwise comparison example

reveal.model.designs(fit2region)

null <- lm.rrpp(morph ~ region:ind)

PW <- pairwise(fit2region,fit.null = null,groups = region)

summary(PW,test.type = "dist") #simple comparison of groups
