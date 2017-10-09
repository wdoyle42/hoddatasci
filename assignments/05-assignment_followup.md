Assignment 5 Followup
================

Assignment 5
------------

In this assignment, you'll be asked to predict two related items: first, who spends ANY money on cigarettes, according to the CEX. Second, how much do they spend? You'll need to do a few things.

1.  Create a binary variable that's set to 1 if the household spent any money on cigarettes and 0 otherwise.

``` r
library(tidyverse)
```

    ## Loading tidyverse: ggplot2
    ## Loading tidyverse: tibble
    ## Loading tidyverse: tidyr
    ## Loading tidyverse: readr
    ## Loading tidyverse: purrr
    ## Loading tidyverse: dplyr

    ## Conflicts with tidy packages ----------------------------------------------

    ## filter(): dplyr, stats
    ## lag():    dplyr, stats

``` r
library(forcats)
library(ModelMetrics)
load("../lessons/cex.Rdata")
#binary variable for cigarette purchases
cex<-cex%>%mutate(any_cig=ifelse(is.na(cigarettes),0,1))

#Povery recode
cex<-cex%>%mutate(pov_cym=ifelse(pov_cym=="",NA,pov_cym))
cex<-cex%>%mutate(pov_cym=fct_recode(as.factor(pov_cym),
                                     "In Poverty"="2",
                                     "Not in Poverty"="3"))
cex<-filter(cex,is.na(pov_cym)==FALSE)

#Testing/training

# Get half of the data via random sample
cex_train<-sample_frac(cex,.5)

save(cex_train,file="cex_train.Rdata")

## Testing data is the other half of the data--- the half of cex not in the 
##training dataset

cex_test<-setdiff(cex,cex_train)

save(cex_test,file="cex_test.Rdata")
##---------------------------------------
```

1.  Create a model that predicts this variable.

``` r
mod_any_cig<-lm(any_cig~
                  inclass+
                  as.factor(educ_ref)+
                  as.factor(ref_race)+
                  as.factor(sex_ref),
                  data=cex_train)
summary(mod_any_cig)
```

    ## 
    ## Call:
    ## lm(formula = any_cig ~ inclass + as.factor(educ_ref) + as.factor(ref_race) + 
    ##     as.factor(sex_ref), data = cex_train)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.48241 -0.21162 -0.14284 -0.06758  0.98788 
    ## 
    ## Coefficients:
    ##                        Estimate Std. Error t value Pr(>|t|)   
    ## (Intercept)            0.426471   0.133750   3.189  0.00144 **
    ## inclass02             -0.055014   0.043036  -1.278  0.20122   
    ## inclass03             -0.017212   0.040175  -0.428  0.66838   
    ## inclass04             -0.024118   0.039924  -0.604  0.54582   
    ## inclass05             -0.035505   0.037183  -0.955  0.33971   
    ## inclass06             -0.006305   0.036983  -0.170  0.86463   
    ## inclass07             -0.042203   0.038024  -1.110  0.26712   
    ## inclass08             -0.009155   0.035879  -0.255  0.79862   
    ## inclass09             -0.037622   0.034260  -1.098  0.27222   
    ## as.factor(educ_ref)10 -0.246012   0.133826  -1.838  0.06611 . 
    ## as.factor(educ_ref)11 -0.124913   0.132776  -0.941  0.34689   
    ## as.factor(educ_ref)12 -0.134575   0.131742  -1.022  0.30709   
    ## as.factor(educ_ref)13 -0.207843   0.131861  -1.576  0.11507   
    ## as.factor(educ_ref)14 -0.189260   0.132690  -1.426  0.15386   
    ## as.factor(educ_ref)15 -0.282491   0.131960  -2.141  0.03237 * 
    ## as.factor(educ_ref)16 -0.321269   0.133203  -2.412  0.01592 * 
    ## as.factor(educ_ref)17 -0.297580   0.136157  -2.186  0.02892 * 
    ## as.factor(ref_race)2  -0.023318   0.018814  -1.239  0.21529   
    ## as.factor(ref_race)3   0.204970   0.087310   2.348  0.01895 * 
    ## as.factor(ref_race)4  -0.038071   0.029365  -1.296  0.19491   
    ## as.factor(ref_race)5   0.021200   0.111527   0.190  0.84925   
    ## as.factor(ref_race)6  -0.030802   0.052139  -0.591  0.55471   
    ## as.factor(sex_ref)2   -0.030650   0.012782  -2.398  0.01654 * 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.3679 on 3389 degrees of freedom
    ## Multiple R-squared:  0.03923,    Adjusted R-squared:  0.03299 
    ## F-statistic:  6.29 on 22 and 3389 DF,  p-value: < 2.2e-16

