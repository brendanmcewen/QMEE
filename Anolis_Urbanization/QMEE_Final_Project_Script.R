## QMEE Project Script
library(ggplot2)
library(dotwhisker)
library(car)
library(geomorph)
library(tidyr)
library(dplyr)
library(corrplot)

## BMB: comment this out!
## setwd("~/Eco Stats (BIO 708)/QMEE GitHub/Anolis_Urbanization")
source("./MLM_Dworkin.R") ## Need this for the shapeRsq() function for Multivariate
anoles.PCA <- read.csv("Anoles.na.csv") # Separate file with the NAs omitted for our PCA-implicated variables
anoles <- readRDS("anoles_clean.RData")
perches <- read.csv("perches.csv")
summary(anoles)
names(anoles)
head(anoles)


## Perch plotting: What substrates are used in each context? What materials are lizards in urban habitats interacting with 
## That anoles in natural settings don't interact with, and how frequently are lizards found on these substrates?
perches$Perch <- factor(perches$Perch, levels=c("Tree", "Metal", "Concrete", "Other"))
## BMB: do this (factor orderin) upstream during data cleaning/organization?

perch.plot <- ggplot(data=perches, aes(Perch, Count, fill=Perch))+
  geom_col()+
  facet_wrap(~Context, nrow=1)+
  scale_fill_manual(values=c(Tree="forestgreen", Metal="grey46", Concrete="gray90", Other="gray2"))+
  theme_bw()
perch.plot
## BMB: Why not side by-sid

(perch.plot2 <- ggplot(data=perches, aes(Perch, Count, fill=Perch,
                                       alpha=Context))
    + geom_col(position="dodge")
    + scale_fill_manual(values=c(Tree="forestgreen", Metal="grey46", Concrete="gray90", Other="gray2"))
    + scale_alpha_manual(values=c(0.9,0.5))
    + theme_bw()
)
## this would take more side-by-side tweaking/legend adjustment, but you
## get the idea

## Thermal Stuff: Are anoles in urban settings experiencing hotspot effects?
## Temperature Figures : 


## JD: Work on point size scaling; more natural to have area be proportional
## Also work on color palette …
## Ambient Temp Fig
## First want to see if just general areas are warmer than each other
temp.fig.ambient <- ggplot(data=anoles, aes(local.time.decimal, ambient.temp.C, col=context))+
    geom_smooth()+
    stat_sum(pch=1)+
  labs(title="Ambient Temperature Across Time of Day", x="Time of Day", y="Ambient Temp Celsius")+
  scale_color_manual(values=c(natural="forestgreen", urban="gray45"))+
  theme_bw()+
  theme(legend.title=element_text(size=14),
        legend.text=element_text(size=12),
        axis.title.x = element_text(size=16),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14))+
    scale_size(breaks=1:3)
temp.fig.ambient
## BMB: always include the raw data unless you have a good reason not to

# Model:
anoles$TC1 <- cos(2*pi*anoles$local.time.decimal/24)
anoles$TC2 <- sin(2*pi*anoles$local.time.decimal/24)
ambient.full.mod <- lm(ambient.temp.C ~ TC1 + TC2 + context, data=anoles)
summary(ambient.full.mod)
plot(ambient.full.mod) ## Looks pretty good, some deviation from normality and a couple high-leverage points but nothing outrageous
## BMB: I would definitely worry about the scale-location plot here
## (distinct decrease in variance with increasing fitted value)

## JD: It would be great to have a reference line at β=0.
## Also: how are these scaled? Do you think they are comparable values?
dwplot(ambient.full.mod)

## JD: why does it cover a different time range (no afternoon in forest)?
## PERCH TEMP FIGURE
## Zooming in to the substrate level, are the surfaces that these lizards are choosing to occupy warmer in urbanized areas?
temp.fig.perch <- ggplot(data=anoles, aes(local.time.decimal, perch.temp.C, col=context))+
  geom_smooth()+
  labs(title="Perch Temperatures Across Time of Day", x="Time of Day", y="Perch Temp Celsius")+
  scale_color_manual(values=c(natural="forestgreen", urban="gray45"))+
  theme_bw()+
  theme(legend.title=element_text(size=14),
        legend.text=element_text(size=12),
        axis.title.x = element_text(size=16),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14))
