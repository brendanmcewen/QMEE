# QMEE
Class Repository

Homework from Wk 1 added on Jan 11 2019

JD: There was no description added for week 1, and the description for week 2 still doesn't meet the standards (a paragraph describing the data)

Homework from Wk 2: added on Jan 18. `summary(anoles)` revealed that many of the variables had been stored as characters instead of factors, so I changed them all to factors.
*BMB: this is as expected; tidyverse reading functions do this, because in general you don't want to convert variables to factor until they've been cleaned. It's also worth checking that the order of factors makes sense (i.e., don't use the default alphabetical order unless you've decided it's appropriate)*

I then inspected the distribution of body temperature at time of capture, and the distribution of Snout-Vent Length in these anoles. 

What I would like to do with my data is construct a model that allows me to predict the body temperature of a given lizard using data from its surroundings (i.e. whether it's in a natural or urban environment, what the ambient temperature is, what the humidity is, how high it's perched, etc.) 

Homework from Week 3:
My goal for this assignment is to:
  A. Visualize the relationship between individual body condition and thermal state (bodytemp.F) in a scatter plot
      Define body condition as each indiv's mass divided by their SVL 
      Use facets to display this between urban and natural environments
  B. Visualize body temperatures by substrate type (e.g. do lizards caught from a tree have diff. temp than if caught from a concrete substrate?)
      Will bin 'perch' elements into three categories and re-name as substrate: Tree, Concrete (collapse all concrete elements), and metal (collapse all metal elements). Entries of perch elements that do not fill these categories will be removed from the data. 
      Will construct box plots to visualize this. 
      
About these data: This dataset is not my own; I found it on Dryad. I just searched 'Anolis' and sorted by recent uploads to find some modern lizard data to see what types of data other scientists working with Anolis are collecting. I noticed that they included lots of thermal data, which piqued my interest in the potential effects that thermal state may have on lizard behavior. I would like to try my hand at creating a model predicting body temperature as a function of many environmental parameters. I could then potentially take this to the field and see if there's any relationship between observed Flight Initiation Distance and the body temperature predicted by whatever model I'm able to come up with. One could also examine the effect that individual differences in thermal state has on aggressive interactions; I would predict an individual at a higher thermal state to signal more aggressively, as they would be able to exert themselves more physically and would potentially incur less cost during a contest than they would at a comparatively lower thermal states. Although, if you have enough time to set up and observe an aggressive interaction, you would probably have enough time to capture and measure the body temperature of whatever lizard you were observing instead of relying on a model to approximate that for you 


*BMB: Why do you want to make these predictions? What larger biological question(s) does it address? How will the morphometric measurements be used?*
