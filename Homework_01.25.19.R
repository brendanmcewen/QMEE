library(tidyverse)
library(ggplot2)

## JD: It would be good to move the cleaning and reading elsewhere if you are happy with it so we can focus on the new stuff
## You can save and load an .RData file

anoles <- read_csv("winchell_evol_phenshifts.csv")

anoles <- anoles %>% mutate(bodytemp.F = (32 + 1.8*bodytemp.C))   ## Converting to Fahrenheit to help my brain

anoles <- (anoles
           %>% mutate_at(vars(Site,context,perch,flags),funs(factor)) ## Turning my character read-ins into factors
           %>% mutate(perch.diam.cm=parse_number(perch.diam.cm))
)

with(anoles, table(perch, context))  ## Want to see the total table of perch observations/categories, to see what I can collapse into tree/metal/concrete

levels(anoles$perch) <- list(tree=c("tree", "woody branch", "behind a sign on a tree", "bush"),             ## Collapsing perches into three main levels, discarding the rest
                             concrete=c("concrete", "concrete pos", "concrete wall", "conctreete wall"),
                             metal=c("metal", "metal fence", "metal fence post", "metal gate", "metal pipe", 
                                     "metal pole", "inside metal fence post"),
                             other="NA"
)        ## A more tidyverse-oriented way to do this would have been fct_collapse(tree="yadda", "yadda", "yadda") and repeat for concrete and metal 

anoles$perch[is.na(anoles$perch)] <- "other"     ## Need to substitute "other" for all the NAs that are in there from when I collapsed my perch levels


anoles %>% mutate(body.condition = (weight.g/svl.mm)*100)   ## This didn't create a new column in the dataframe like it did when I converted bodytemp.F from bodytemp.C
                                                            ## So I did it a non-tidyverse way:
anoles$body.condition <- (anoles$weight.g/anoles$svl.mm)*100  ## This more or less did what I wanted it to. 
## Should I still be using residual svl/mass to calculate this type of variable?

## Now on to the actual figure-making:

## Now that we have a body condition metric, I want to see whether lizards differ in their body condition based upon their natural/urban environment

## JD: I liked the green and gray, but you weren't consistent with it.
(condition_context_box <- ggplot(anoles, aes(context,body.condition, fill=context))+
  geom_boxplot()+
  scale_fill_manual(values=c("forestgreen","gray"))+           ## Want intuitive colors for my boxplot fills
  labs(x="Environmental Context", y="Body Condition", 
       title="Anole Body Condition in Urban vs. Natural Environments",
       fill="Context")+
  theme(panel.border = element_rect(fill=NA, color="black"),
          legend.title=element_text(size=11),                  ## Removing as much non-data ink as possible, while
          legend.position=c(0.85,0.8),                         ##    keeping the outline of the figure
          legend.text=element_text(size=11),
          panel.grid.major = element_blank(),
          axis.title.x = element_text(size=12),
          axis.text.x = element_text(size=11),
          axis.title.y = element_text(size=12),
          axis.text.y = element_text(size=11),
          panel.grid.minor = element_blank(),
          panel.background = element_rect(fill="white"))
) ## Nope, no real difference. There seems to be a bit more variation in urban environments but it's not enough to be interesting.

## Let's see the relationship between physical body condition and thermal state, split by urban vs natural context:
(condition_temp_fig <- ggplot(anoles, aes(x=body.condition, y=bodytemp.F))+
  geom_point()+
  geom_smooth(method=lm)+
  facet_grid(cols=vars(context))
)
## These relationships are uninspiring, but a slight negative relationship could potentially be explained by the fact that it's harder to heat larger objects up at a fixed energy input

## JD: What temp do you think they _want_?

## Let's see if higher mass of a lizard is associated with a greater perch diameter:
tree_anoles <- filter(anoles, perch == "tree") ## subsetting to only include lizards found on trees

(perch_mass_fig <- ggplot(tree_anoles, aes(weight.g, perch.diam.cm))+
  geom_point()+
  geom_smooth(method=lm)+
  facet_grid(cols=vars(context))
)      ## Once again, really nothing interesting going on, but we see a heavier concentration of small-diameter capture points in natural settings. How about I box-plot that?

(perch_diam_box <- ggplot(tree_anoles, aes(context, perch.diam.cm, fill=context))+
  geom_boxplot()
)

## JD: HOw many species are we talking about here? Are there other confounders to think about?

## I wonder if larger lizards are found closer or farther from the ground compared to small lizards? Larger lizards might perceive themselves safer in a given 
## environment than a smaller lizard would, thus I predict larger lizards to spend more time close to the ground (and thus be captured closer to the ground)
## This also yielded an uninspiring relationship. I'll just find ways to make my boring data more visually interesting
(perch_height_mass_fig <- ggplot(anoles, aes(weight.g, perch.height.cm, shape=Site, color=Site))+
  labs(x="Mass (g)", y="Perch Height (cm)",
       title="Anole Perch Height by Mass",
       shape="Site")+
  geom_point(aes(shape=factor(Site)))+
  facet_grid(cols=vars(context))+
  theme(panel.border = element_rect(fill=NA, color="black"),
          legend.title=element_text(size=11),                  ## Removing as much non-data ink as possible, while
          legend.position=c(0.8,0.8),                          ##    keeping the outline of the figure
          legend.text=element_text(size=11),
          panel.grid.major = element_blank(),
          axis.title.x = element_text(size=12),
          axis.text.x = element_text(size=11),
          axis.title.y = element_text(size=12),
          axis.text.y = element_text(size=11),
          panel.grid.minor = element_blank(),
          panel.background = element_rect(fill="white"))
)
## This is still a mess. How about looking at body temperature by substrate type?



(substrate_temp_fig <- ggplot(anoles, aes(perch,bodytemp.F,fill=perch))+
  geom_boxplot()+                                                                                                                
  labs(x="Substrate", y="Body Temperature (F)")+
  scale_x_discrete(labels=c("Tree","Concrete","Metal","Other"))+
  scale_fill_manual(values=c("forestgreen","grey95","lightsteelblue3","thistle")) 
)        ## It seems that lizards caught on concrete substrates tend to have a slightly higher internal temperature. This is odd as I would have predicted metal-dwelling lizards
         ## To be hotter, unless those hotter surfaces become intolerable and the lizards avoid them. 

## I keep getting error messages that I'm removing rows containing non-finite values. What could be the source of this?

## JD: Good job for worrying. I don't know the answer yet.
## If it were me, I would start with the parsing failures (readr is suggesting you run problems())
## ggplot is also report NAs; I don't know if those are somehow the cause of your non-finite values.

## Grade: good (2/3)
