Table Assignments
================

``` r
# R script to randomize class and place them at tables
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 2.2.1.9000     ✔ purrr   0.2.4     
    ## ✔ tibble  1.3.4          ✔ dplyr   0.7.4     
    ## ✔ tidyr   0.7.2          ✔ stringr 1.2.0     
    ## ✔ readr   1.1.1          ✔ forcats 0.2.0

    ## ── Conflicts ────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
class<-read_csv("../../classlist.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   last_name = col_character(),
    ##   first_name = col_character(),
    ##   ghid = col_character()
    ## )

``` r
class["random"]<-runif(dim(class)[1])

class<-class%>%arrange(random)

class["index"]<-seq(1:dim(class)[1])
ngroups<-4
class<-class%>%mutate(table=cut(index,ngroups,(1:ngroups)))

class$rmse<-NA

print(select(class,first_name,last_name,table),n=100)
```

    ## # A tibble: 17 x 3
    ##    first_name  last_name  table
    ##         <chr>      <chr> <fctr>
    ##  1   Bingrong     Zhangb      1
    ##  2   Angelina         Xu      1
    ##  3 first_name  last_name      1
    ##  4      Jason Washington      1
    ##  5    Cynthia       Shen      1
    ##  6  Alexander      Young      2
    ##  7      Emily Saperstone      2
    ##  8    Amberly Dziesinski      2
    ##  9      Cindy         Ni      2
    ## 10       Veer       Shah      3
    ## 11       Ruby        Cho      3
    ## 12     Dmitry    Semenov      3
    ## 13  Stepahnie      Zhang      3
    ## 14    Melissa       Dunn      4
    ## 15     Sydney      Banks      4
    ## 16     Lauren   Simkovic      4
    ## 17      Carol      Cheng      4

``` r
names(class)
```

    ## [1] "last_name"  "first_name" "ghid"       "random"     "index"     
    ## [6] "table"      "rmse"
