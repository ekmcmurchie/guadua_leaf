######Spider Web Size Analysis ######

#Research Question: 
#Do spiders build smaller webs when birds are present? If so, then web size should be smaller on Saipan than on Guam. (note the N=1 problem here).
#Does this vary depending on whether spider was transplanted or found in the area? 

library(ggplot2)
library(car)
library(emmeans)

transplant<-read.csv("data/tidy/transplant_tidy.csv", header=T)
nrow(transplant) #91 rows

#################
#get subset that was actually transplanted rather than ones that were observed in place        
truetrans<-transplant[transplant$native=="no",]
nrow(truetrans)#62 rows 

################

###### Data Exploration ############

##a.  Outliers in Y / Outliers in X 
#i.	plot response and predictors to check for outliers  (only with continuous data)
#1.	Use hist or dotplot or boxplot, identify outliers
hist(transplant$websize)
dotchart(transplant$websize)
boxplot(transplant$websize~ transplant$site,  ylab="websize")
#no major outliers in Y, X is categorical

#b.	Examine Zero inflation Y
#Not applicable for web size question, because response is continuous

#c.	Collinearity X: correlation between covariates ()
#i.	Plot each predictor against each other (since categorical, can't test this directly)

#d.	Look at relationships of Y vs X’s to see if homogenous variances at each X value, linear relationships
# i.	Plot response against each predictor and random effect. 
ggplot(transplant, aes(native, websize, color=island))+
  geom_boxplot()
#maybe less variance on Saipan than on Guam, but nothing stands out as terrible. 

#e.	Independence Y - are Y's independent? 
#1.	Is there a pattern across time or space that is not incorporated in the model? 
ggplot(transplant, aes(native, websize, color=island))+
  geom_boxplot()+
  facet_grid(.~site)
#But nothing really stands out in terms of site-level effects. 

#ii. Are there other potential factors that reduce independence of Y’s? 
#timing is similar, can't think of anything else that might matter. 

#f.	Sufficient data?  
##As a rule of thumb, (all models), should have 15 to 20 observations for each parameter. So, if have 50 observations, should really only have 3 parameters. 

#i.	Do all levels of island have adequate samples of at each level of native? 	Examine interactions
#Is the quality of the data good enough to include them? (i.e. do we have enough samples for each level of the interaction?) 
with(transplant, table(island, native)) #have all combinations here. 
#if samples are unequal, can't use anova(model)
##good = balanced, bad = unequal sample sizes, ugly = one or more combination is missing

#check across sites: 
with(transplant, ftable(island, native, site))
#well, we only sampled at 2 sites on Guam, and three sites on Saipan, and we don't have all levels of native for all sites. Need to be careful about how we use site in the model. 

#summary
# no obvious outliers
# can go ahead looking at web size relative to island and native. 
# there is a lot of variability - is there something I might have measured related to web size that is not the thing I'm testing? 

#################################################
# Fix up dataframe
# a.	Remove missing values (NA’s)
# Not applicable

# b. Standardize continuous predictors (if necessary)
### Why?? You would center (standardize) continuous covariates to remove correlation between slope and intercept. Centering is just putting each value around the mean, whereas standardizing is dividing by SD too. Standardizing puts all variables on the same scale (e.g. temperature, pH etc.), which can be useful for comparing effect sizes of variables, and it can help with model convergence. May be necessary with small datasets with lots of covariates, especially. 
# #in this situation, not necessary, bc no continuous predictors

##################################################
###########  Analysis   ###############

#1) Does web size differ between islands, and does transplanting affect web size? 

#using all data
#websize~island*native, family=gaussian  #by default, an identity link

webmod1<-lm(websize~island*native, data=transplant)
summary(webmod1)
anova(webmod1) #should not use if unbalanced

#check out the design matrix
model.matrix(webmod1)

# Opinions on model selection- much disagreement about which is best. 

# 1. Classical Hypothesis testing: drop all nonsignificant predictors, then report final model and interpret differences between levels of a predictor in final model. 

# anova(model) gives Type I sums of squares, which means the reference level is tested first and then other levels, and then interactions. R defaults to treatment contrasts, where first level is baseline, and all others are in reference to that. Can get different results for unbalanced datasets depending on which factor is entered first in the model and thus considered first. 

with(transplant,tapply(websize, list(island, native), mean))

##can use car package to do Type II or III sums of squares
Anova(webmod1, type="III") #Type III tests for the presence of a main effect after the other main effect and interaction. This approach is therefore valid in the presence of significant interactions.However, it is often not interesting to interpret a main effect if interactions are present (generally speaking, if a significant interaction is present, the main effects should not be further analysed).

