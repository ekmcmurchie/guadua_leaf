#EEB698: Data Wrangling part 1
#Use this script to:
  #1) get your dataset loaded
  #2) explore data
  #3) fix column names
  #4) add/remove/split/combine columns
  #5) change class of columns
  #6) wrangle into the right shape (wide or long)
  #7) fix levels of cells within column names
  #8) deal with dates
  #9) print tidy database

#load libraries the classic way
library(tidyverse) #loads ggplot2, tibble, tidyr, readr, purrr, dplyr, stringr, forcats
library(readxl) #hadley wickham's package for reading in excel files. not in Tidyverse.
library(lubridate) #garett grolemund & hadley wickham's package for dates

#another way to check to see if you have libraries, and if not, install them.
source("lib/R_functions/ipak_fx.R") #load ipak function
ipak(c("tidyverse", "lubridate", "readxl"))

##### Step 1 - Load data.  ############
#There are multiple ways to do this, which impacts your imported dataframe. The key things that vary are how R interprets your blank values & NA's, and how R assigns a class to each column.

#option 1: if a csv or table, use read.csv or read.table.
transplant <- read.csv("data/raw/transplant_raw.csv", na.strings = c("", "NA", "na", " "))

#option 1b:
transplant_csvreadr <- read_csv("data/raw/transplant_raw.csv", na = c("", "NA", "na", " "))

#option 2: if excel, use readxl(). (note- rest of code works better with read.csv version)
transplant_excel <- read_excel("data/raw/transplant_raw.xlsx", sheet = 1, col_names = T, col_types = NULL) #col_types = null is default, and readxl guesses what each column is. by default, readxl converts blank cells to missing data. use na="yourcode" if you have a code you use for missing values.

##### Step 2: Explore data ##########

#compare dataframes from above to see what happens using read.csv, read_csv, and readxl
str(transplant) # str shows the structure of your dataset
str(transplant_csvreadr) #most variables are read in as characters
str(transplant_excel) # most variables are character class. dates are read in intelligently, though, although it added the current year because year was missing.

summary(transplant) #gives summary information, which can help you identify if any columns are in the wrong class or if there are data entry errors or a lot of NA's etc.
names(transplant) #show column names

##### Step 3: Standardize/clean inconsistencies in column names, class etc. ##########

# 3.1: Rename column headings
#Use the rename function in the dplyr package
#new name is on left, old name is on right.
transplant <- rename(transplant, island = Island, site = Site, web = Web.., native = Native, netting = Netting, startdate = Start.Date, enddate = End.Date, totaldays = Total.Days, spidpres = SpidPres, webpres = WebPres, WebSize = WebSize.cm.)

colnames(transplant) #note that I left one with uppercase letters

# 3.2: Fix upper case/lower case issues in column names
#change column names from upper to lowercase
colnames(transplant) <- tolower(colnames(transplant))
#names also works instead of colnames, as long as it's a dataframe
colnames(transplant)

##### Step 4: Add, remove, split, combine columns ############

#4.1: Add a column

#4.1.1: Add column directly
transplant$year<-2013 #this experiment happened in 2013. Added this in a new column

#4.1.2: Create a new column based on an operation from two other columns #note that the values in this column may not be right if the dates aren't correctly interpreted yet.
transplant$meaningless<-transplant$websize+transplant$year

#4.2: Remove a column
#use "Select" - to select columns from a dataframe to include or drop
transplant <- select(transplant, -totaldays, -meaningless)
colnames(transplant)

#4.3: Separate one column into two columns
transplant <- separate(transplant, col=web, into=c("web_a", "web_b"), sep="'", remove = F) #remove=F tells R to leave the original column
colnames(transplant)

#4.4: Combine two columns into one
transplant$startdate <- as.character(transplant$startdate)
transplant <- unite(transplant, startdate, c(startdate, year), sep="-", remove=F)
transplant$enddate <- as.character(transplant$enddate)
transplant <- unite(transplant, enddate, c(enddate, year), sep="-")

