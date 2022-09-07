# load appropriate libraries, installing if needed
#library(knitr)
#library(formatR)
#library(RRPP) #factorial manova uses this 
#library(geomorph) #factorial manova uses this
library(tidyverse) #includes ggplot2 needed for graphics
library(readxl) #to read in doc
library(ade4) #needed for PcoA
library(vegan) #needed for PCoA
#library(pander) not needed as this is for model comparison only
#library(readr) not needed this is for model comparison only
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

#ggcorrplot alows us to view correlation table with colors indicating correlation values

ggcorrplot(correlation_y, hc.order = TRUE, lab = TRUE)

corrs <- ggcorrplot(correlation_y, hc.order = TRUE, lab = TRUE)

ggsave("./graphics/corrplot.pdf", plot = corrs, width = 16, height = 14, units = "in", dpi = 300)

corrs2 <- ggcorrplot(correlation_y, hc.order = TRUE, lab = TRUE, type = "upper")

ggsave("./graphics/corrplot2.pdf", plot = corrs2, width = 16, height = 14, units = "in", dpi = 300)


### PCoA We get the distance matrix for our binary data using simple matching
# coefficient. Then we are able to calculate the PCoA on the distance matrix
# to visualize the pairwise distances between individual Guadua specimen
# micromorphology.

# Distance matrix for binary is simple matching coefficient
Y.dist <- dist.binary(Y, method = 2, diag = FALSE, upper = FALSE)
Y.dist.matrix <- as.matrix(Y.dist)
PCoA <- cmdscale(Y.dist.matrix, eig = TRUE, x.ret = TRUE, list. = TRUE)   #from vegan


# PCoA grouped by habit (3 categories)

group.colors <- c("Big_erect" = "#7b3294", "Leaning_climbing" = "#1b7837",
                  "Small_arching" = "#f1a340")

nice_df <- PCoA$points %>% 
  data.frame
nice_df$habit <- df$habit
nice_df %>% 
  ggplot(aes(X1, X2)) +
  geom_point(aes(color = habit), size = 2) +
  scale_color_manual(name = "Habit", breaks = c("Big_erect", "Leaning_climbing", "Small_arching"),
                     labels = c("Big erect", "Leaning/climbing", "Small arching"),
                     values = group.colors) + 
  theme_minimal() +
  theme(
    panel.border = element_rect(size = 2, color = "black", fill = NA)
  ) + 
  labs(
    color = "Habit", 
    x = "Axis 1",
    y = "Axis 2"
  )

#saving 3 habit PCoA

nice_df <- PCoA$points %>% 
  data.frame
nice_df$habit <- df$habit
habitpcoa <- nice_df %>% 
  ggplot(aes(X1, X2)) +
  geom_point(aes(color = habit), size = 2) +
  scale_color_manual(name = "Habit", breaks = c("Big_erect", "Leaning_climbing", "Small_arching"),
                     labels = c("Big erect", "Leaning/climbing", "Small arching"),
                     values = group.colors) + 
  theme_minimal() +
  theme(
    panel.border = element_rect(size = 2, color = "black", fill = NA)
  ) + 
  labs(
    color = "Habit", 
    x = "Axis 1",
    y = "Axis 2"
  )

ggsave("./graphics/habits3lp.pdf", plot = habitpcoa, width = 6, height = 4, units = "in", dpi = 300)

# PCoA grouped by habit (2 categories)

group.colors2 <- c("erect_or_climbing" = "#7b3294","small_arching" = "#f1a340")

nice_df <- PCoA$points %>% 
  data.frame
nice_df$general_habit <- df$general_habit
nice_df %>% 
  ggplot(aes(X1, X2)) +
  geom_point(aes(color = general_habit), size = 2) +
  scale_color_manual(name = "Habit", breaks = c("erect_or_climbing", "small_arching"),
                     labels = c("Erect or climbing", "Small arching"),
                     values = group.colors2) + 
  theme_minimal() +
  theme(
    panel.border = element_rect(size = 2, color = "black", fill = NA)
  ) + 
  labs(
    color = "Habit", 
    x = "Axis 1",
    y = "Axis 2"
  )

