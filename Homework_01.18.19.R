library(tidyverse)
library(ggplot2)
anoles <- read_csv("winchell_evol_phenshifts.csv")
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

print(anoles
      %>% group_by(Site,context)
      %>% summarize(count=n())) # Want to see if they have roughly equal natural versus urban representation at each study site

print(ggplot(anoles, aes(x=bodytemp.C))
             +geom_histogram()
)                                       # Reveals that we have a few anoles that are markedly colder than the others

print(ggplot(anoles, aes(x=svl.mm))
      +geom_histogram(binwidth=0.5)
)                                       # Most lizards between 60-70mm Snout-Vent Length, handful of extreme outliers

