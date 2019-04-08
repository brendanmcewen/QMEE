## comments on presentation

### bmb

- For the bar plots of counts: consider a `geom_pointrange()` with confidence intervals ...


```
get_binCI <- function(x,n) {
    rbind(setNames(c(binom.test(x,n)$conf.int),c("lwr","upr")))
}
get_poissCI <- function(x) {
    rbind(setNames(c(poisson.test(x)$conf.int),c("lwr","upr")))
}
... %>% rowwise() %>% do(get_binCI(.$x,.$total))
... %>% rowwise() %>% do(get_poissCI(.$x))
```
where `x` is the name of the variable (count of successes or number of lizards)

- the t-test you did is for overall difference, ignoring the time of day. If you're going to do this test you could add a point + pointrange (at arbitrary x-locations) to the graph. Or, you could do a more sophisticated test. You could use a GAM (`library("mgcv"); temp ~ habitat + s(time, by=habitat)`) to test this, *or* a quadratic model (although computing the difference in peak times would take some extra work ...)
- I like the PCA. You might to want to test for differences in *variability* between the two sites?
- you can try `notch=TRUE` in the boxplots to get approximate CIs on the median
- you can do a bunch of univariate plots like this (using `reshape2::melt()`, `tidyr::gather()` would also work): this is with the "lizards" data set
```{r}
mliz <- melt(lizards,id.vars="grahami",measure.vars=c("height","diameter","light","time"))
ggplot(mliz,aes(x=value,y=grahami))+geom_boxplot(,fill="lightgray")+
  facet_wrap(~variable,scale="free_x",nrow=1)+
  geom_hline(yintercept=mean(lizards$grahami),colour="red",lwd=1,alpha=0.4)
```
- cross-correlation analysis (as I suggested) might be better for patterns that vary a lot: if there's a relatively simple monotonic pattern (as in the temp pictures you showed), I might try GAMs or quadratic regressions as described above (although it won't give a time lag as directly)
- I'd definitely recommend a multivariate approach to the morphology/habitat comparison
