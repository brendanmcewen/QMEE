## Bayesian Model Assignment
library(readr)
library(arm)
library(R2jags)
anoles <- readRDS("anoles_clean.RData")

## Want to test whether femurs are longer in lizards at urban sites (not controlling for SVL yet)
## Fit Linear Model Using lm():
summary(lm(FEM~context, data=anoles)) # yields t = 4.088, p =5.5e-05: lizards from urban areas have longer femurs (irrespective of SVL) compared to natural-site lizards

## Fit Linear Model Using bayesglm():
summary(bayesglm(FEM~context, data=anoles)) # yields similar results

## Lets set up our JAGS:
## Need to transform context (urban vs natural, categorical) into a numeric

context_num <- as.numeric(anoles$context)
N <- nrow(anoles)
1/var(anoles$FEM, na.rm=TRUE) ## Calculating precision, 1/variance. prec = 0.568 - will use this in my bug model
## Using 0 as my intercept prior which is probably not appropriate, no lizard (other than an amputated one) is going to have a femur length of 0


anolefemurs <- with(anoles, jags(model.file='Bayes_Homework_BUG.bug'
                                 , parameters=c("ma", "int", "tau")
                                 , data=list('context_num' = context_num, 'FEM' = FEM, 'N' = N)
                                 , n.chains = 4
                                 , inits = NULL
))

library(dotwhisker)
print(anolefemurs)
## print(dwplot(anolefemurs)) ## Error: 'Invalid Length Argument'
## JD: Please comment things out if they're not working

plot(anolefemurs) ##The 80% confidence interval for ma does not appear to intersect with zero, but I don't know how to acquire a 95% CI for ma.

## JD: The 95% CI is the thing that goes from the 2.5% quantile to the 97.5% quantile in your printout

traceplot(anolefemurs)
## My traceplots seem pretty uniform, a couple of the lines appear to be a bit longer than the others in some of them but to my 
##  un-trained eye this doesn't seem alarming. 
## JD: Looks fine to me, too.

## While I'm not 100% sure how to directly compare the frequentist models to my Bayesian model, it seems that the Bayesian model attributes an effect of
##    urban/natural context on femur length in these lizards (based on ma's 80% CI). This is in agreement with the linear models atop the script.

## Grade 2/3 (good)
