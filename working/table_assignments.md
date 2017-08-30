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
    ## 1     William   Sullivan      1
    ## 2       James  Michaelis      1
    ## 3       Sunny        Cao      1
    ## 4      Connor       Kreb      1
    ## 5      Alexis       Cook      2
    ## 6       Arjun       Shah      2
    ## 7      Claire    Fogarty      2
    ## 8        Cole      Smith      3
    ## 9      Rachel      Anand      3
    ## 10      Jacob   Kosowsky      3
    ## 11      Katie      Means      4
    ## 12        Ben     Scheer      4
    ## 13      Henry Livingston      4
    ## 14      Ethan      Polan      5
    ## 15      Susan       Cobb      5
    ## 16     Brenda         Lu      5
    ## 17      Raven       Delk      6
    ## 18       Jack     Cramer      6
    ## 19       Siqi       Chen      6
    ## 20     Carter       Pond      6

``` r
names(class)
```

    ## [1] "last_name"  "first_name" "ghid"       "random"     "index"     
    ## [6] "table"