# Saving 2 habit PCoA

group.colors2 <- c("erect_or_climbing" = "#7b3294","small_arching" = "#f1a340")

nice_df <- PCoA$points %>% 
  data.frame
nice_df$general_habit <- df$general_habit
habits2pcoa <- nice_df %>% 
  ggplot(aes(X1, X2)) +
  geom_point(aes(color = general_habit), size = 2) +
  scale_color_manual(name = "Habit", breaks = c("erect_or_climbing", "small_arching"),
                     labels = c("Erect or climbing", "Small arching"),
                     values = group.colors2) + 
  theme_minimal() +
  theme(
    panel.border = element_rect(size = 2, color = "black", fill = NA)
  ) + 
  labs(
    color = "Habit", 
    x = "Axis 1",
    y = "Axis 2"
  )

ggsave("./graphics/habits2.pdf", plot = habits2pcoa, width = 6, height = 4, units = "in", dpi = 300)


# PCoA grouped by habitat

group.colors3 <- c("Forest" = "#7b3294", "River" = "#1b7837",
                  "Savanna" = "#f1a340")

nice_df <- PCoA$points %>% 
  data.frame
nice_df$habitat <- df$habitat
nice_df %>% 
  ggplot(aes(X1, X2)) +
  geom_point(aes(color = habitat), size = 2) +
  scale_color_manual(name = "Habitat", breaks = c("Forest", "River", "Savanna"),
                     labels = c("Forest", "River", "Savanna"),
                     values = group.colors3) + 
  theme_minimal() +
  theme(
    panel.border = element_rect(size = 2, color = "black", fill = NA)
  ) + 
  labs(
    color = "Habitat", 
    x = "Axis 1",
    y = "Axis 2"
  )

# saving habitat PCoA

group.colors3 <- c("Forest" = "#7b3294", "River" = "#1b7837",
                   "Savanna" = "#f1a340")

nice_df <- PCoA$points %>% 
  data.frame
nice_df$habitat <- df$habitat
Habitatspcoa <- nice_df %>% 
  ggplot(aes(X1, X2)) +
  geom_point(aes(color = habitat), size = 2) +
  scale_color_manual(name = "Habitat", breaks = c("Forest", "River", "Savanna"),
                     labels = c("Forest", "River", "Savanna"),
                     values = group.colors3) + 
  theme_minimal() +
  theme(
    panel.border = element_rect(size = 2, color = "black", fill = NA)
  ) + 
  labs(
    color = "Habitat", 
    x = "Axis 1",
    y = "Axis 2"
  )

ggsave("habitatlp.pdf", plot = Habitatspcoa, width = 6, height = 4, units = "in", dpi = 300)

# PCoA grouped by habitat (2 categories)

group.colors4 <- c("general_forest" = "#7b3294","savanna" = "#f1a340")

nice_df <- PCoA$points %>% 
  data.frame
nice_df$general_habitat <- df$general_habitat
nice_df %>% 
  ggplot(aes(X1, X2)) +
  geom_point(aes(color = general_habitat), size = 2) +
  scale_color_manual(name = "Habitat", breaks = c("general_forest", "savanna"),
                     labels = c("Forest or River", "Savanna"),
                     values = group.colors4) + 
  theme_minimal() +
  theme(
    panel.border = element_rect(size = 2, color = "black", fill = NA)
  ) + 
  labs(
    color = "Habitat", 
    x = "Axis 1",
    y = "Axis 2"
  )

#saving 2 group PcoA

group.colors4 <- c("general_forest" = "#7b3294","savanna" = "#f1a340")

nice_df <- PCoA$points %>% 
  data.frame
