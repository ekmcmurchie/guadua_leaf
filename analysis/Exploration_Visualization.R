#SpiderTransplant exploration and visualization
#Haldre Rogers
#EEB698

library(ggplot2)

transplant<-read.csv("data/tidy/transplant_tidy.csv", header=T)

str(transplant)

#Getting summary data
#using base functions

## Explore using tables
#table, ftable
with(transplant, table(site, native))
#ftable makes a table with three variables more visually appealing
with(transplant, ftable(island, netting, totaldays))
with(transplant, ftable(island, netting, native))

#using dplyr package functions
# check out this website: https://www.r-bloggers.com/dplyr-example-1/

#Arrange - Order rows by values of a column (low to high). 
arrange(transplant, island, duration) #arrange from lowest to highest duration, for each level of island

#mutate - Compute and append one or more new columns.
mutate(transplant, webarea = (websize/2)^2*pi) #calculate webarea column from web diameter (assuming circle); can also add/multiply two columns to create a third etc. 

transplant %>% 
  group_by(island, native, netting) %>% 
  summarize (mean=mean(duration)) 

#play around with this- what else might you want to summarize? 

##############################################
##############################################
######basic visualization tools ##############
##############################################
#first change factors to factors

# Base graphics
#Boxplot (box-and-whisker plot, showing median, first & third quantile, extremes of whiskers)
boxplot(transplant2$duration)
boxplot(duration~island*netting, data=transplant2)

#histogram (frequency of each value of continuous variable)
hist(transplant2$duration)
hist(transplant2$websize)

#coplot - conditioning plots- how does websize related to duration, given netting status? 
coplot(duration~ websize | netting, data=transplant2)

#pairs - all column by column interactions
pairs(transplant2) #mostly nonsensical because so many factors, but you get the idea

#plot
plot(transplant2$websize, transplant2$duration) #for two continuous variables
plot(transplant2$island, transplant2$duration) #if x is categorical, this turns into a boxplot

######## ggplot #######
Resources
	# http://tutorials.iq.harvard.edu/R/Rgraphics/Rgraphics.html
	# http://zevross.com/blog/2014/08/04/beautiful-plotting-in-r-a-ggplot2-cheatsheet-3/

#aes = aesthetic means "something you can see"
#geom's: http://sape.inf.usi.ch/quick-reference/ggplot2/geom. A plot must have at least one geom; there is no upper limit.

#histogram - use only a single continuous x value
durationHist<-ggplot(transplant2, aes(duration))+
geom_histogram()

ggsave("durationHist.png", durationHist)

#boxplot
ggplot(transplant2, aes(netting, duration))+
geom_boxplot() #plot response and predictors, continuous data

#create different boxplots for each island
ggplot(transplant2, aes(netting, duration, color=island))+
  geom_boxplot() 

#geom_point for two continuous variables - scatterplot
ggplot(transplant2, aes(websize, duration))+
  geom_point()

#add facet_grid to show other variables
ggplot(transplant2, aes(websize, duration))+
  geom_point()+
  facet_grid(netting~island)+
  theme_bw()


                         
