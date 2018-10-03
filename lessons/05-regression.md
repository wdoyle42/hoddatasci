Using Regression for Prediction
================

Overview
--------

So far, we've been using just the simple mean to make predictions. Today, we'll continue using the simple mean to make predictions, but now in a complicated way. Before, when we calculated conditional means, we did so in certain "groupings" of variables. When we run linear regression, we no longer need to do so. Instead, linear regression allows us to calculate the conditional mean of the outcome at *every* value of the predictor. If the predictor takes on just a few values, then that's the number of conditional means that will be calculated. If the predictor is continuous and takes on a large number of values, we'll still be able to calculate the conditional mean at every one of those values.

The model we posit for regression is as follows:

*Y* = *β*<sub>0</sub> + *β*<sub>1</sub>*x*<sub>1</sub> + *β*<sub>2</sub>*x*<sub>2</sub> + ...*β*<sub>*k*</sub>*x*<sub>*k*</sub> + *ϵ*

It's just a linear, additive model. Y increases or decreases as a function of x, with multiple x's included. *ϵ* is the extent to which an individual value is above or below the line created.

Let's say that you've got some consumer data and you want to target those families that are likely to spend between $100 and $500 a month on dining out. We would need to be able to predict which families would spend in that range based on observable characteristics like family size, income and family type.

We're going to be working with expenditure data from the 2012 administration of the consumer expenditure survey. The first bit of code gets the libraries we need, the data we need, and opens up a codebook for the data.

    ## ── Attaching packages ────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.0.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.6
    ## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ── Conflicts ───────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

    ## 
    ## Attaching package: 'ModelMetrics'

    ## The following object is masked from 'package:base':
    ## 
    ##     kappa

Bivariate regression
--------------------

Our first dependent variable will be dining out. Let's take a look at that variable:

``` r
summary(cex$dine_out)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##     0.0    65.0   325.0   470.8   650.0  7800.0

``` r
gg<-ggplot(cex,aes(x=dine_out))
gg<-gg+geom_histogram()
gg
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](05-regression_files/figure-markdown_github/unnamed-chunk-2-1.png)

``` r
gg<-ggplot(cex,aes(x=dine_out))
gg<-gg+geom_density()
gg
```

![](05-regression_files/figure-markdown_github/unnamed-chunk-2-2.png)

Because this variable is pretty non-normally distributed, we may want to think about transforming it. For now, let's just work with it as-is. Let's see if people with bigger families spend more on dining out more than those with smaller families. Before, we would have calculated the conditional mean at every level of family size, or in certain groupings of family size. With regression, we simply specify the relationship.

``` r
#Model 1: simple bivariate regression

mod1<-lm(dine_out~fam_size,data=cex) #outcome on left, predictor on right 

summary(mod1)
```

    ## 
    ## Call:
    ## lm(formula = dine_out ~ fam_size, data = cex)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -685.2 -387.5 -153.7  158.7 7270.0 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  374.923     19.984  18.761  < 2e-16 ***
    ## fam_size      38.782      6.953   5.578 2.63e-08 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 596.4 on 3413 degrees of freedom
    ## Multiple R-squared:  0.009033,   Adjusted R-squared:  0.008743 
    ## F-statistic: 31.11 on 1 and 3413 DF,  p-value: 2.626e-08

``` r
confint(mod1)
```

    ##                 2.5 %    97.5 %
    ## (Intercept) 335.74139 414.10485
    ## fam_size     25.14935  52.41399

``` r
g1<-ggplot(cex, aes(x=fam_size,y=dine_out))+ #specify data and x and y
           geom_point(shape=1)+ #specify points
           geom_smooth(method=lm) #ask for lm line
g1
```

![](05-regression_files/figure-markdown_github/unnamed-chunk-3-1.png)

``` r
cex<-cex%>%mutate(pred1=predict(mod1)) #predict using data in memory
 
rmse_1<-with(cex, rmse(dine_out,pred1)) ; rmse_1
```

    ## [1] 596.1946

``` r
mod1b<-lm(dine_out~grocery_food,data=cex); summary(mod1b)
```

    ## 
    ## Call:
    ## lm(formula = dine_out ~ grocery_food, data = cex)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -2539.1  -347.3  -144.3   147.8  7367.3 
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  299.80177   17.81393   16.83   <2e-16 ***
    ## grocery_food   0.14609    0.01257   11.63   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 587.6 on 3413 degrees of freedom
    ## Multiple R-squared:  0.03809,    Adjusted R-squared:  0.03781 
    ## F-statistic: 135.2 on 1 and 3413 DF,  p-value: < 2.2e-16

