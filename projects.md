Using the anole dataset from Dryad, we could first investigate whether there appears to be a hot-spot effect (increased temperatures in urban areas) present at any or all of the three sites used in the study. This would probably be achievable with a model that investigates the effect of context on temperature at each site, while controlling for the time of day. If there's an effect 

BMB: **be careful here**. You shouldn't make analysis decisions based on p-values, and don't make the mistake of assuming that two things are different if one is statistically significant and the other isn't! Gelman and Stern (2006)

we could see if there’s a difference in body temperatures in the lizards caught (i.e. lizards themselves in urban contexts are at hotter thermal state). If there is a hotspot effect but the lizards themselves are **not** warmer

BMB: see previous comment. This is exactly "sig" vs "nonsig"

then that might suggest that they engage in thermoregulatory behavior that keeps them at a more suitable thermal state. This is pretty basic, almost all ectotherms thermoregulate to maintain an optimum thermal state, but might be cool to quantify for ourselves.

BMB: it's interesting to try to set this up in a way that's statistically kosher.  I think what you are interested in is whether lizard temperatures respond statistically *less* to temperature than expected based on the context they're in? Or maybe just asking whether the slope of lizard temperature on env temperature is <1?

Then the second half of this that we could look at is the whole femur length thing: Do lizards in novel, urbanized habitats have longer limbs relative to their body? Perhaps this new environment with more uniform surfaces (pavement, flat green space e.g. parks) favors longer limbs that enable higher sprint speeds. 

BMB: this is indeed interesting (and fairly straightforward).  You could do a full multivariate analysis on log-transformed lengths and see more generally how the allometry changes across habitats (i.e., not look at femur length alone ...)

Gelman, Andrew, and Hal Stern. “The Difference Between ‘Significant’ and ‘Not Significant’ Is Not Itself Statistically Significant.” The American Statistician 60, no. 4 (November 2006): 328–31. https://doi.org/10.1198/000313006X152649.