temp.fig.perch
## BMB:  see previous comments about need for data points
## also: don't repeat all the theme() stuff -- define it once and re-use
# Model:
## JD: And really don't define TCs more than once
anoles$TC1 <- cos(2*pi*anoles$local.time.decimal/24)
anoles$TC2 <- sin(2*pi*anoles$local.time.decimal/24)
perchtemp.full.mod <- lm(perch.temp.C ~ TC1 + TC2 + context, data=anoles)
summary(perchtemp.full.mod)
plot(perchtemp.full.mod) # Points on scale-location plot look crazy, is this normal?
## BMB: this is fine -- has to do with a small discrete number of perch temps
## JD: Accidental art!
library(viridisLite)
library(broom)
aa <- augment(perchtemp.full.mod)
ggplot(aa, aes(.fitted,sqrt(abs(.std.resid)),colour=perch.temp.C))+
    geom_point()+
    geom_line(aes(group=perch.temp.C))+
    scale_colour_viridis_c() + theme_bw()
    
dwplot(perchtemp.full.mod) # coefficients here are stronger than in the ambient temperature model
## JD: And a bigger relative effect of context

## Body Temp Figure
temp.fig.body <- ggplot(data=anoles, aes(local.time.decimal, bodytemp.C, col=context))+
  geom_smooth()+
  labs(title="Body Temperatures Across Time of Day", x="Time of Day", y="Body Temp Celsius")+
  scale_color_manual(values=c(natural="forestgreen", urban="gray45"))+
  theme_bw()+
  theme(legend.title=element_text(size=14),
        legend.text=element_text(size=12),
        axis.title.x = element_text(size=16),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14))
temp.fig.body
## For future analyses, can we extrapolate the natural curve to view across the same time frame as urban?
# Model:

## JD: The repetition is having serious impacts on readability
anoles$TC1 <- cos(2*pi*anoles$local.time.decimal/24)
anoles$TC2 <- sin(2*pi*anoles$local.time.decimal/24)
bodytemp.full.mod <- lm(bodytemp.C ~ TC1 + TC2 + context, data=anoles)
summary(bodytemp.full.mod)
plot(bodytemp.full.mod) ## The QQ plot on this one is the most suspect. How bad is this?
## JD: Doesn't bother me. Looks more like discreteness than serious problems
dwplot(bodytemp.full.mod) ## Coefficient for urbanization closer to the higher value seen in the perch temperature model

## In the grading for our presentation, BMB suggested we do a GAM to account for time differences. 
library(mgcv)
temp.gam <- gam(bodytemp.C ~ context + s(local.time.decimal, by=context), data=anoles) # smoothing by time of day and breaking this smoothing up into urban vs natural components
summary(temp.gam) # clear difference in our parametric coefficient test, with both of our smoothing terms being significant. 
## For what it's worth, the urban smoothing component had a much higher F-value. I'm not entirely sure how to interpret this?
## BMB: it means the urban pattern is much farther from a constant value.


## Principal Component Analysis: Urbanization Index & Biotic Response
## We wanted to try our hand at PCA to see if we could generate indices for our predictor and response variables. 

## PCA 1:  Abiotic Urbanization Index
AnolesPCA_Abiotic <- prcomp(~bodytemp.C + perch.temp.C + ambient.temp.C + humidity.percent + perch.height.cm + perch.diam.cm, data = anoles.PCA, scale = TRUE)
AnolesPCA_Abiotic #calling our PCA object
summary(AnolesPCA_Abiotic) #Here we see the percent variation that is explained by each PC
plot(AnolesPCA_Abiotic, type = "l") #This plot again just shows how much relative variance is explained by each PC
biplot(AnolesPCA_Abiotic, scale = 0) #Each number is an observation, each observation is represented by its value for PC1 and PC2.