``` r
cex<-cex%>%mutate(pred1b=predict(mod1b)) #predict using data in memory
 
rmse_1b<-with(cex, rmse(dine_out,pred1b)) ; rmse_1b
```

    ## [1] 587.3885

``` r
mod1a<-lm(dine_out~inclass,data=cex); summary(mod1a)
```

    ## 
    ## Call:
    ## lm(formula = dine_out ~ inclass, data = cex)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -776.6 -291.0 -126.6  157.3 7023.4 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) 233.2727    48.2887   4.831 1.42e-06 ***
    ## inclass02   -43.2665    65.2345  -0.663  0.50722    
    ## inclass03   -61.5216    60.6292  -1.015  0.31031    
    ## inclass04    -0.5771    60.5810  -0.010  0.99240    
    ## inclass05    57.7510    56.0517   1.030  0.30294    
    ## inclass06    91.7693    56.5153   1.624  0.10451    
    ## inclass07   190.3639    57.3384   3.320  0.00091 ***
    ## inclass08   237.6704    54.1787   4.387 1.19e-05 ***
    ## inclass09   543.3264    51.1165  10.629  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 554.8 on 3406 degrees of freedom
    ## Multiple R-squared:  0.1441, Adjusted R-squared:  0.1421 
    ## F-statistic:  71.7 on 8 and 3406 DF,  p-value: < 2.2e-16

What this shows is that as family size increases, the amount spent on dining out increases. For every additional family member, an additional $39 is predicted to be spent on dining out. The rmse of 596 gives us a sense of how wrong the model tends to be when using just this one predictor.

*Quick Exercise* Run a regression using a different predictor. Calculate rmse and see if you can beat my score.

Multiple Regression.
--------------------

Okay, so we can see that this is somewhat predictive, but we can do better. Let's add in a second variable: whether or not the family is below the poverty line.

``` r
#Part 2: Multiple regression

mod2<-lm(dine_out~fam_size+
           pov_cym, #can only take on two values
          data=cex)

summary(mod2) 
```

    ## 
    ## Call:
    ## lm(formula = dine_out ~ fam_size + pov_cym, data = cex)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -708.8 -342.8 -147.8  146.5 7228.0 
    ## 
    ## Coefficients:
    ##                       Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            120.006     29.793   4.028 5.75e-05 ***
    ## fam_size                34.211      6.838   5.003 5.92e-07 ***
    ## pov_cymNot in Poverty  315.118     27.717  11.369  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 585.5 on 3412 degrees of freedom
    ## Multiple R-squared:  0.0452, Adjusted R-squared:  0.04464 
    ## F-statistic: 80.77 on 2 and 3412 DF,  p-value: < 2.2e-16

``` r
cex<-cex%>%mutate(pred2=predict(mod2))

rmse_2<-with(cex,rmse(dine_out,pred2));rmse_2
```

    ## [1] 585.2126

So, those who are in poverty spend less on dining out. Alert the media!

*Quick Exercise* Add another variable to your model from above and see what difference it makes. How is your RMSE?

Maybe it's the case that those who spend more on groceries dine out less. Let's find out:

``` r
#Model 3: predicting dining out using other variables and grocery spending

mod3<-lm(dine_out~
           fam_size+
           pov_cym+
           grocery,
           data=cex)

summary(mod3)
```

    ## 
    ## Call:
    ## lm(formula = dine_out ~ fam_size + pov_cym + grocery, data = cex)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -2660.1  -330.5  -130.0   146.1  7312.7 
    ## 
    ## Coefficients:
    ##                        Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            70.66068   29.54978   2.391   0.0168 *  
    ## fam_size               -5.33426    7.54028  -0.707   0.4793    
    ## pov_cymNot in Poverty 266.92307   27.52001   9.699   <2e-16 ***
    ## grocery                 0.13158    0.01145  11.496   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 574.5 on 3411 degrees of freedom
    ## Multiple R-squared:  0.08082,    Adjusted R-squared:  0.08001 
    ## F-statistic: 99.97 on 3 and 3411 DF,  p-value: < 2.2e-16

