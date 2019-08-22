Table Assignments
================

``` r
# R script to randomize class and place them at tables
library(tidyverse)
```

    ## Registered S3 methods overwritten by 'ggplot2':
    ##   method         from 
    ##   [.quosures     rlang
    ##   c.quosures     rlang
    ##   print.quosures rlang

    ## ── Attaching packages ─────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.1.1     ✔ purrr   0.3.2
    ## ✔ tibble  2.1.3     ✔ dplyr   0.8.3
    ## ✔ tidyr   0.8.3     ✔ stringr 1.4.0
    ## ✔ readr   1.3.1     ✔ forcats 0.4.0

    ## ── Conflicts ────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
class<-read_csv("classlist.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   Name = col_character(),
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

    ## # A tibble: 15 x 3
    ##    first_name last_name  table
    ##    <chr>      <chr>      <fct>
    ##  1 Wills      Dunham     1    
    ##  2 Christian  Cox        1    
    ##  3 Andrew     Roth       1    
    ##  4 Evan       Fleisig    1    
    ##  5 Maryam     Muhammd    2    
    ##  6 Dani       Klinenberg 2    
    ##  7 Megan      Nguyen     2    
    ##  8 Will       Miller     2    
    ##  9 Jeremy     Gimbel     3    
    ## 10 Josie      Weck       3    
    ## 11 Abby       Breckwold  3    
    ## 12 Grant      Brown      4    
    ## 13 Chloe      Obert      4    
    ## 14 Brandon    Born       4    
    ## 15 Annabelle  McNeill    4

``` r
names(class)
```

    ## [1] "Name"       "last_name"  "first_name" "ghid"       "random"    
    ## [6] "index"      "table"      "rmse"
