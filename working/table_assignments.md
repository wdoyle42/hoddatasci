Table Assignments
================

``` r
# R script to randomize class and place them at tables
library(tidyverse)
```

    ## ── Attaching packages ───────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.0.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.6
    ## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ── Conflicts ──────────────────────────────────────────────── tidyverse_conflicts() ──
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
ngroups<-7
class<-class%>%mutate(table=cut(index,ngroups,(1:ngroups)))

class$rmse<-NA

print(select(class,first_name,last_name,table),n=100)
```

    ## # A tibble: 15 x 3
    ##    first_name last_name  table
    ##    <chr>      <chr>      <fct>
    ##  1 Melissa    Dunn       1    
    ##  2 Angelina   Xu         1    
    ##  3 Jason      Washington 1    
    ##  4 Cynthia    Shen       2    
    ##  5 Cindy      Ni         2    
    ##  6 Ruby       Cho        3    
    ##  7 Lauren     Simkovic   3    
    ##  8 Stephanie  Zhang      4    
    ##  9 Sydney     Banks      4    
    ## 10 Alexander  Young      5    
    ## 11 Veer       Shah       5    
    ## 12 Emily      Saperstone 6    
    ## 13 Dmitry     Semenov    6    
    ## 14 Carol      Cheng      7    
    ## 15 Bingrong   Zhang      7

``` r
names(class)
```

    ## [1] "last_name"  "first_name" "random"     "index"      "table"     
    ## [6] "rmse"