``` r
g2<-ggplot(cex, aes(x=grocery,y=dine_out))+
           geom_point(shape=1)+ 
           geom_smooth(method=lm)
g2
```

![](05-regression_files/figure-markdown_github/unnamed-chunk-5-1.png)

``` r
cex<-cex%>%mutate(pred3=predict(mod3))

rmse_3<-with(cex,rmse(dine_out,pred3));rmse_3
```

    ## [1] 574.1947

Hmm, what happened here?

*Quick Exercise* Use a subset of the cex data with reasonable bounds on both dining out and grocery expenditures. See if the results hold.

Transformations
---------------

The big issue as you can see with this data is that the outcome variable isn't normally distributed: most people spend very little on dining out, while some people spend quite a lot. In situations like this, which are VERY common when dealing with monetary values, we want to take the natural log of the outcome variable. A natural log is the power by which we would have to raise *e*, Euler's constant, to be that value: *e*<sup>*l**n*(*x*)</sup> = *x*, or *l**n*(*e*<sup>*x*</sup>)=*x*.

Economists just basically take the natural log of everything that's denominated in dollar terms, which you probably should do as well. You'll notice in the equations below that I specify the `log()` of both dining out and grocery spending. The log transform won't work with values of 0, so the transformation also includes a `+1` to add a dollar to each 0.

``` r
gg<-ggplot(cex,aes(x=log(dine_out+1)))
gg<-gg+geom_density()
gg
```

![](05-regression_files/figure-markdown_github/unnamed-chunk-6-1.png)

``` r
#Part 4: Working with transformations
mod4<-lm(log(dine_out+1)~ #log of dining out, plus one for zeros
           +log(grocery+1)+ #log of groceries, plus one again
           pov_cym+ #poverty
           fam_size #family size
         ,data=cex, na.action = "na.exclude")


summary(mod4)
```

    ## 
    ## Call:
    ## lm(formula = log(dine_out + 1) ~ +log(grocery + 1) + pov_cym + 
    ##     fam_size, data = cex, na.action = "na.exclude")
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -5.8100 -0.4122  0.9059  1.6076  7.0998 
    ## 
    ## Coefficients:
    ##                       Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            0.48699    0.31567   1.543    0.123    
    ## log(grocery + 1)       0.41758    0.04859   8.594   <2e-16 ***
    ## pov_cymNot in Poverty  1.55914    0.12081  12.906   <2e-16 ***
    ## fam_size              -0.01071    0.03181  -0.337    0.736    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2.5 on 3411 degrees of freedom
    ## Multiple R-squared:  0.08441,    Adjusted R-squared:  0.08361 
    ## F-statistic: 104.8 on 3 and 3411 DF,  p-value: < 2.2e-16

``` r
cex<-cex%>%mutate(pred4=predict(mod4))

## Use modelr:: rmse to get predictions
rmsle_4<-modelr::rmse(mod4,cex)

## get just the data needed to calculate rmse
rmse_4_data<-cex%>%
  select(dine_out,pred4)%>%
  filter(!is.na(pred4))%>%
  mutate(pred4=exp(pred4))

rmse_4<-ModelMetrics::rmse(rmse_4_data$dine_out,rmse_4_data$pred4); rmse_4
```

    ## [1] 675.5858

``` r
g4<-ggplot(cex, aes(x=grocery,y=exp(pred4),color=pov_cym))
g4<-g4+geom_point(shape=1)
g4
```

![](05-regression_files/figure-markdown_github/unnamed-chunk-6-2.png)

``` r
# Function defined by coefficients

fun_mod4<-function(x) exp(mod4$coefficients[1]+ 
                            ## This coeff will be allowed to vary
                          (mod4$coefficients[2]*log(x+1))+
                          (mod4$coefficients[3]*1)+
                          (mod4$coefficients[4]*mean(cex$fam_size,na.rm=TRUE))  
                          ) 

g4a<-ggplot(cex,aes(x=grocery,y=dine_out))
g4a<-g4a+geom_point(alpha=.1,size=.1)
g4a<-g4a+stat_function(fun = fun_mod4,color="blue")+xlim(0,2000)+ylim(0,1000)
g4a
```

    ## Warning: Removed 875 rows containing missing values (geom_point).

