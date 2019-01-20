library(tidyverse)
anoles <- read_csv("winchell_evol_phenshifts.csv")
## BMB: don't include (uncommented) str(), summary(), names() in submitted code
## 
str(anoles)
summary(anoles)        # Certain values here are being reported as characters (e.g. column 'context'; whether the
                       #    lizard was caught in a natural or urbanized area)
names(anoles)
anoles <- (anoles                      
           %>% mutate(ID=as.factor(ID),        
                      Site=as.factor(Site),    
                      context=as.factor(context),  
                      perch=as.factor(perch),    
                      perch.diam.cm=as.numeric(perch.diam.cm),
                      flags=as.factor(flags)))

## BMB: more compact
anoles <- (anoles
    %>% mutate_at(vars(Site,context,perch,flags),funs(factor))
    %>% mutate(perch.diam.cm=parse_number(perch.diam.cm))
)
## BMB: what are the elements equal to "wall" ???
##  is that an anole that was caught on a wall rather than a perch?
##  you need to decide what to do about this - how will you analyze
##  these cases?  (If nothing seems to make sense, you might need to
##  discard those cases when fitting models with perch diam)
print(anoles
      %>% group_by(Site,context)
      %>% summarize(count=n())) # Want to see if they have roughly equal natural versus urban representation at each study site

## BMB: or
anoles %>% count(Site,context) %>% spread(context,n)

## BMB: this works; can also use base R
with(anoles,table(Site,context))

print(ggplot(anoles, aes(x=bodytemp.C))
             +geom_histogram()
      )
## Reveals that we have a few anoles that are markedly colder than the others
## BMB: these don't look *too* small to me (if they had been 22 degrees ...)

print(ggplot(anoles, aes(x=svl.mm))
      +geom_histogram(binwidth=0.5)
      )
## Most lizards between 60-70mm Snout-Vent Length, handful of extreme outliers
## BMB: again, these don't look like "extreme outliers" to me ...

##  check `levels(anoles$perch)` (or use `unique()` for a character vector); it shows there's at least one typo in the data ("conctreete wall")
## where are all the NAs in the data coming from?
##
numvars <- anoles[sapply(anoles,is.numeric)]
pairs(numvars,pch=".",gap=0)
## last 13 variables (morphometrics?) are all positively correlated
pairs(numvars[1:10],pch=".",gap=0)
## see lack of resolution in perch temp measurements (whole degrees C
## from 22-34)
## an odd small cluster of large values in local.time.decimal
hist(anoles$local.time.decimal,breaks=30,col="gray")

## zooming in I see
env_vars <- select(numvars,perch.temp.C:perch.diam.cm,local.time.decimal)
morph_vars <- select(numvars,weight.g:svl.mm,JL:HL)
pairs(env_vars,pch=".",gap=0)                                 
pairs(morph_vars,pch=".",gap=0)

## score: 2.  I think you could have put more effort into
fac_vars <- anoles[sapply(anoles,is.factor)]
sapply(fac_vars,levels)

## What do you plan to do about collapsing your 24 different "perch" levels?
table(anoles$perch)
## there are lots of singletons,
library(forcats)
anoles$perch <- fct_rev(fct_infreq(anoles$perch))
library(ggplot2)
ggplot(anoles,aes(perch))+geom_bar()+coord_flip()
## you might need to boil it down to "tree" vs "not tree" ...

## BMB: 2. I think you could have worked harder at your exploration.
##  Even if you didn't know the R code, you could have described
## what you wanted to accomplish ...
