Basic Classiciation Code
================

Libraries
---------

``` r
library(arm)
```

    ## Loading required package: MASS

    ## Loading required package: Matrix

    ## Loading required package: lme4

    ## 
    ## arm (Version 1.10-1, built: 2018-4-12)

    ## Working directory is /Users/doylewr/hoddatasci_fall18/lessons

``` r
library(AUC)
```

    ## AUC 0.3.0

    ## Type AUCNews() to see the change log and ?AUC to get an overview.

``` r
library(modelr)
library(tidyverse)
```

    ## ── Attaching packages ───────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.1.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.7
    ## ✔ tidyr   0.8.2     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ── Conflicts ──────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ tidyr::expand() masks Matrix::expand()
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ✖ dplyr::select() masks MASS::select()

Load data
---------

``` r
load("za_train.Rdata")
load("za_test.Rdata")
```

Run a model
-----------

``` r
logit_mod<-glm(got_pizza~
              raop_posts+
              score+
                student+
                grateful,
              data=za_train,
              family=binomial(link="logit")
)
```

Run predictions on test data
----------------------------

``` r
za_test<-za_test%>%add_predictions(logit_mod)%>%
  mutate(pred=arm::invlogit(pred)) ## This transforms to probs
```

Calculate ROC for predictions (both sensitivity AND specificty)

``` r
logit_roc<-roc(za_test$pred,
               as.factor(za_test$got_pizza))
```

calculate AUC
-------------

``` r
auc(logit_roc)
```

    ## [1] 0.510658