#explore contrasts
options('contrasts') #shows what contrasts R is using

#can set contrasts to SAS default. "contr.SAS" is a trivial modification of contr.treatment that sets the base level to be the last level instead of the first level. The coefficients produced when using these contrasts should be equivalent to those produced by SAS.

webmod1a<-lm(websize~island*native, data=transplant, contrasts = list(island = "contr.SAS", native="contr.SAS"))
summary(webmod1a)

#Type II
Anova(lm(websize~island+native, data=transplant), type="II")  #This type tests for each main effect after the other main effect.Note that Type II does not handle interactions.

#compare against 
anova(lm(websize~native+island, data=transplant))
anova(lm(websize~island+native, data=transplant))

#emmeans - to test for differences between levels of a factor
webmod1<-lm(websize~island*native, data=transplant)
anova(webmod1)

islnat<-pairs(emmeans(webmod1, ~island | native)) # to test whether there are differences between guam & saipan given a particular native status

natisl <- pairs(emmeans(webmod1, ~native | island)) #to test whether there are differences between native & not native given that you are on Guam or Saipan

rbind(islnat, natisl)

# 2. Classic model selection: Create all sub-models. Use LRT to come up with best model. 
webmod2<-lm(websize~island+native, data=transplant)
webmod3<-lm(websize~island, data=transplant)
webmod4<-lm(websize~native, data=transplant)
webmod_null<-lm(websize~1, data=transplant)

anova(webmod1, webmod2)  #model 1 not sig better than 2
anova(webmod2, webmod3)  #model 2 not sig better than 3
anova(webmod3, webmod4) #can't run this, because not sub-model - needs to be nested to compare with LRT
anova(webmod3, webmod_null) #model 3 sig better fit than null model
anova(webmod4, webmod_null)

# 3. Information theoretic approach- compare models using AIC- get competing models. AIC is a measure of the goodness of fit of an estimated statistical model. It is -2*log-likelihood + 2*npar, where npar is the number of effective parameters in the model. More complex models get penalized. 

AIC(webmod1, webmod2, webmod3, webmod4, webmod_null) #webmod3 has lowest AIC, by almost 2 points. Might consider model averaging. 

#check out packages MuMIn and AICcmodavg for a variety of useful tools. 

# 4. If you do an experiment, don’t do any model selection at all- fit model that you think makes sense, and keep everything as it is, even non-significant parameters. Some might choose to do some model selection to keep only significant interactions, but once fit model with main effect terms, then stick with it. 

confint(webmod3) #Saipan webs are significantly smaller than Guam (confidence intervals do not overlap 0)

#Model validation
#A. Look at homogeneity: plot fitted values vs residuals
#B. Look at influential values: Cook
#C. Look at independence: 
#      plot residuals vs each covariate in the model
#      plot residuals vs each covariate not in the model
#      Common sense 
#D. Look at normality of residuals: histogram

#for lm can use plot(model)
plot(webmod1)

#extract residuals
E1 <- resid(webmod1, type = "pearson")

#plot fitted vs residuals
F1 <- fitted(webmod1, type = "response")

par(mfrow = c(2,2), mar = c(5,5,2,2))
plot(x = F1, 
     y = E1, 
     xlab = "Fitted values",
     ylab = "Pearson residuals", 
     cex.lab = 1.5)
abline(h = 0, lty = 2)

plot(x=transplant$island, y=E1) #heterogeneity in residuals bt islands
plot(x=transplant$native, y=E1) #heterogeneity in residuals wrt native
plot(x=transplant$site, y=E1) #residual variance larger at Guam sites than Saipan sites, but homogeneity bt sites within an island


### GLMER ########
library(lme4)
webmod_mm<-lmer(websize ~ island+native + (1|site), data=transplant)
summary(webmod_mm) #no p-values! 

#explore model fit 

#extract residuals
E1 <- resid(webmod_mm, type = "pearson")

#plot fitted vs residuals
F1 <- fitted(webmod_mm, type = "response")

par(mfrow = c(2,2), mar = c(5,5,2,2))
plot(x = F1, 
     y = E1, 
     xlab = "Fitted values",
     ylab = "Pearson residuals", 
     cex.lab = 1.5)
abline(h = 0, lty = 2)

plot(x=transplant$island, y=E1) #heterogeneity in residuals bt islands
plot(x=transplant$native, y=E1) #heterogeneity in residuals wrt native
plot(x=transplant$site, y=E1) #residual variance larger at Guam sites than Saipan sites, but homogeneity bt sites within an island