![](05-regression_files/figure-markdown_github/unnamed-chunk-6-3.png)

``` r
#Part 5: Adding income 
mod5<-lm(log(dine_out+1)~
           +log(grocery+1)+
           pov_cym+
           fam_size+
           inclass
         ,data=cex,na.action="na.exclude");summary(mod5)
```

    ## 
    ## Call:
    ## lm(formula = log(dine_out + 1) ~ +log(grocery + 1) + pov_cym + 
    ##     fam_size + inclass, data = cex, na.action = "na.exclude")
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -6.2587 -0.6162  0.7778  1.5819  6.0125 
    ## 
    ## Coefficients:
    ##                       Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            1.73323    0.34799   4.981 6.65e-07 ***
    ## log(grocery + 1)       0.27470    0.04790   5.735 1.06e-08 ***
    ## pov_cymNot in Poverty  0.07074    0.21332   0.332 0.740222    
    ## fam_size              -0.16963    0.03293  -5.151 2.74e-07 ***
    ## inclass02              0.04806    0.28333   0.170 0.865312    
    ## inclass03             -0.24023    0.27920  -0.860 0.389629    
    ## inclass04              0.24336    0.31001   0.785 0.432510    
    ## inclass05              0.72180    0.31410   2.298 0.021623 *  
    ## inclass06              1.14794    0.33113   3.467 0.000533 ***
    ## inclass07              1.44888    0.33808   4.286 1.87e-05 ***
    ## inclass08              1.71901    0.33004   5.208 2.02e-07 ***
    ## inclass09              2.52253    0.32493   7.763 1.09e-14 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2.407 on 3403 degrees of freedom
    ## Multiple R-squared:  0.1537, Adjusted R-squared:  0.151 
    ## F-statistic: 56.19 on 11 and 3403 DF,  p-value: < 2.2e-16

``` r
cex<-cex%>%mutate(pred5=predict(mod5))

rmsle_5<-modelr::rmse(mod5,cex)

## get just the data needed to calculate rmse
rmse_5_data<-cex%>%
  select(dine_out,pred5)%>%
  filter(!is.na(pred5))%>%
  mutate(pred5=exp(pred5))

rmse_5<-ModelMetrics::rmse(rmse_5_data$dine_out,rmse_5_data$pred5); rmse_5
```

    ## [1] 634.8595

``` r
## Use log transform to plot
g5<-ggplot(cex, aes(x=inclass,y=(dine_out+1),group=1))+
           geom_point(shape=1)+
           geom_smooth(method=lm)+
          scale_y_continuous(trans="log")
g5
```

![](05-regression_files/figure-markdown_github/unnamed-chunk-7-1.png)

Testing and Training
--------------------

The essence of prediction is discovering the extent to which our models can predict outcomes for data that *does not come from our sample*. Many times this process is temporal. We fit a model to data from one time period, then take predictors from a subsequent time period to come up with a prediction in the future. For instance, we might use data on team performance to predict the likely winners and losers for upcoming soccer games.

This process does not have to be temporal. We can also have data that is out of sample because it hadn't yet been collected when our first data was collected, or we can also have data that is out of sample because we designated it as out of sample.

The data that is used to generate our predictions is known as *training* data. The idea is that this is the data used to train our model, to let it know what the relationship is between our predictors and our outcome. So far, we have only worked with training data.

That data that is used to validate our predictions is known as *testing* data. With testing data, we take our trained model and see how good it is at predicting outcomes using out of sample data.

One very simple approach to this would be to cut our data in half. We could then train our model on half the data, then test it on the other half. This would tell us whether our measure of model fit (e.g. rmse, auc) is similar or different when we apply our model to out of sample data. That's what we've done today: we have only been working with half of our data.

Model 5 is looking pretty good, but let's see how it does using our testing data-- the half that wasn't used to train our model.

``` r
## Generate a prediction from the testing dataset
cex_test<-cex_test%>%mutate(pred5=predict(mod5,newdata=cex_test))

## What is this really doing? 

cex_line<-cex_test[1,c("grocery","pov_cym","fam_size","inclass")]

cex_test_line<-c(1, #intercept,
                 log(cex_test$grocery[1]+1),
                 0, #poverty,
                 cex_test$fam_size[1],
                 1 #income class 8
                 )

mod5$coefficients
```

    ##           (Intercept)      log(grocery + 1) pov_cymNot in Poverty 
    ##            1.73323433            0.27469698            0.07073547 
    ##              fam_size             inclass02             inclass03 
    ##           -0.16963150            0.04806103           -0.24022698 
    ##             inclass04             inclass05             inclass06 
    ##            0.24335849            0.72179982            1.14793773 
    ##             inclass07             inclass08             inclass09 
    ##            1.44887617            1.71901423            2.52253292

