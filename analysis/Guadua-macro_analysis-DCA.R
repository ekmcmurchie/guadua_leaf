## Analysis to look at regional differences.
  # problem: multipe measurements per individual, which are not independent 
  # each individual is obviously found within a region, so one could envision this as 'nested'.
  # is that the best way? 

#Comparisons of Guadua by habitat
library(readxl)
library(RRPP)
library(tidyverse)

mydat <- read_xlsx("./data/raw/Guadua_palea_macro.xlsx")

species <- as.factor(mydat$Species)
region <- as.factor(mydat$Region)
ind <- as.factor(mydat$Specimen)
hab <- as.factor(mydat$Habit)
morph <- as.matrix(mydat[,c(19:23)]) #NOTE: excludes lemma length

rdf <- rrpp.data.frame(morph=morph,species=species, hab=hab, ind=ind)

### 1: treat as mixed model, with individual nested within region
# mixed-model for region
fit2region <- lm.rrpp(morph ~ region/ind, data = rdf, SS.type = "III")
anova(fit2region,error = c("region:ind", "Residuals"))
    reveal.model.designs(fit2region)
null <- lm.rrpp(morph ~ region:ind)
PW <- pairwise(fit2region,fit.null = null,groups = region)
summary(PW,test.type = "dist") #simple comparison of groups

summary(PW,test.type = "var") #there are hints that disparity may differ among regions



### 2: use means per species: implies little difference among regions
morph.mn <- pairwise(lm.rrpp(morph~ind, iter=0), groups = rdf$ind)$LS.means[[1]]
region.mn <- as.factor(by(region,ind,unique))
fit.mn <- lm.rrpp(morph.mn~region.mn)
anova(fit.mn)