##### Step 5: Change class of columns ####
# 5.1: Change class of a single column
transplant$island <- as.factor(transplant$island)

# 5.2: Change class of multiple columns at a time
factor_cols <- c("island","site", "web", "web_a", "web_b", "native", "netting", "spidpres")
numeric_cols <- c("websize")
transplant[factor_cols] <- lapply(transplant[factor_cols], as.factor)
transplant[numeric_cols] <- lapply(transplant[numeric_cols], as.numeric)
str(transplant)

# 5.3: Deal with dates
#Change date format to standard yyyymmdd format
#helpful site: https://www.r-bloggers.com/date-formats-in-r/
class(transplant$startdate)

#Tell R startdate is a real date in a specific format
transplant$startdate<-as.Date(transplant$startdate, "%d-%b-%Y") #this is a base function

#repeat for end date, using lubridate instead of as.Date
transplant$enddate <- dmy(as.character(transplant$enddate))

#now, can do math on your dates!
transplant$duration <- transplant$enddate - transplant$startdate
transplant$duration <- as.numeric(transplant$duration)
summary(transplant$duration)

##### Step 6: Reshape database (i.e. if wide, change to long; if long, change to wide)  ########################

#6.1: Change data from long to wide format using tidyr::spread()
transplantwide <- spread(transplant, webpres, websize) #the values in webpres will be the new column names, and the columns will be populated by the values in websize

#6.2: Change data from wide to long using tidyr::gather()
# Gather moves column names into a key column, gathering the column values into a single value column.
# The arguments to gather(data, key, value, ..., factor_key):
# data: Data object
# key: Name of new key column (make a new name for the column that will contain the names of the column headings in the wide format)
# value: Name of new value column (make a new name for this column that will contain the values currently populating the rows in the wide format)
# ...: Names or column numbers for source columns that contain values (e.g. 10:12)
# factor_key=T: Treat the new key column as a factor (instead of character vector)

transplant_long <- gather(data = transplantwide, key = "webpres", value = "websize", no, yes) #note that we have now added a row with "NA" for every observation - this is undesirable for analysis, but serves to show how to go from wide to long

##### Step 7: Fix cells within columns (e.g. naming, capitalization) #####

summary(transplant) #need to fix capitalization, spelling, whitespace (maybe)

#7.1: change levels within a column so they are lower case.
levels(transplant$island)
transplant$island <- as.factor(tolower(transplant$island))
transplant$site <- as.factor(tolower(transplant$site))
levels(transplant$island)

#7.2: Change levels of a variable. There are a lot of ways to do this. Here are two.

#preferred approach
transplant$island[transplant$island == "gaum"] <- "guam"

#alternative approach
levels(transplant$island) <- gsub("siapan", "saipan", levels(transplant$island))

#7.3: Get rid of ghost levels
levels(transplant$island) # shows you what levels R thinks are part of island
transplant$island <- droplevels(transplant$island) # or
transplant$island <- factor(transplant$island)
levels(transplant$island)

#7.4: Re-order levels within a variable.
transplant$island <- factor(transplant$island, levels = c("saipan", "guam"))
levels(transplant$island)

#7.5: delete a certain # of characters from the values within a vector
#this is saying "keep the 1st-4th elements (start at 1, stop at 4)".
levels(transplant$site)
transplant$site<-as.factor(substr(transplant$site, 1, 4))
levels(transplant$site)

#7.6: Remove trailing whitespace
transplant$site <- as.factor(trimws(transplant$site))

#7.7: Center continuous predictors and make new column for this variable, may help with convergence
transplant$websize_c <- as.numeric(scale(transplant$websize))

##### Step 9: write csv file with tidy dataset into tidy folder #########

#create tidy database for analysis
write.csv(transplant, "data/tidy/transplant_tidy.csv", row.names=F)
