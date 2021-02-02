Conditional Means
================

# Analyzing Data: Conditional Means

The conditional mean will be our first predictive algorithm. Conditional
means answer the question: “Given what we know about a certain case,
what can expect to see, on average?” The conditional mean is a powerful
tool that is typically quite easy to explain to decision-makers.

We’ll go through the following steps:

1.  Computing and unconditional means
2.  Computing conditional means using a single predictor and calculating
    our error.
3.  Computing conditional means using multiple predictors and
    calculating our error.

## Motivating Example

Suppose you’re talking to a high school senior about college choice and
student debt. They want to know which types of colleges have graduates
with higher and lower levels of debt. They’re concerned about the amount
of debt they will incur on the path to graduation. Essentially they’re
asking for a prediction: based on the characteristics of the college
they attend, what will be the likely amount of debt?

We’ll use data from the [college
scorecard](https://collegescorecard.ed.gov/) to answer these questions.

## Libraries

We’ll use `tidyverse` as usual, and we’ll need the `yardstick` library
for some calculations.

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──

    ## ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
    ## ✓ tibble  3.0.4     ✓ dplyr   1.0.2
    ## ✓ tidyr   1.1.2     ✓ stringr 1.4.0
    ## ✓ readr   1.4.0     ✓ forcats 0.5.0

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(yardstick)
```

    ## For binary classification, the first factor level is assumed to be the event.
    ## Use the argument `event_level = "second"` to alter this as needed.

    ## 
    ## Attaching package: 'yardstick'

    ## The following object is masked from 'package:readr':
    ## 
    ##     spec

## Dataset for this week

This week we’ll use another dataset from the college scorecard, this one
focused on student debt. Here are the variable names and definitions:

``` r
df<-readRDS("sc_debt.Rds") 
names(df)
```

    ##  [1] "unitid"         "instnm"         "stabbr"         "grad_debt_mdn" 
    ##  [5] "control"        "region"         "preddeg"        "openadmp"      
    ##  [9] "adm_rate"       "ccbasic"        "sat_avg"        "md_earn_wne_p6"
    ## [13] "ugds"           "selective"      "research_u"

| Name              | Definition                                                                                                                                                                                                |
|-------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| unitid            | Unit ID                                                                                                                                                                                                   |
| instnm            | Institution Name                                                                                                                                                                                          |
| stabbr            | State Abbreviation                                                                                                                                                                                        |
| grad\_debt\_mdn   | Median Debt of Graduates                                                                                                                                                                                  |
| control           | Control Public or Private                                                                                                                                                                                 |
| region            | Census Region                                                                                                                                                                                             |
| preddeg           | Predominant Degree Offered: Associates or Bachelors                                                                                                                                                       |
| openadmp          | Open Admissions Policy: 1= Yes, 2=NO,3=No 1st time students                                                                                                                                               |
| adm\_rate         | Proportion of applicants admitted                                                                                                                                                                         |
| ccbasic           | Carnegie classification, see [here](https://data.ed.gov/dataset/9dc70e6b-8426-4d71-b9d5-70ce6094a3f4/resource/658b5b83-ac9f-4e41-913e-9ba9411d7967/download/collegescorecarddatadictionary_01192021.xlsx) |
| sat\_avg          | Average SAT scores                                                                                                                                                                                        |
| md\_earn\_wne\_p6 | Median earnings of recent graduates                                                                                                                                                                       |
| ugds              | Number of undergraduates                                                                                                                                                                                  |
| selective         | Institution admits fewer than 10 % of applicants, 1=Yes, 0=No                                                                                                                                             |
| research\_u       | Institiution is a research university 1=Yes, 0=No                                                                                                                                                         |

## Dependent Variable

The dependent variable for us will be *institutional-level* median debt
for graduates, as reported by the college scorecard.

## Unconditional Means

If you were asked to predict the level of debt for this student without
any information about the college itself, the best guess would be the
overall average, or what we’re going to call the unconditional mean.

``` r
df%>%
  summarize(mean_debt_uncond=mean(grad_debt_mdn,na.rm=TRUE))
```

    ## # A tibble: 1 x 1
    ##   mean_debt_uncond
    ##              <dbl>
    ## 1           19662.

This gives us the overall average, and would be our prediction about the
level of college debt the student could expect, if we didn’t have any
other information about the college.

## Unconditional Mean as a Predictor

Using the mean of a variable as a predictor is something we do all the
time. In this example, our best guess for the level of debt incurred by
a graduate is just the average level of debt across all institutions.
We’re going to add this guess to the dataset as our first prediction,
using the `mutate` command.

``` r
df<-df%>%
  mutate(mean_debt_uncond=mean(grad_debt_mdn,na.rm=TRUE))
```

Notice how this code is the same as above, except for the overwrite
`df<-df%>%` and the use of `mutate` as opposed to `summarize.`

This is of course a terrible prediction. In the absence of any other
information, it’s many times the best we can do, but we really ought to
be able to do better.

## Root Mean Squared Error

To understand how far off we are, we need to summarize our errors. We
will use different ways of doing this this semester, but let’s start
with a very standard one, Root Mean Squared Error, or RMSE. An error
term is the distance between each point and its prediction. We square
the errors, take the average, then take the square root of the result.
The name RMSE is exactly what RMSE is– neat, huh?

$$ RMSE(\\\\hat{Y})=\\\\sqrt{ 1/n \\\\sum\\\_{i=1}^n(Y\_i-\\\\hat{Y\_i})^2} $$

Luckily we have an r function that can do this for us. The `rmse`
function from the `yardstick` library will calculate the rmse for a
dataset. We need to give it the dataset and the two columns we’re
interested, in this case actual debt `grad_debt_mdn` and our prediction
`mean_debt_uncond`.

``` r
rmse_uncond<-df%>%rmse(grad_debt_mdn,mean_debt_uncond)
rmse_uncond
```

    ## # A tibble: 1 x 3
    ##   .metric .estimator .estimate
    ##   <chr>   <chr>          <dbl>
    ## 1 rmse    standard       6992.

This tells us that if we use the unconditional mean, we’ll be off by an
average of 6992. Is that good or bad? We don’t know! RMSE does not have
a scale that tells us what it means. We have to understand it in the
context of the problem we’re working on. Lower is always better when it
comes to RMSE, as a lower RMSE means a more accurate prediction.

## Conditional Mean With One Predictor

Public and private colleges in the US charge very different prices, and
so it’s plausible that graduates of these two types of institutions
would have different levels of debt. We can calculate the conditional
mean by first grouping by control using `group_by(control)` and then
calculating the mean for each of the two groups: public or private.

``` r
df%>%
  group_by(control)%>%
  summarize(mean_debt_control=mean(grad_debt_mdn,na.rm=TRUE))%>%
  arrange(control)
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## # A tibble: 2 x 2
    ##   control mean_debt_control
    ##   <chr>               <dbl>
    ## 1 Private            23684.
    ## 2 Public             15588.

We can see that graduates of private instituitions have higher debt
levels than graduates of public institutions. We’ll follow the same
steps as we did with the unconditional mean and add the conditional mean
to the dataset as a predictor.

``` r
df<-df%>%
  group_by(control)%>%
  mutate(mean_debt_control=mean(grad_debt_mdn,na.rm=TRUE))%>%
  ungroup()
```

I added one more step: I ungrouped the dataset using `ungroup()`. It’s
good practice to do this at the end of an code chunk that uses the group
function, otherwise other steps might be grouped in ways that were
unintended.

We can then calculate the RMSE using our new prediction based on the
conditional mean:

``` r
rmse_control<-df%>%rmse(grad_debt_mdn,mean_debt_control)
rmse_control
```

    ## # A tibble: 1 x 3
    ##   .metric .estimator .estimate
    ##   <chr>   <chr>          <dbl>
    ## 1 rmse    standard       5701.

Using the predictor increased our predictive accuracy considerably, from
6992 to 5701!

## Conditional Mean With Two Predictors

It’s also probably the case that the degree level for the institition
matters. It takes longer to get a bachelor’s degree than an associate
degree, so we could expect that institutions that mostly give bachelor’s
degrees would have higher debt levels. To figure this out we need to
group by control and predominant degree level.

Grouping with multiple predictors works exactly the same way as with one
predictor. We just add the additional variable to the `group_by`
command, like so:

``` r
df%>%
  group_by(control,preddeg)%>%
  summarize(mean_debt_control_degree=mean(grad_debt_mdn,na.rm=TRUE))%>%
  arrange(mean_debt_control_degree)
```

    ## `summarise()` regrouping output by 'control' (override with `.groups` argument)

    ## # A tibble: 4 x 3
    ## # Groups:   control [2]
    ##   control preddeg    mean_debt_control_degree
    ##   <chr>   <chr>                         <dbl>
    ## 1 Public  Associate                    10560.
    ## 2 Private Associate                    17225.
    ## 3 Public  Bachelor's                   21181.
    ## 4 Private Bachelor's                   24280.

Notice that I used `arrange` which will sort the dataset in descending
order based on the variable selected, in this case average debt levels
by control and degree awarded. We can see the very different levels of
debt incurred at these four different types of institutions. Now let’s
add this conditional mean to our dataset as a prediction.

``` r
df<-df%>%
  group_by(control,preddeg)%>%
  mutate(mean_debt_control_degree=mean(grad_debt_mdn,na.rm=TRUE))%>%
  ungroup()
```

``` r
rmse_control_degree<-df%>%rmse(grad_debt_mdn,mean_debt_control_degree)
rmse_control_degree
```

    ## # A tibble: 1 x 3
    ##   .metric .estimator .estimate
    ##   <chr>   <chr>          <dbl>
    ## 1 rmse    standard       4074.

Adding this variable has again improved our estimate.

## Conditional Mean With Three Predictors

We can continue this logic indefinitely, but let’s focus on one more
variable: the region of the country. Unlike the previous two variables,
this one has eight different levels. Adding it as another grouping
variable means we’re going to end up with 2x2x8=32 different conditional
means, one for each type of institution (public or private, 2 year or 4
year) in each region of the country

``` r
df%>%
  group_by(control,preddeg,region)%>%
  summarize(mean_debt_control_degree_region=mean(grad_debt_mdn,na.rm=TRUE))%>%
  arrange(mean_debt_control_degree_region)%>%
  print(n=100)
```

    ## `summarise()` regrouping output by 'control', 'preddeg' (override with `.groups` argument)

    ## # A tibble: 32 x 4
    ## # Groups:   control, preddeg [4]
    ##    control preddeg    region          mean_debt_control_degree_region
    ##    <chr>   <chr>      <chr>                                     <dbl>
    ##  1 Public  Associate  Southwest                                 9717.
    ##  2 Public  Associate  New England                               9729.
    ##  3 Public  Associate  Great Lakes                              10421.
    ##  4 Public  Associate  Far West                                 10480.
    ##  5 Public  Associate  Soutwest                                 10686.
    ##  6 Public  Associate  Plains                                   10904.
    ##  7 Public  Associate  Rocky Mountains                          11090.
    ##  8 Public  Associate  Northeast                                11277.
    ##  9 Private Associate  Plains                                   13550.
    ## 10 Private Associate  Southwest                                15408.
    ## 11 Private Associate  Northeast                                16463.
    ## 12 Private Associate  Great Lakes                              16961.
    ## 13 Public  Bachelor's Far West                                 17507.
    ## 14 Private Associate  Soutwest                                 18410.
    ## 15 Private Associate  Far West                                 18978.
    ## 16 Private Associate  New England                              19175.
    ## 17 Public  Bachelor's Southwest                                19206 
    ## 18 Private Associate  Rocky Mountains                          20117.
    ## 19 Public  Bachelor's Rocky Mountains                          20169.
    ## 20 Public  Bachelor's Northeast                                20681.
    ## 21 Public  Bachelor's Plains                                   21436.
    ## 22 Private Bachelor's Rocky Mountains                          22175.
    ## 23 Public  Bachelor's Soutwest                                 22591.
    ## 24 Public  Bachelor's Great Lakes                              22627.
    ## 25 Private Bachelor's Far West                                 22884.
    ## 26 Public  Bachelor's New England                              23137.
    ## 27 Private Bachelor's Plains                                   23392.
    ## 28 Private Bachelor's New England                              23999.
    ## 29 Private Bachelor's Northeast                                24438.
    ## 30 Private Bachelor's Southwest                                24492.
    ## 31 Private Bachelor's Great Lakes                              24603.
    ## 32 Private Bachelor's Soutwest                                 25195.

Because it’s so many more conditional means, I added the `print(n=100)`
to the code chunk, so we can see all of the results.

Let’s add these as predictors to the dataset:

``` r
df<-df%>%
  group_by(control,preddeg,region)%>%
  mutate(mean_debt_control_degree_region=mean(grad_debt_mdn,na.rm=TRUE))%>%
  ungroup()
```

And calculate the RMSE:

``` r
rmse_control_degree_region<-df%>%rmse(grad_debt_mdn,mean_debt_control_degree_region)
rmse_control_degree_region
```

    ## # A tibble: 1 x 3
    ##   .metric .estimator .estimate
    ##   <chr>   <chr>          <dbl>
    ## 1 rmse    standard       3928.

This is a much better RMSE than what we started with. Is it good enough?
Who knows? Again this depends on the context. But we can imagine the
high school senior would have much more accurate information with which
to make their decision.

## Applications of the Conditional Mean

When might we use the conditional mean?

-   Calculating average sales for a retail location by day of the week
    and month
-   Calculating yield rate (proportion of admitted students who attend)
    by geographic region and income level for a college.
-   Calculating average employee turnover by level of education and
    gender
