Assignment 7
================

``` r
library(tidyverse)
```

    ## ── Attaching packages ──────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.0.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.7
    ## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ── Conflicts ─────────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(tidycensus)
library(noncensus)
library(acs)
```

    ## Loading required package: XML

    ## 
    ## Attaching package: 'acs'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     combine

    ## The following object is masked from 'package:base':
    ## 
    ##     apply

1.  Download data for all of the zip codes in Los Angeles county on education levels.

NB: This should work but does not
---------------------------------

``` r
data("zip_codes")
data("counties")


## Get FIPS code for LA County
cty_fips<-counties%>%
  filter(county_name=="Los Angeles County")%>%
  mutate(cty_fips=paste0(state_fips,county_fips))%>%
  select(cty_fips)%>%
  as_vector()

## Get all zip codes for LA county
ziplist<-zip_codes%>%
  filter(fips==as.numeric(cty_fips))%>%
  select(zip)%>%
  as_vector()

city_zip<-zip_codes%>%
  filter(fips==as.numeric(cty_fips))%>%
  select(zip,city)

## OR: http://lmgtfy.com/?q=los+angeles+county+fips
```

This works but by a different approach than the one I taught you.
-----------------------------------------------------------------

1.  Download data for all of the zip codes in Los Angeles county on education levels.

2.  Compute the proportion of the population that has a bachelor's degree or above by zip code.

``` r
acs_key<-readLines("../lessons/my_acs_key.txt",warn = FALSE)
census_api_key(acs_key)
```

    ## To install your API key for use in future sessions, run this function with `install = TRUE`.

``` r
# Table #B15001 education
table="B15001"

survey="acs5"

year=2016

acs_table<-get_acs(geography = "zcta",
                table=table,
                survey=survey,
                year=year,
                cache_table=TRUE
                )
```

    ## Getting data from the 2012-2016 5-year ACS

    ## Loading ACS5 variables for 2016 from table B15001 and caching the dataset for faster future access.

``` r
acs_table_educ<-acs_table%>%filter(GEOID%in%ziplist)%>%rename_all(.f=tolower)

var_list<-c("B15001_015",
            "B15001_016",
            "B15001_017",
            "B15001_018",
            "B15001_032",
            "B15001_033",
            "B15001_034",
            "B15001_035")

acs_table_educ<-acs_table_educ%>%
  group_by(geoid)%>%
  mutate(total=estimate[variable=="B15001_001"])%>%
  mutate(bach_plus=sum(estimate[variable %in%var_list]))%>%
  mutate(bach_plus=bach_plus/total)%>%
  summarize(bach_plus=mean(bach_plus))
```

1.  Download data for all of the zip codes in LA county on family income by zip code.
2.  Compute the proportion of the population that has family income above 75,000.

``` r
# Table #B19001  Income
table="B19001"

acs_table<-get_acs(geography = "zcta",
                table=table,
                survey=survey,
                year=year,
                cache_table=TRUE
                )
```

    ## Getting data from the 2012-2016 5-year ACS

    ## Loading ACS5 variables for 2016 from table B19001 and caching the dataset for faster future access.

``` r
acs_table_income<-acs_table%>%filter(GEOID%in%ziplist)%>%rename_all(.f=tolower)

var_list<-c("B19001_013",
"B19001_014",
"B19001_015",
"B19001_016",
"B19001_017")

acs_table_income<-acs_table_income%>%
  group_by(geoid)%>%
  mutate(total=estimate[variable=="B19001_001"])%>%
  mutate(over_75=sum(estimate[variable %in%var_list]))%>%
  mutate(prop_over_75=over_75/total)%>%
  summarize(prop_over_75=mean(prop_over_75))
```

1.  Download data for all of the zip codes in LA county on health insurance coverage status (you'll need to look that table up here:<http://www.census.gov/programs-surveys/acs/technical-documentation/summary-file-documentation.html>. Another link: <https://www.census.gov/programs-surveys/acs/technical-documentation/table-shells.html>
2.  Calculate the proportion of the population in each zip code that is uninsured.

``` r
## Health insurance table"B27001"

table<-"B27001"

acs_table<-get_acs(geography = "zcta",
                table=table,
                survey=survey,
                year=2016,
                cache_table=TRUE
                )
```

    ## Getting data from the 2012-2016 5-year ACS

    ## Loading ACS5 variables for 2016 from table B27001 and caching the dataset for faster future access.

``` r
acs_table_health<-acs_table%>%filter(GEOID%in%ziplist)%>%rename_all(.f=tolower)

var_list<-paste0("B27001_0",str_pad(c(seq(5,29,by=3),
                                      seq(33,57,by=3)),
                                      width=2 ,pad = "0"))
                  
acs_table_health<-acs_table_health%>%
  group_by(geoid)%>%
  mutate(total=estimate[variable=="B27001_001"])%>%
  mutate(uninsured=sum(estimate[variable %in%var_list]))%>%
  mutate(prop_insured=uninsured/total)%>%
  summarize(uninsured=mean(prop_insured))
```

1.  Plot the proportion uninsured as a function of education, and then as a function of income.

``` r
acs_table_educ<-acs_table_educ%>%rename_all(.f=tolower)
acs_full<-left_join(acs_table_educ,acs_table_income,by="geoid")
acs_full<-left_join(acs_full,acs_table_health,by="geoid")

gg<-ggplot(acs_full,aes(x=bach_plus,y=uninsured,color=prop_over_75))
gg<-gg+geom_point()
gg
```

    ## Warning: Removed 10 rows containing missing values (geom_point).

![](07-assignment_key_files/figure-markdown_github/unnamed-chunk-7-1.png)

``` r
gg<-ggplot(acs_full,aes(x=prop_over_75,y=uninsured,color=bach_plus))
gg<-gg+geom_point()
gg
```

    ## Warning: Removed 13 rows containing missing values (geom_point).

![](07-assignment_key_files/figure-markdown_github/unnamed-chunk-7-2.png)

1.  Model the proportion uninsured as a function of education, income *and one other variable of your choice*.

``` r
mod1<-lm(uninsured~bach_plus+prop_over_75,data=acs_full); summary(mod1)
```

    ## 
    ## Call:
    ## lm(formula = uninsured ~ bach_plus + prop_over_75, data = acs_full)
    ## 
    ## Residuals:
    ##       Min        1Q    Median        3Q       Max 
    ## -0.285996 -0.016228 -0.000695  0.015835  0.153831 
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)   0.303250   0.007433  40.799  < 2e-16 ***
    ## bach_plus    -0.180678   0.052609  -3.434 0.000686 ***
    ## prop_over_75 -0.305473   0.022604 -13.514  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.04001 on 275 degrees of freedom
    ##   (13 observations deleted due to missingness)
    ## Multiple R-squared:  0.6957, Adjusted R-squared:  0.6935 
    ## F-statistic: 314.4 on 2 and 275 DF,  p-value: < 2.2e-16