## Let's look at the relationship between PC1/2 at Urban vs Natural sites
anoles.PCA <- cbind(anoles.PCA, AnolesPCA_Abiotic$x[,1:2])
ggplot(anoles.PCA, aes(PC1, PC2, colour = context, fill = context)) + 
  scale_fill_manual(values=c(natural="forestgreen",urban="gray45"))+
  stat_ellipse(geom = "polygon", colour = "black", alpha = 0.5) + 
  geom_point(shape = 21, colour = "black") + 
  theme_classic() ## Lots of overlap, hard to tell if anything's going on here

ggplot(anoles.PCA, aes(context, PC1, fill = context)) + 
  geom_boxplot() + 
  scale_fill_manual(values=c(natural="forestgreen",urban="gray45"))+
  theme_classic() ## PC1 a bit

#Linear Models:
lm.Abiotic.PC1 <- lm(PC1 ~ context, data = anoles.PCA)
summary(lm.Abiotic.PC1) #P < 0.001
plot(lm.Abiotic.PC1)
lm.Abiotic.PC2 <- lm(PC2 ~ context, data = anoles.PCA)
summary(lm.Abiotic.PC2)
plot(lm.Abiotic.PC1)
## These are tricky because the PCA doesn't take time of day into account, which was already discussed 
## and demonstrated above to be a non-linear dynamic. Not quite sure what the best way to compare the PCs of urban vs natural would be



## PCA 2:  Biotic Response Index

AnolesPCA_Biotic <- prcomp(~JL + JW + METC + RAD + ULN + HUM + FEM + TIB + FIB + METT1 + METT2, data = anoles.PCA, scale = TRUE)
AnolesPCA_Biotic #calling our PCA object
summary(AnolesPCA_Biotic) #Here we see the percent variation that is explained by each PC
plot(AnolesPCA_Biotic, type = "l") #This plot again just shows how much relative variance is explained by each PC
biplot(AnolesPCA_Biotic, scale = 0) # This is weird that it loaded everything 'negatively', such that
##  Having a higher PC1 for the Biotic Response variables actually results in having *shorter* lengths for those limb components

anoles.PCA <- cbind(anoles.PCA, AnolesPCA_Biotic$x[,1:2])
## Realizing now that we've added these columns onto the dataframe and they (by default) get named the same thing
## Let's use an A/B prefix (Abiotic/Biotic) to help clear that up
names(anoles.PCA) ## Need to rename columns [32:35]
names(anoles.PCA)[32] <- "APC1"
names(anoles.PCA)[33] <- "APC2"
names(anoles.PCA)[34] <- "BPC1"
names(anoles.PCA)[35] <- "BPC2"
names(anoles.PCA)[32:35] ## There we go, now we won't be making ambiguous column calls when plotting. This
##    wasn't an issue in our first set of plots, since at that point we only had the Abiotic set of PC1/PC2

#Plot with ggplot:
ggplot(anoles.PCA, aes(BPC1, BPC2, colour = context, fill = context)) + 
  stat_ellipse(geom = "polygon", colour = "black", alpha = 0.5) + 
  scale_fill_manual(values=c(natural="forestgreen",urban="gray45"))+
  geom_point(shape = 21, colour = "black") + 
  theme_classic()

ggplot(anoles.PCA, aes(context, BPC1, fill = context)) + 
  scale_fill_manual(values=c(natural="forestgreen",urban="gray45"))+
  geom_boxplot() + 
  theme_classic()

ggplot(anoles.PCA, aes(context, BPC2, fill = context)) + 
  scale_fill_manual(values=c(natural="forestgreen",urban="gray45"))+
  geom_boxplot() + 
  theme_classic()

## BMB: if you want to distinguish these in multiple dims you can also try discriminant analysis

#Linear Model:
lm.Biotic.BPC1 <- lm(BPC1 ~ context, data = anoles.PCA)
summary(lm.Biotic.BPC1) #P < 0.001
plot(lm.Biotic.BPC1) ## Not quite sure how to interpret these bimodal distributions in the diagnostic plots,
## BMB: there are only two contexts!

