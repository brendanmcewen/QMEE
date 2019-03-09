## Positive continuous response use gamma family, link = log, will use this for FEM 

getwd()
library(ggplot2)
anoles <- readRDS("anoles_clean.RData")

## Testing hypothesis that anoles at urban sites will have longer femurs relative to body (including SVL in model)

## Let's run a regular lm just to see what this looks like:
m0 <- lm(FEM ~ context + svl.mm, data=anoles)
summary(m0)
plot(m0)

## Femur lengths should be distributed normally, so will use Gamma family (and log link, as advised in class)
m1 <- glm(FEM ~ context + svl.mm, family=Gamma(link="log"), data=anoles)
summary(m1)
## Deviances are 2.1 and 0 on >300 df. This seems like a case of underdispersion. Is this bad?

plot(m1)
## We have a bit of a quadratic thing going on with the residuals vs fitted plot, and some of our residuals in the residuals vs leverage plot are drifting away into high-leverage territory. 
## Again, I'm not sure exactly how to interpret these but it seems like this may be cause for concern?

