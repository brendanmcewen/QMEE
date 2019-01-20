# QMEE
Class Repository

Homework from Wk 1 added on Jan 11 2019

Homework from Wk 2: added on Jan 18. `summary(anoles)` revealed that many of the variables had been stored as characters instead of factors, so I changed them all to factors.
*BMB: this is as expected; tidyverse reading functions do this, because in general you don't want to convert variables to factor until they've been cleaned. It's also worth checking that the order of factors makes sense (i.e., don't use the default alphabetical order unless you've decided it's appropriate)*

I then inspected the distribution of body temperature at time of capture, and the distribution of Snout-Vent Length in these anoles. 

What I would like to do with my data is construct a model that allows me to predict the body temperature of a given lizard using data from its surroundings (i.e. whether it's in a natural or urban environment, what the ambient temperature is, what the humidity is, how high it's perched, etc.)

*BMB: Why do you want to make these predictions? What larger biological question(s) does it address? How will the morphometric measurements be used?*
