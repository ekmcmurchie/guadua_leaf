# load appropriate libraries, installing if needed
#library(knitr)
#library(formatR)
library(RRPP) #factorial manova uses this 
library(geomorph) #factorial manova uses this
library(tidyverse) #includes ggplot2 needed for graphics
library(readxl) #to read in doc
library(ade4) #needed for PcoA
library(vegan) #needed for PCoA
library(pander) #for model comparison
library(readr) #for model comparison
library(ggcorrplot) #for correlation tables

# Read in data as dataframe
guadualp <- read_csv("data/raw/guadua_lemmas_paleas_updated.csv", col_names = TRUE, na = "x")
View(guadualp)

# drop columns with NA and no variation
guadualp <- guadualp %>%
  select(-c(recorder, notes_lemma, notes_palea, lemma_stomata, palea_sulcus_prickle, palea_sulcus_macro, palea_stomata_freq, palea_subsidiary_triangular, palea_subsidiary_dome, palea_subsidiary_parallel)) 
view(guadualp)

df = data.frame(guadualp, stringsAsFactors = TRUE)

# Set columns to factors
df <- data.frame(lapply(df,as.factor))

view(df)

## Analysis

### Correlation
Y <- df[,9:ncol(df)] # reads in the binary data only 
Y <- data.frame(lapply(Y,function(x) as.numeric(levels(x))[x]))
correlation_y <- data.frame(cor(Y)) #calculated the correlation of the Y values

view(correlation_y) #viewing basic correlation table

### PCoA We get the distance matrix for our binary data using simple matching
# coefficient. Then we are able to calculate the PCoA on the distance matrix
# to visualize the pairwise distances between individual Guadua specimen
# micromorphology.

# Distance matrix for binary is simple matching coefficient
Y.dist <- dist.binary(Y, method = 2, diag = FALSE, upper = FALSE)
Y.dist.matrix <- as.matrix(Y.dist)
PCoA <- cmdscale(Y.dist.matrix, eig = TRUE, x.ret = TRUE, list. = TRUE)   #from vegan


# Factorial MANOVA via RRPP excluding region - 2 groups for each
mydat <- rrpp.data.frame("Y" = Y,
                         "Habit" = as.factor(df$general_habit),
                         "Habitat" = as.factor(df$general_habitat)) 
model1.rrpp <- lm.rrpp(Y.dist.matrix ~ mydat$Habit + mydat$Habitat, 
                       print.progress = FALSE)
anova(model1.rrpp)

# Factorial MANOVA via RRPP excluding region - 3 groups for each 
mydat2 <- rrpp.data.frame("Y" = Y,
                          "Habit" = as.factor(df$habit),
                          "Habitat" = as.factor(df$habitat)) 
model2.rrpp <- lm.rrpp(Y.dist.matrix ~ mydat2$Habit + mydat2$Habitat, 
                       print.progress = FALSE)
anova(model2.rrpp)


#Factorial MANOVA via RRPP with region (two groups for habit and habitat)
mydat3 <- rrpp.data.frame("Y" = Y,
                          "Habit" = as.factor(df$general_habit),
                          "Habitat" = as.factor(df$general_habitat),
                          "Region" = as.factor(df$region)) 
model3.rrpp <- lm.rrpp(Y.dist.matrix ~ mydat3$Habit + mydat3$Habitat + mydat3$Region,  
                       print.progress = FALSE)
anova(model3.rrpp)


### MODEL COMPARISON USING LIKELIHOOD RATIO TEST (LTR)

#### Setup

Y.Habit <- lm.rrpp(Y.dist.matrix ~ mydat3$Habit, 
                   print.progress = FALSE)
Y.Habitat <- lm.rrpp(Y.dist.matrix ~ mydat3$Habitat, 
                     print.progress = FALSE)
Y.Region <- lm.rrpp(Y.dist.matrix ~ mydat3$Region, 
                    print.progress = FALSE)
Y.Habit.Region <- lm.rrpp(Y.dist.matrix ~ mydat3$Habit + mydat3$Region, 
                          print.progress = FALSE)
Y.Habitat.Region <- lm.rrpp(Y.dist.matrix ~ mydat3$Habitat + mydat3$Region,
                            print.progress = FALSE)
Y.Habit.Habitat <- lm.rrpp(Y.dist.matrix ~ mydat3$Habit + mydat3$Habitat,
                           print.progress = FALSE)
Y.full <- lm.rrpp(Y.dist.matrix ~ mydat3$Habit + mydat3$Habitat + mydat3$Region, 
                  print.progress = FALSE)

#### RRPP MODEL COMPARISON For our model comparison, we used model.comparison() from the RRPP package using the log likelihood method. From this, we are able to determine that the Y.group2 model is the best fit based on it has the highest log-likelihood score and the lowest AIC score. 
anova(Y.full)

#?RRPP::model.comparison()
modelComp1 <- model.comparison(Y.full, 
                               Y.Habit.Habitat,
                               Y.Habitat.Region, 
                               Y.Habit.Region, 
                               Y.Habitat, 
                               Y.Habit, 
                               Y.Region,
                               type = "logLik", tol = 0.01)
modelComp1.summ <- as.data.frame(summary(modelComp1))

pandoc.table(modelComp1.summ,
             style = "grid", 
             plain.ascii = TRUE)

# log likelihood is highest for the model including both habit and habitat but excluding region.