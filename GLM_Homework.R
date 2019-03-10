## Positive continuous response use gamma family, link = log, will use this for FEM 

## getwd()
library(ggplot2)
anoles <- readRDS("anoles_clean.RData")

## Testing hypothesis that anoles at urban sites will have longer femurs relative to body (including SVL in model)

## Let's run a regular lm just to see what this looks like:
m0 <- lm(FEM ~ context + svl.mm, data=anoles)
summary(m0)
plot(m0)  ## BMB: already looks pretty good?

## Femur lengths should be distributed normally, so will use Gamma family (and log link, as advised in class)
m1 <- glm(FEM ~ context + svl.mm, family=Gamma(link="log"), data=anoles)
summary(m1)
## Deviances are 2.1 and 0 on >300 df. This seems like a case of underdispersion. Is this bad?
## BMB: don't worry about deviance/df comparison when using a model with variance parameters (i.e. not Poisson/binomial)

plot(m1)
## We have a bit of a quadratic thing going on with the residuals vs fitted plot, and some of our residuals in the residuals vs leverage plot are drifting away into high-leverage territory. 
## Again, I'm not sure exactly how to interpret these but it seems like this may be cause for concern?

## BMB: Leverage doesn't look bad to me.  I would definitely look at the quadratic
## issue, not because I think it will mess up your conclusions about habitats, but because it might be interesting.
## Why not looking at interactions?

ggplot(anoles, aes(svl.mm,FEM,colour=context))+
    geom_point()+
    geom_smooth(method="lm")+
    geom_smooth(method="glm",method.args=list(family=Gamma(link="log")),
                lty=2)
## BMB: hardly any difference between Gamma GLM and LM

## try quadratic fit?
ggplot(anoles, aes(svl.mm,FEM,colour=context))+
    geom_point()+
    geom_smooth(method="lm",
                formula=y~poly(x,2))

## BMB: you could also compare conclusions of lm(log(FEM) ~ ...) with
## Gamma  with log-link GLM (should be *very* similar)

## BMB: score 2.25
