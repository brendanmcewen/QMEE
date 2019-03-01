anoles <- readRDS("anoles_clean.RData")

## BMB: thanks for saving intermediate results in a sensible way, but ... it's a little confusing
## to store an RDS file with extension ".RData".  It would normally be ".rds". (RDA/RData files are different from RDS files)


## One of my hypotheses from my anole dataset was that the limb morphology would be influenced by urbanization
## Anolis cristatellus has been in Florida for approximately 45 years, which corresponds to roughly 45 generations,
##    so morphological adaptation to these different areas is a plausible phenomenon
## Let's look to see if lizards in urban habitats have adapted longer femurs than lizards in natural environments. 
## I want to control for snout-vent length because I would like to know if the femurs are larger relative to their body in urban 
##    lizards as opposed to just superficially larger overall.

anole_femurs <- lm(FEM ~ context + svl.mm, data=anoles)
summary(anole_femurs)
## Seems to suggest that even after controlling for SVL, lizards at urban habitats did indeed have longer femurs. However,
##    the t-statistic of SVL was much larger than that of context

## There may be an effect associated with different sites in this dynamic. Since we have data on which lizard was captured
##    at which site, perhaps adding Site ID as a random effect would be appropriate. While we're at it, we should add
##      SVL as a fixed effect to control for the variance attributable to how large the lizard is overall.
## This brings us into GLMM territory:
library(lme4)
anole_femurs_2 <- glmer(FEM ~ context + svl.mm + (1|Site), family="gaussian", data=anoles)
## This broke the model, and then JD said not to worry about doing this as a GLMM for now
anole_femurs_2 <- lmer(FEM ~ context + svl.mm + (1|Site), data=anoles)
## BMB: this is not too hard to fix if you know how -- use lmer() instead of glmer()
## but in this case we estimate that the among-site variance is zero.
## This makes it effectively *identical* to the lm() fit
## Might also want to ask this question (but too complex):
anole_femurs_3 <- lmer(FEM ~ (1 + context + svl.mm |Site), data=anoles)

## Let's do a dot-whisker plot of the linear model that did work:
dwplot(anole_femurs)+geom_vline(xintercept=0,lty=2)
## Coefficient plot corroborates the notion that while SVL has a larger say in determining femur length, context:urban 
##    also has a positive influence. The 95% CI of contexturban does not overlap with zero, does this allow us to infer an effect
##    of urbanization on femur length in these lizards?
## BMB: yes (but we might also want to ask about the interaction)

##Now time for a diagnostic plot:
par(mfrow=c(2,2))
plot(anole_femurs)
# Residuals vs fitted plot shows the 'trend' line approximately following the zero line in the residuals, which 
#   I assume to be a good thing?
## QQNorm plot shows most of the data following along the normality line, with some slight departures at the tails
##  Many QQNorm plots I see look like this, is this an okay amount of deviation from normality?
## The scale-location plot shows no real relationship, with perhaps a slight positive linear uptick at the end
## Our Residuals vs Leverage plot doesn't show anything that looks too crazy

## BMB: absolutely.  This is a *very* well behaved set of diagnostics.

## score: 2.5
