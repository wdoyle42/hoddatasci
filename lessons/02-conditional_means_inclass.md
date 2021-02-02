Conditional Means In-Class Work
================
Doyle

## In Class Work: Conditional Means

For today’s class, I’d like for you to continue using the college-level
dataset. Today, instead of predicting debt levels use the variables, I
want you to predict average sat scores `sat_avg` as a function of the
variables in the dataset . Here are some (but not all!) of the things
that you’ll need to do along the way:

-   Open up the dataset, `sc_debt.Rds`

``` r
df<-readRDS("sc_debt.Rds")
```

-   Calculate the mean of the outcome variable of retail sales:
    `df%>%summarize(mean_sat=mean(sat_avg,na.rm=TRUE))`

-   Generate some tables of the conditional mean of the outcome variable
    by levels of the predictor variable. (hint: `group_by`, then
    `summarize`).

-   Create predictions for each county based on conditional means within
    each grouping of the predictor variable. (hint: `group_by`, then
    `mutate`).

-   Generate summary measures of the error terms: the difference between
    actual retail sales and your predicted retail sales, using `rmse`.