## But the QQ-plot didn't look too bad
lm.Biotic.BPC2 <- lm(BPC2 ~ context, data = anoles.PCA)
summary(lm.Biotic.BPC2)
plot(lm.Biotic.BPC2)
## Because we're not dealing with a component with non-linear traits (e.g. not using temperature in this PCA
##    like we were in the last one), it seems to us like we can trust this quick comparison using 
##    the linear model. Is this accurate?


#Correlation between Abiotic and Biotic PCs:
(PC_Nat_Cor <- cor.test(anoles.PCA$APC1[anoles.PCA$context=="natural"], anoles.PCA$BPC1[anoles.PCA$context=="natural"]))

(PC_Urb_Cor <- cor.test(anoles.PCA$APC1[anoles.PCA$context=="urban"], anoles.PCA$BPC1[anoles.PCA$context=="urban"]))
## Neither are correlated
## BMB: please say CLEARLY correlated
## JD: The sign of the correlation is not clear ☺
## JD: Or even, correlations are small (based on CIs with a standard of 0.25 or something)

## Plotting the Urbanization PC1 against the Biotic Response PC1 just to see what it looks like
ggplot(data = anoles.PCA) +
  geom_point(mapping = aes(x = APC1, y = BPC1, colour = context)) +
  geom_smooth(mapping = aes(x = APC1, y = BPC1, colour = context)) + 
  scale_color_manual(values=c(natural="forestgreen",urban="gray45"))+
  labs(x = "Urbanization Index (PC1 Abiotic)", y = "Biotic Response Index (PC1 Biotic)") + 
  theme_classic(base_size = 14)
## Nothing super compelling. Again, because the Biotic Response PC1 loaded everything negatively, the urban
##    limb components are all *longer* despite the lower PC1 values for Biotic Response.


## While we're on the subject of Biotic Responses,
## Single-trait Morphometric Models:

## Using a log-transformed snout-vent length as a covariate, I was able to replicate the authors' findings pretty cleanly

## Radius:
contrasts(anoles$context) <- contr.poly(2)
rad.mod <- lm(log(RAD) ~ log(svl.mm) + context, data=anoles)
Anova(rad.mod)
plot(rad.mod) # Residual/fitted plot is looking a tiny bit quadratic, and scale-location is a bit linear-looking. 
##    also a couple of high-leverage points


## Ulna:
contrasts(anoles$context) <- contr.poly(2)
uln.mod <- lm(log(ULN) ~ log(svl.mm) + context, data=anoles)
Anova(uln.mod)
plot(uln.mod) # this one is better-behaved than the Radius model

## Humerus:
contrasts(anoles$context) <- contr.poly(2)
hum.mod <- lm(log(HUM) ~ log(svl.mm) + context, data=anoles)
Anova(hum.mod)
plot(hum.mod) # bit of a weird tail at the end of the scale-location plot

## Femurs:
contrasts(anoles$context) <- contr.poly(2)
fem.mod <- lm(log(FEM) ~ log(svl.mm) + context, data=anoles)
Anova(fem.mod)
plot(fem.mod) # QQ plot is a bit choppy but other than that nothing crazy

## Fibula: 
contrasts(anoles$context) <- contr.poly(2)
fib.mod <- lm(log(FIB) ~ log(svl.mm) + context, data=anoles)
Anova(fib.mod)
plot(fib.mod) # Nothing egregious

## Tibia:
contrasts(anoles$context) <- contr.poly(2)
tib.mod <- lm(log(TIB) ~ log(svl.mm) + context, data=anoles)
Anova(tib.mod)
plot(tib.mod) # Nothing crazy here either


## Single-Trait Morphometric Figures 
## These are the boxplots from my presentation that I promised you all I didn't just copy-paste. I was telling the truth!
## Was getting "Warning message: Removed 2 rows containing non-finite values (stat_boxplot)." and I see from summary()
##    that I have a couple NAs for these morphometrics. Perhaps two lizards died or escaped before they could be x-rayed

