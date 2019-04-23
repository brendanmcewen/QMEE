For our project we invesitaged the effects of urbanization on the Puerto Rican Crested Anole.
We used data collected by Kristin Winchell, which was published in Winchell et al. 2016 (Evolution). Winchell and her team visited three different sites in Puerto Rico that had both urbanized and natural areas. They sampled Crested Anoles in each location and used a variety of methods (including a super-cool portable x-ray!) to obtain environmental and morphometric data for their lizards and their associated microhabitat. Winchell et al. described shifts in limb morphology that they interpreted to be due to the novel environment's substrates that were different from those in natural habitats. Our project sought to explore this by both attempting to replicating their analyses and by utilizing some statistical techniques not present in their publication. 

Our first set of analyses are exploratory/descriptive. We were interested in how the substrates available in urban areas differ from the natural settings in which these lizards evolved. We found that lizards in urban habitats do indeed interact with different substrate materials, utilizing perches made from concrete and metal frequently. 

The second part of our exploring the urban environment involved looking at thermal differences between the two areas. Ambient, substrate, and lizard body temperatures were higher at urban environments. Because temperature has a non-linear releationship with time, we couldn't run a simple linear model and get reliable results. We took JD's suggestion of creating Time Components using the sin and cosin components of the time cycle. We created a linear model using those components and the 'context' (urbanization) as predictor variables for the temperature responses. Using this correction for non-linearity, we still observed clear differences in thermal states across habitat types.

Using Ben's suggestion in our presentation marking notes, we also constructed a GAM using time of day as a smoothing component. Once again, we still observe clear differences across habitat types. It seems as if these urban habitats do truly exhibit the 'hotspot' effects that we've come to associate with urbanization.


Once we had some basic descriptive stuff tacked down for the environmental variables, we thought it would be informative to perform a PCA on these data. We first constructed a PCA to examine the Abiotic factors of the environments (i.e. thermal properties).
We then constructed a second PCA to examine the biotic responses, namely morphometrics of the lizards. We found that sites differed in PC1 for both of these PCAs, corroborating both our past and forthcoming findings. It should be noted that the Abiotic PCA (eg. thermal) does not account for the effect of time of day.

Once we finished with the biotic response (morphometric) PCA, we thought it would be useful to attempt to reproduce Winchell et al.'s analysis. Their paper examined the morphometric response variables in the form of single-trait ANCOVA. We successfully replicated their analysis, finding that the six main limb components (radius, ulna, humerus, femur, tibia, fibula) were all longer at urban sites even after accounting for differences in Snout-Vent Length. 

Per Ben's suggestions, we then performed a multivariate analysis on these morphometric responses. Using the lm() method described in Ian Dworkin's module, our MANCOVA found clear differences in the limb components across habitat types. We remembered that Ian mentioned the lm() method was a bit data-hungry, so we used the permutation-based procD.lm() method as well and achieved a similar result. The only thing that didn't go smoothly with these analyses was an inconsistency in R-squared values obtained through the different methods Ian described in his lecture. We are unsure of how to troubleshoot this. 

All in all, our results suggest that Crested Anoles are indeed undergoing adaptation to their new urban environments. Future data that we might like to obtain would be reproductive output - are these lizards reproducing more or less in urbanized areas? We would also be interested in obtaining some physiological data regarding potential heat stress they may be experiencing in their new hotter habitats. 

Thanks very much for an informative and fun course!

Sincerely,
Brendan and Hossein