``` r
cex_coeff<-as.double(mod5$coefficients[c(1:4,11)]);cex_coeff;cex_test_line          
```

    ## [1]  1.73323433  0.27469698  0.07073547 -0.16963150  1.71901423

    ## [1] 1.000000 7.576097 0.000000 4.000000 1.000000

``` r
#multiply coeffs by values and sum everythig up
cex_predict<-sum(cex_test_line%*%cex_coeff);cex_predict
```

    ## [1] 4.854854

``` r
r_predict<-(predict(mod5,newdata = cex_test[1,]));r_predict
```

    ##        1 
    ## 4.925589

``` r
## Comparing test and training rmse

rmsle_5_test<-modelr::rmse(mod5,cex_test)

rmsle_5;rmsle_5_test
```

    ## [1] 2.402563

    ## [1] 2.4392

Why is the value from the testing dataset larger?

*Quick exercise*

What's the rmse for your model when comparing it with the testing data?

Regression using a binary outcome
---------------------------------

You can also run a regression using a binary variable. Let's recode and then use our cigarettes variable to look at predictors of buying any cigarretes at all.

``` r
cex$cigs<-0
cex$cigs[cex$cigarettes>0]<-1

mod6<-lm(cigs~educ_ref+
           as.factor(ref_race)+
           inc_rank+
           as.factor(sex_ref),
         data=cex)

summary(mod6)
```

    ## 
    ## Call:
    ## lm(formula = cigs ~ educ_ref + as.factor(ref_race) + inc_rank + 
    ##     as.factor(sex_ref), data = cex)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.37129 -0.22989 -0.16565 -0.05444  0.97687 
    ## 
    ## Coefficients:
    ##                      Estimate Std. Error t value Pr(>|t|)  
    ## (Intercept)           0.21393    0.15376   1.391   0.1642  
    ## educ_ref10           -0.01112    0.15677  -0.071   0.9435  
    ## educ_ref11            0.07291    0.15533   0.469   0.6388  
    ## educ_ref12            0.06570    0.15429   0.426   0.6703  
    ## educ_ref13            0.05292    0.15446   0.343   0.7319  
    ## educ_ref14            0.02716    0.15536   0.175   0.8613  
    ## educ_ref15           -0.07809    0.15467  -0.505   0.6137  
    ## educ_ref16           -0.10769    0.15597  -0.690   0.4900  
    ## educ_ref17           -0.11284    0.15985  -0.706   0.4803  
    ## as.factor(ref_race)2 -0.03669    0.02154  -1.704   0.0886 .
    ## as.factor(ref_race)3  0.05968    0.09165   0.651   0.5150  
    ## as.factor(ref_race)4 -0.07175    0.03440  -2.086   0.0371 *
    ## as.factor(ref_race)5  0.10601    0.12547   0.845   0.3982  
    ## as.factor(ref_race)6 -0.09305    0.06154  -1.512   0.1306  
    ## inc_rank             -0.04265    0.02723  -1.566   0.1174  
    ## as.factor(sex_ref)2  -0.02916    0.01430  -2.039   0.0415 *
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.375 on 2821 degrees of freedom
    ##   (578 observations deleted due to missingness)
    ## Multiple R-squared:  0.04147,    Adjusted R-squared:  0.03637 
    ## F-statistic: 8.136 on 15 and 2821 DF,  p-value: < 2.2e-16

``` r
g4<-ggplot(cex,aes(x=fam_type,y=cigs,group=1))+
  geom_jitter(alpha=.1)

g4
```

![](05-regression_files/figure-markdown_github/unnamed-chunk-9-1.png)

Thinking about regression for prediction
----------------------------------------

You MUST remember: correlation is not causation. All you can pick up on using this tool is associations, or common patterns. You can't know whether one thing causes another. Remember that the left hand side variable could just as easily be on the right hand side.
