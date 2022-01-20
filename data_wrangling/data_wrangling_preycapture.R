#EEB698: Data Wrangling preycapture

source("lib/R_functions/ipak_fx.R") #load ipak function
ipak(c("tidyverse", "lubridate", "readxl"))

##### Step 1 - Load data.  ############

preycap <- read_excel("data/raw/Prey_Capture_Final_Do_Not_Touch.xlsx", sheet = 1, col_names = T)

##### Step 2: Explore data ##########

str(preycap)
summary(preycap)
names(preycap)

##### Step 3: Change class of columns ####

# 5.2: Change class of multiple columns at a time
factor_cols <- c("island","site", "web")
numeric_cols <- c("totalprey")
preycap[factor_cols] <- lapply(preycap[factor_cols], as.factor)
preycap[numeric_cols] <- lapply(preycap[numeric_cols], as.numeric)
str(preycap)

##### Step 4: Reshape database (i.e. if wide, change to long; if long, change to wide)  ########################

preycap_long <- gather(data = preycap, key = "observation", value = "numprey", obs1, obs2, obs3, obs4, obs5, obs6, obs7,obs8)

preycap_long <- filter(preycap_long, numprey!="NA")

##### Step 5: Fix cells within columns (e.g. naming, capitalization) #####
#7.1: change levels within a column so they are lower case.
levels(preycap_long$island)
preycap_long$island <- as.factor(tolower(preycap_long$island))
preycap_long$site<-as.factor(tolower(preycap_long$site))
levels(preycap_long$island)
levels(preycap_long$site)

#delete a certain # of characters from the values within a vector
#this is saying "keep the 1st-4th elements (start at 1, stop at 4)".
levels(preycap_long$site)
preycap_long$site<-as.factor(substr(preycap_long$site, 1, 4))
levels(preycap_long$site)

##### Step 6: write csv file with tidy dataset into tidy folder #########

#create tidy database for analysis
write.csv(preycap_long, "data/tidy/preycap_tidy.csv", row.names=F)