anoles <- anoles%>%
  drop_na(RAD,ULN,HUM,FEM,FIB,TIB) ## This fixed it
summary(anoles)

## BMB: please try to make a function to do this rather than
##  repeating code ...
## Forelimbs:

# 1. Radius
rad.fig <- ggplot(data=anoles, aes(context, log(RAD), fill=context))+
  geom_boxplot()+
  scale_fill_manual(values=c(natural="forestgreen",urban="gray45"))+
  theme_bw()+
  labs(x="Context", y="Log-Transformed Radius Length")+
  theme(legend.position="none",
        legend.text=element_text(size=12),
        axis.title.x = element_text(size=16),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14))
rad.fig

# 2. Ulna
uln.fig <- ggplot(data=anoles, aes(context, log(ULN), fill=context))+
  geom_boxplot()+
  scale_fill_manual(values=c(natural="forestgreen",urban="gray45"))+
  theme_bw()+
  labs(x="Context", y="Log-Transformed Ulnar Length")+
  theme(legend.position="none",
        legend.text=element_text(size=12),
        axis.title.x = element_text(size=16),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14))
uln.fig

# 3. Humerus
hum.fig <- ggplot(data=anoles, aes(context, log(HUM), fill=context))+
  geom_boxplot()+
  scale_fill_manual(values=c(natural="forestgreen",urban="gray45"))+
  theme_bw()+
  labs(x="Context", y="Log-Transformed Humerus Length")+
  theme(legend.position="none",
        legend.text=element_text(size=12),
        axis.title.x = element_text(size=16),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14))
hum.fig

## Hindlimbs:

# 1. Femur
fem.fig <- ggplot(data=anoles, aes(context, log(FEM), fill=context))+
  geom_boxplot()+
  scale_fill_manual(values=c(natural="forestgreen",urban="gray45"))+
  theme_bw()+
  labs(x="Context", y="Log-Transformed Femur Length")+
  theme(legend.position="none",
        legend.text=element_text(size=12),
        axis.title.x = element_text(size=16),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14))
fem.fig

# 2. Fibula
fib.fig <- ggplot(data=anoles, aes(context, log(FIB), fill=context))+
  geom_boxplot()+
  scale_fill_manual(values=c(natural="forestgreen",urban="gray45"))+
  theme_bw()+
  labs(x="Context", y="Log-Transformed Fibula Length")+
  theme(legend.position="none",
        legend.text=element_text(size=12),
        axis.title.x = element_text(size=16),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14))
fib.fig

# 3. Tibia
tib.fig <- ggplot(data=anoles, aes(context, log(TIB), fill=context))+
  geom_boxplot()+
  scale_fill_manual(values=c(natural="forestgreen",urban="gray45"))+
  theme_bw()+
  labs(x="Context", y="Log-Transformed Tibia Length")+
  theme(legend.position="none",
        legend.text=element_text(size=12),
        axis.title.x = element_text(size=16),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14))
tib.fig




## MULTIVARIATE RESPONSE STUFF:

## Our goal here is to use a multivariate model to evaluate the effect of living in urban habitats on 
##     limb component morphometrics/ratios in these lizards
## I'll use six response variables: Radius (RAD), Ulna (ULN), Humerus (HUM), Femur (FEM), Tibia (TIB), 
##    and Fibula (FIB). Predictor variable is context, a 2-level factor (urban, natural)
## I'll be following along to the notes provided in Ian Dworkin's guest lectures

## There are many columns in this dataframe that I'm not using right now. I'd rather not have to deal with them. 
##    I'll select Individual ID, my response variable columns, my predictor column (context), my covariate (SVL), and the Site that they came from
multmorph <- anoles %>% 
  drop_na(RAD,ULN,HUM,FEM,TIB,FIB) %>%
  select(ID, Site, context, svl.mm, RAD, ULN, HUM, FEM, TIB, FIB)
summary(multmorph) ## Now saying the dataframe is two observations shorter, I only see my relevant columns, and there are no NAs. Success! Thanks tidyverse.
class(multmorph$context) ## tells me my predictor variable is indeed a factor, we're in business.