1.  When you're done, write some comments regarding why you think this model is a good one (write this up in paragraph form, using your finely-honed writing skills). According to this model, who spends any money at all on cigarettes?

*White men with low levels of education*

1.  Create a subset of the data that only includes people who spent something (more than 0) on cigarettes.

``` r
cex_cigs_train<-filter(cex_train,any_cig==1)
cex_cigs_test<-filter(cex_test,any_cig==1)
```

1.  Using this subset of the data, predict spending on cigarettes among the group who spent more than 0.

``` r
cigs_spend_mod<-lm(log(cigarettes)~
                  inclass+
                  as.factor(educ_ref)+
                  as.factor(ref_race)+
                  as.factor(sex_ref),
                  data=cex_cigs_train)
summary(cigs_spend_mod)
```

    ## 
    ## Call:
    ## lm(formula = log(cigarettes) ~ inclass + as.factor(educ_ref) + 
    ##     as.factor(ref_race) + as.factor(sex_ref), data = cex_cigs_train)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -2.88309 -0.43620  0.07709  0.50515  1.69819 
    ## 
    ## Coefficients:
    ##                       Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            6.01113    0.47739  12.592  < 2e-16 ***
    ## inclass02             -0.09123    0.20838  -0.438  0.66170    
    ## inclass03              0.11308    0.18543   0.610  0.54223    
    ## inclass04              0.33590    0.18554   1.810  0.07077 .  
    ## inclass05              0.32779    0.17442   1.879  0.06073 .  
    ## inclass06              0.24235    0.17003   1.425  0.15461    
    ## inclass07              0.47724    0.18082   2.639  0.00854 ** 
    ## inclass08              0.37510    0.16553   2.266  0.02383 *  
    ## inclass09              0.39082    0.16007   2.442  0.01494 *  
    ## as.factor(educ_ref)10 -0.67734    0.47585  -1.423  0.15518    
    ## as.factor(educ_ref)11 -0.37827    0.46070  -0.821  0.41195    
    ## as.factor(educ_ref)12 -0.43013    0.45412  -0.947  0.34397    
    ## as.factor(educ_ref)13 -0.43513    0.45749  -0.951  0.34196    
    ## as.factor(educ_ref)14 -0.67754    0.46233  -1.466  0.14335    
    ## as.factor(educ_ref)15 -0.50788    0.46220  -1.099  0.27232    
    ## as.factor(educ_ref)16 -0.65734    0.49440  -1.330  0.18421    
    ## as.factor(educ_ref)17 -1.09741    0.52627  -2.085  0.03751 *  
    ## as.factor(ref_race)2  -0.26219    0.09688  -2.706  0.00701 ** 
    ## as.factor(ref_race)3  -0.45818    0.29990  -1.528  0.12715    
    ## as.factor(ref_race)4  -0.24824    0.18051  -1.375  0.16963    
    ## as.factor(ref_race)5   0.59161    0.54958   1.076  0.28218    
    ## as.factor(ref_race)6  -0.13397    0.29654  -0.452  0.65161    
    ## as.factor(sex_ref)2   -0.01417    0.06647  -0.213  0.83123    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.7678 on 551 degrees of freedom
    ## Multiple R-squared:  0.08514,    Adjusted R-squared:  0.04862 
    ## F-statistic: 2.331 on 22 and 551 DF,  p-value: 0.0006025

1.  Make some equally well-written comments regarding which variables predict expenditures on cigarettes among people who smoke (or at least buy cigarettes).

*White men with low levels of education*

1.  Calculate the rmse for your model agains the testing version of this data.

``` r
cigs_predict<-predict(cigs_spend_mod,newdata=cex_cigs_test)
exp(rmse(cigs_predict,log(cex_cigs_test$cigarettes)))
```

    ## [1] 2.209721
