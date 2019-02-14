# I was getting frustrated with using that anoles dataset I got from Dryad, so I'm going to use some spider data that I've worked with before
# We deployed experimental colonies of social spiders and tracked various aspects of their performance 
# Roughly half of the colonies were deployed at 'arid' sites with low rainfall, other half of colonies were deployed
#       at 'wet' sites with higher rainfall.
#       after two months of being left to interact with their environment, we returned to evaluate their performance
#I want to test the hypothesis that colonies at wet sites should capture more prey
#     Prey.Carcasses variable is defined as the number of prey items we recovered from their webs when we checked on them

# I want to scramble the response variable (Prey Carcasses)

spiders <- read.csv("Stego Mortality Main Data.csv")
names(spiders)
levels(spiders$Site_Type)

library(lmPerm)
library(ggplot2)
library(coin)
library(gtools)

# Attempting to repdroduce JD's example with counting colonies of ants in field vs forest setting:

set.seed(215)    # Philadelphia area code, easy to remember 
nsim <- 1000
res <- numeric(nsim)

# Now for the actual permutation:
for (i in 1:nsim) {
  perm <- sample(nrow(spiders))
  bdat <- transform(spiders,Site_Type=Site_Type[perm])
  ## compute & store difference in means; store the value
  res[i] <- mean(bdat[bdat$Site_Type=="Wet","Prey.Carcasses"])-
    mean(bdat[bdat$Site_Type=="Arid","Prey.Carcasses"])
}

obs <- mean(spiders[spiders$Site_Type=="Wet","Prey.Carcasses"])-
  mean(spiders[spiders$Site_Type=="Arid","Prey.Carcasses"])
## append the observed value to the list of results
res <- c(res,obs)

## Now histogramming the results:
hist(res,col="gray",las=1,main="")
abline(v=obs,col="red")

# I interpret these results to suggest that the observed differences of prey captured in colonies at arid versus wet sites 
#     is unlikely to be due to chance

## Now trying the same test using linear modeling and the lmp() command

summary(lmp(Prey.Carcasses~Site_Type,data=spiders))
## I don't know why it's giving 'Site_Type1' as the parameter, as opposed to Site_Type:Arid or Site_Type:Wet as it does when I use glmer() to test things 
## using:
levels(spiders$Site_Type)
## I see that my levels are properly labeled Arid vs. Wet
## Either way, the test once again suggests that there is a clearly-detectable difference in the number of prey items 
##      caught by colonies at wet versus arid sites. This is corroborated by looking at the raw numbers:

mean(spiders$Prey.Carcasses[spiders$Site_Type=="Arid"])
mean(spiders$Prey.Carcasses[spiders$Site_Type=="Wet"])

