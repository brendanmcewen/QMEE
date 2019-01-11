install.packages("tidyverse")       ## For some reason my computer couldn't find the tidyverse package, so I had
                                    ## to re-download it

library(tidyverse)

crist <- read_csv("winchell_evol_phenshifts.csv") ## Basic phenotypic/environmental (body temperature, humidity, etc.) data
                                                  ## taken at Anole capture events in urban vs natural habitats

crist            ## Checking to make sure it loaded correctly (it did)

names(crist)     ## Checking my column names

## I'm American, so my brain wants me to convert their body temperatures to Farenheight so that I can more easily tell
## what their thermal state is. After their body temperature data is in Farenheight, I want to know what the mean 
## body temperature was in all of these anoles at the time of their capture

crist %>% mutate(bodytemp.F = (32 + 1.8*bodytemp.C))%>%
          filter(!is.na(bodytemp.F))%>%
          summarise(bodytemp.F_mean=mean(bodytemp.F))

# A tibble: 1 x 1
# bodytemp.F_mean
# <dbl>
#   1            88.1

# Of all capture events that included body temperature data, the mean body temperature was 88.1 degrees Farenheight.