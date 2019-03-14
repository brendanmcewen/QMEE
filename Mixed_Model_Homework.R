## Mixed Model Homework
library(lme4)
library(ggplot2)

anoles <- readRDS("anoles_clean.RData")
with(anoles, table(Site, context))
# context
# Site       natural urban
# Mayaguez      55    55
# Ponce         44    55
# San Juan      55    55
## All three of our sites have comparable captures of lizards in both habitat contexts. 
## Three sites isn't a sufficient number of sites to include  as a random effect, right? And the observations at these sites are not balanced
## JD told me to 'try it anyway and report what happens', so that's what I'll do!

fem.mixed.1 <- lmer(FEM ~ context + svl.mm + (1|Site), data=anoles)  
# femur length explained by context and SVL, site as a random effect influencing intercept
## Gives a 'Singular Fit' message
summary(fem.mixed.1)

 
# Now trying femurs explained by context and SVL with site as a random factor influencing our slope for context.
# This would mean that if there is an adaptive shift in femur length in response to urbanization, it's occurring at different magnitudes across our sites?
fem.mixed.2 <- lmer(FEM ~ context + svl.mm + (context|Site), data=anoles)
# Gives us a Singular Fit message again, I'm guessing this is going to happen for each of these. 
summary(fem.mixed.2)
# Our t-value for context (urbanization) is much lower here and no different from the intercept. By including the 
#     random effect of Site on the slope of context, we undermine the effect of context. I'm not quite sure how to wrap my head around this.

## Now trying femur lengths explained by context and SVL with site as random factor influencing slope for SVL
fem.mixed.3 <- lmer(FEM ~ context + svl.mm + (svl.mm|Site), data=anoles)
# Singular Fit again
summary(fem.mixed.3)
# Context's t-value is high once again, but this time we have decreased SVL's t-value. It seems that 
# including a random effect implicating the slope of a fixed effect pulls some of the variance out of the 
# model's evaluation of the fixed effect? I guess this makes sense.

## My maximal model would include all of these random effects (implicating Site variation in the intercepts as well as slopes of context and SVL);
## (1|Site), (context|Site), (svl.mm|Site). However, we have been advised to avoid implementing a random effect with less than 5 (and ideally 10) levels. 
##    My Site factor only has 3 levels. Thus, I think in the grand scheme of things it is not appropriate to include Site as a random effect


## For the Singular Fit issue: Is this because I might only have one observation at a given SVL in a particular level of Site? I.e. 61mm may only have one observation at San Juan. Would this
##    cause a perfect 0/1 in the variance/covariance matrices? The first advised method to eliminate Singular Fit problems is to simplify the model.
##    This is consistent with my inclination to not include ANY random effects due to the low number of levels in my potential random effect factor.
isSingular(fem.mixed.1)
# TRUE
isSingular(fem.mixed.2)
# TRUE
isSingular(fem.mixed.3)
# TRUE

## Would modifying our nAGQ= argument change things?
fem.mixed.1 <- lmer(FEM ~ context + svl.mm + (1|Site), nAGQ=25, data=anoles)
## 'extra arguments disregarded' Nope, that doesn't work. 