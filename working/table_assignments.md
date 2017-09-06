Table Assignments
================

``` r
# R script to randomize class and place them at tables
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

class<-class%>%mutate(table=cut(index,6,(1:6)))

print(select(class,first_name,last_name,table),n=100)
```

    ## # A tibble: 20 × 3
    ##    first_name  last_name  table
    ##         <chr>      <chr> <fctr>
    ## 1      Claire    Fogarty      1
    ## 2     William   Sullivan      1
    ## 3         Ben     Scheer      1
    ## 4       Ethan      Polan      1
    ## 5      Brenda         Lu      2
    ## 6       Henry Livingston      2
    ## 7       James  Michaelis      2
    ## 8        Jack     Cramer      3
    ## 9        Siqi       Chen      3
    ## 10      Arjun       Shah      3
    ## 11      Raven       Delk      4
    ## 12      Susan       Cobb      4
    ## 13       Cole      Smith      4
    ## 14     Connor       Kreb      5
    ## 15     Alexis       Cook      5
    ## 16      Jacob   Kosowsky      5
    ## 17      Sunny        Cao      6
    ## 18      Katie      Means      6
    ## 19     Rachel      Anand      6
    ## 20     Carter       Pond      6

``` r
names(class)
```

    ## [1] "last_name"  "first_name" "ghid"       "random"     "index"     
    ## [6] "table"