nice_df$general_habitat <- df$general_habitat
habitats2pcoa <- nice_df %>% 
  ggplot(aes(X1, X2)) +
  geom_point(aes(color = general_habitat), size = 2) +
  scale_color_manual(name = "Habitat", breaks = c("general_forest", "savanna"),
                     labels = c("Forest or River", "Savanna"),
                     values = group.colors4) + 
  theme_minimal() +
  theme(
    panel.border = element_rect(size = 2, color = "black", fill = NA)
  ) + 
  labs(
    color = "Habitat", 
    x = "Axis 1",
    y = "Axis 2"
  )


ggsave("./graphics/habitat2.pdf", plot = habitats2pcoa, width = 6, height = 4, units = "in", dpi = 300)

# PCoA grouped by region

group.colors5 <- c("Andes" = "#7b3294", "Central_America" = "#1b7837",
                   "Eastern_South_America" = "#af8dc3", "Mexico" = "#f1a340")

nice_df <- PCoA$points %>% 
  data.frame
nice_df$region <- df$region
nice_df %>% 
  ggplot(aes(X1, X2)) +
  geom_point(aes(color = region), size = 2) +
  scale_color_manual(name = "Region", breaks = c("Andes", "Central_America",
                                                 "Eastern_South_America", "Mexico"),
                     labels = c("Andes", "Central America", "Eastern South America", "Mexico"),
                     values = group.colors5) + 
  theme_minimal() +
  theme(
    panel.border = element_rect(size = 2, color = "black", fill = NA)
  ) + 
  labs(
    color = "Region", 
    x = "Axis 1",
    y = "Axis 2"
  )

# saving region PcoA


group.colors5 <- c("Andes" = "#7b3294", "Central_America" = "#1b7837",
                   "Eastern_South_America" = "#af8dc3", "Mexico" = "#f1a340")

nice_df <- PCoA$points %>% 
  data.frame
nice_df$region <- df$region
regionpcoa <- nice_df %>% 
  ggplot(aes(X1, X2)) +
  geom_point(aes(color = region), size = 2) +
  scale_color_manual(name = "Region", breaks = c("Andes", "Central_America",
                                                 "Eastern_South_America", "Mexico"),
                     labels = c("Andes", "Central America", "Eastern South America", "Mexico"),
                     values = group.colors5) + 
  theme_minimal() +
  theme(
    panel.border = element_rect(size = 2, color = "black", fill = NA)
  ) + 
  labs(
    color = "Region", 
    x = "Axis 1",
    y = "Axis 2"
  )

ggsave("./graphics/regionlp.pdf", plot = regionpcoa, width = 6, height = 4, units = "in", dpi = 300)

### Scree Plot From the PCoA we are able to obtain eigenvalues and then plot them
#to show the percent variation explained along each PCoA axis. As seen in the plot below,
#PCoA axis 1 is responsible for the majority of variation in the PCoA, followed by a steep
#drop in variation. By the 20th axis, variation is arguably negligible."Elbow is at approximately
#the fourth or fifth principal coordinate axis.

eig_df <- data.frame( x_values = c(1:length(PCoA$eig)) , eig_value = c(PCoA$eig))
scree <- ggplot(data = eig_df, aes(x = x_values, y = eig_value)) +
  geom_line() +
  geom_point() + 
  theme_minimal() +
  theme(
    panel.border = element_rect(size = 2, color = "black", fill = NA)
  ) + 
  labs(
    x = "Coordinate number",
    y = "Eigenvalue"
  )

scree

#saving scree plot

eig_df <- data.frame( x_values = c(1:length(PCoA$eig)) , eig_value = c(PCoA$eig))
scree <- ggplot(data = eig_df, aes(x = x_values, y = eig_value)) +
  geom_line() +
  geom_point() + 
  theme_minimal() +
  theme(
    panel.border = element_rect(size = 2, color = "black", fill = NA)
  ) + 
  labs(
    x = "Coordinate number",
    y = "Eigenvalue"
  )

ggsave("./graphics/scree.pdf", plot = scree, width = 6, height = 4, units = "in", dpi = 300)