cov(multmorph[5:10])
cor(multmorph[5:10]) ## Just taking a look at the covariances and correlations. Femur has the highest variance, which
##  makes sense because it's the longest measurement. 

pairs(multmorph[, 5:10],
      pch = ".", gap = 0) ## That we see Radius/Ulna and Tibia/Fibula the most tightly correlated 
##                            isn't surprising from an anatomical point of view. Those are the dual-bone pairs in the
##                            forelimb/foreleg, so would make sense that (even though everything is highly correlated)
##                            those are the most closely related

M <- cor(multmorph[,5:10])
corrplot(M, method="circle") # All of these correlations are the same (high) values. 
                                        #   This is not a useful mode of visualization.
## BMB: try corrplot.mixed instead ...
corrplot.mixed(M, lower="ellipse",upper="number") # All of these correlations are the same (high) values. 

scatterplotMatrix( ~ RAD + ULN + HUM + FEM + TIB + FIB | context, 
                   ellipse = TRUE, data = multmorph, gap = 0,
                   plot.points = FALSE)
## Distributions all appear to be shifted higher in urban context, ellipses largely overlap but urban is higher in each case
## Want to evaluate our variance-covariance matrix via calculating Eigenvalues
eigenvals <- svd(cov(multmorph[, 5:10]))$d
det(cov(multmorph[, 5:10]))
prod(eigenvals)
## These two numbers are identical! To our untrained eyes they appear quite small, but Ian's notes say that
##  an eigenval of 1e-10 was 'not vanishingly small' so perhaps these (at 3 orders of magnitude larger) are okay?
## BMB: this product is less generally useful than Ian suggested ...

sum(eigenvals) # This sum is also larger than the one seen in Ian's lecture notes. I imagine that this is largely
## to do with the number of variables being considered, also scale-dependent, and that we 
## can't actually just compare these numbers (relating to anole limb lengths) to his (drosophila morphometrics)
##    and attempt to glean any meaningful conclusions from this


## Time for the model itself. Ian has mentioned that the lm() format for MLMs is data-hungry. I'm computing a model for six response variables 
##    with a dataframe that is 317 observations long. Is this enough data to trust this model?
## I don't believe I need to scale anything, but I should log-transform all of these response variables

mlm1 <- lm(as.matrix(log(multmorph[,5:10])) ~ context, data=multmorph)
summary(manova(mlm1))
## We see a clear difference between these measurements across contexts, but I have not accounted for 
##  SVL as a covariate. For this, I must perform a MANCOVA

## New model with covariate added. I was told by someone in our lab that I don't need to log-transform the covariate. Is this correct?
contrasts(anoles$context) <- contr.poly(2) # Setting contrasts for our predictor
mlm2 <- lm(as.matrix(log(multmorph[,5:10])) ~ svl.mm + context, data=multmorph) 
                                                                              
Manova(mlm2, type="II")
## After accounting for SVL as a covariate, we retain the previous model's clear differences observed 
## across lizards captured at natural vs urban sites! This is exciting, I'm glad I (superficially at least) got this to work

coef(mlm2) # Actually assigned a higher coefficient to urbanization than SVL for some limb components, that's crazy
## BMB: are your svl.mm values scaled? otherwise they won't be comparable
shapeRsq(mlm2) # This number is so high that I don't actually trust it
sum(diag(cov(mlm2$fitted)))/sum(diag(cov(multmorph[,5:10]))) # this number is vastly different from that calculated in shapeRsq()
#   versus it being the same in Ian's notes. 


## Ian's notes provided some 'distance-based approaches', with the following technique recommended
##    for less data-rich scenarios. 
mlm3 <- procD.lm(f1 = multmorph[, 5:10] ~ svl.mm + context, 
                 data = multmorph, iter = 2000 ) # Still get our clear differences
summary(mlm3) # The Rsq value here is different from both of the above-generated values, but 
## much closer to the (lower) value  produced by the long-hand version
shapeRsq(mlm3) # Back to the super-high Rsq value that I don't trust. 
