Table Assignments
================

``` r
# R script to randomize class and place them at tables
library(tidyverse)
```

    ## ── Attaching packages ──────────────────────────────────────────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.0.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.6
    ## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ── Conflicts ─────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
class<-read_csv("classlist.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   last_name = col_character(),
    ##   first_name = col_character()
    ## )

``` r
class["random"]<-runif(dim(class)[1])

class<-class%>%arrange(random)

class["index"]<-seq(1:dim(class)[1])
ngroups<-5
class<-class%>%mutate(table=cut(index,ngroups,(1:ngroups)))

class$rmse<-NA

print(select(class,first_name,last_name,table),n=100)
```

    ## # A tibble: 15 x 3
    ##    first_name last_name  table
    ##    <chr>      <chr>      <fct>
    ##  1 Alexander  Young      1    
    ##  2 Veer       Shah       1    
    ##  3 Lauren     Simkovic   1    
    ##  4 Melissa    Dunn       2    
    ##  5 Cindy      Ni         2    
    ##  6 Dmitry     Semenov    2    
    ##  7 Bingrong   Zhang      3    
    ##  8 Jason      Washington 3    
    ##  9 Ruby       Cho        3    
    ## 10 Sydney     Banks      4    
    ## 11 Carol      Cheng      4    
    ## 12 Angelina   Xu         4    
    ## 13 Emily      Saperstone 5    
    ## 14 Stephanie  Zhang      5    
    ## 15 Cynthia    Shen       5

``` r
names(class)
```

    ## [1] "last_name"  "first_name" "random"     "index"      "table"     
    ## [6] "rmse"
