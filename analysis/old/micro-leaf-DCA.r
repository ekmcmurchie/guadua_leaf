# DCA wrangles code

library(RRPP) #factorial manova uses this 
library(geomorph) #factorial manova uses this
library(tidyverse) #general tidyverse packages
library(ade4) #needed for PCOA
library(vegan) #needed for PCoA
library(pander) #for model comparison

guadualeaf <- read_csv("./data/tidy/guadualeaf.csv", col_names = TRUE, na = "x")
guadualeaf <- guadualeaf %>%
  select(-c(ad_stomata_freq, ad_papillae_overarch, ad_triangular_sub_cells,
            ad_dome_sub_cells, ad_parallel_sub_cells, ab_ridged_saddle_intercostal,
            ad_ridged_saddle_intercostal)) # remove columns with NA or no variation

df_guadualeaf = data.frame(guadualeaf, stringsAsFactors = TRUE) # create dataframe

df_guadualeaf <- data.frame(lapply(df_guadualeaf,as.factor)) # set columns as factors

### NOTE a correlation is not necessary to complete the PCoA.  What is required is a proper
 # distance measure for the data 

guadua_y_binary <- df_guadualeaf[,9:ncol(df_guadualeaf)] # reads in the binary data only 
guadua_y_binary_df <- data.frame(lapply(guadua_y_binary,function(x) as.numeric(levels(x))[x]))

guadua_y_dist <- dist.binary(guadua_y_binary_df, method = 2, diag = FALSE, upper = FALSE) # convert to distances using simple matching coefficient
guadua_y_dist_matrix <- as.matrix(guadua_y_dist) # create matrix using simple matching distances
PCoA <- cmdscale(guadua_y_dist_matrix, eig = TRUE, x.ret = TRUE, list. = TRUE) #from vegan - run PcoA


### Factorial model. Need your data matrix in the rdf
rdf <- rrpp.data.frame(morph.dist = guadua_y_dist, 
                       habit = df_guadualeaf$general_habit,
                       habitat = df_guadualeaf$general_habitat,
                       region = df_guadualeaf$region)
fit <- lm.rrpp(morph.dist ~ habit + habitat + region, data = rdf)

anova(fit)

reveal.model.designs(fit) 

null <- lm.rrpp(morph.dist ~ region, data = rdf)

PW <- pairwise(fit,fit.null = null,groups = rdf$region)

summary(PW,test.type = "dist") 

