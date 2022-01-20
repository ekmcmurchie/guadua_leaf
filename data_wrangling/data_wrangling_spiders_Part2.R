#EEB698: Data wrangling Part 2

#Use this script to:
  #1) Load tidy data
  #2) Learn how to pipe (%>%)
  #3) Subset data (filter, select)
  #4) Summarize data (summarise)
  #5) Group data (group_by)
  #6) Create new columns (mutate)
  #7) Arrange data by the levels of a particular column (arrange)
  #8) Combine datasets (Join)
  #9) Iterate over groups (for loops, purrr)
  #10) Print tidy, wrangled database

source("lib/R_functions/ipak_fx.R") #load ipak function
ipak(c("tidyverse", "lubridate", "readxl", "magrittr"))

##### Step 1) Load tidy data, explore ########
transplant <- read_csv("data/tidy/transplant_tidy.csv")
str(transplant)
summary(transplant)

##### Step 2) Learn how to pipe #########
#Each method returns an object, so calls can be chained together in a single statement, without needing variables to store the intermediate results.
# it takes the output of one statement and makes it the input of the next statement. When describing it, you can think of it as a "THEN".

meanwebGuam <- transplant %>%
  subset(island == "guam") %>%
  summarize(mean(websize))

# the code chunk above will translate to something like "you take the transplant data, then you subset the guam data and then you calculate the meanwebsize".

#Here are four reasons why you should be using pipes in R:

# You'll structure the sequence of your data operations from left to right, as apposed to from inside and out;
# You'll avoid nested function calls;
# You'll minimize the need for local variables and function definitions; And
# You'll make it easy to add steps anywhere in the sequence of operations.

##### Step 3) Subset data (filter, select)
#use filter to extract rows according to some category
transplant_guam <- filter(transplant, island == "guam", site == "anao")

transplant_guam <- transplant %>%
  filter(island == "guam")

#use select to choose columns
select(transplant, island, site, websize, duration)

transplant %>%
  select(island, site, websize, duration)

##### Step 4) Summarize data (summarise, count)
#use summarize to compute a table using whatever summary function you want (e.g. mean, length, max, min, sd, var, sum, n_distinct, n, median)
summarise(transplant, avg=mean(websize), numsites= (length(unique(site))))

transplant %>%
  summarise(avg=mean(websize), numsites = length(unique(site)))

#use count to count the number of rows in each group
count(transplant, site)

transplant %>%
  count(site)

##### Step 5) Group data (group_by)
#use group_by to split a dataframe into different groups, then do something to each group

transplant %>%
  group_by(island) %>%
  summarize (avg = mean(websize))

trans_summ <- transplant %>%
  group_by(island, site, netting) %>%
  summarize (avgweb = mean(websize),
            avgduration = mean(duration))

##### Step 6) Create new columns (mutate)
mutate(transplant, webarea = ((websize/2)/100)^2*pi) #assume circle, divide in half to get radius, divide by 100 to get from cm to m, calculate area
transplant$webarea <- ((transplant$websize/2)/100)^2*pi

transplant %>%
  mutate(webarea = ((websize/2)/100)^2*pi) %>%
  head()

##### Step 7) Arrange data by the levels of a particular column (arrange)
#default goes from low to high
arrange(transplant, websize)

transplant %>%
  arrange(websize)

#use desc inside the arrange fx to go from high to low
transplant %>%
  arrange(desc(websize)) %>%
  head()

##### Step 8) Combine datasets (Join)
#you have two tables, table x (considered "left" table) and table y (considered "right" table)
preycap <- read_csv("data/tidy/preycap_tidy.csv")

#Left Join: join matching values from y to x. Return all values of x, and all columns from x and y, but only those from y that match. If multiple matches between x and y, then all combinations are returned.
leftjoin_transprey <- left_join(transplant, preycap, by = c("island", "site"))
#Use by = c("col1", "col2", ...) to specify one or more common columns to match on.

#Right Join: join matching values from x to y. Return all rows of y, all columns from x and y, but only those from x that match. As above, if multiple matches, all combinations are returned.
rightjoin_transprey <- right_join(transplant, preycap, by = c("island" = "island", "site" = "site"))
#Use a named vector, by = c("col1" = "col2"), to match on columns that have different names in each table. le _join(x, y, by = c("C" = "D"))

#Inner Join: Join data. Retain only rows from x and y that match, and all columns from both. If multiple matches between x and y, then all combination of matches are returned.
innerjoin_transprey <- inner_join(transplant, preycap, by = c("island", "site"))

#Full Join: Join data. retain all values, all rows from both x and y
fulljoin_transprey <- full_join(transplant, preycap, (by = c("island", "site")))

#let's figure out why we have 5502 obs and 18 variables for each of these join types
levels(as.factor(preycap$island))
levels(transplant$island)
levels(as.factor(preycap$site))
levels(transplant$site)

fulljoin_transprey %>%
  group_by(island, site) %>%
  summarize(numrows = n())

preycap %>%
  group_by(island, site) %>%
  summarize(numrows = n())

transplant %>%
  group_by(island, site) %>%
  summarize(numrows = n())

#since there are lots of matches for island and site, you get a row for every combination. i.e. for anao, get 13 rows in transplant each duplicated for 112 rows from preycap, for a total of 1456 rows.

##### Step 9) Iterate over groups (for loops, purrr)
#We will get to this later.

##### Step 10) Print tidy, wrangled database

write.csv(trans_summ, "data/tidy/transplant_summary.csv", row.names=F)

