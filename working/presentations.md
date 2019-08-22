Presentation Schedule
================

``` r
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
library(knitr)
classlist<-read_csv("classlist.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   last_name = col_character(),
    ##   first_name = col_character(),
    ##   ghid = col_character()
    ## )

``` r
classlist$group<-1
classlist$group[8:15]<-2
classlist%>%kable()
```

| last\_name | first\_name | ghid            | group |
| :--------- | :---------- | :-------------- | ----: |
| Born       | Brandon     | bborn16         |     1 |
| Breckwold  | Abby        | abbybreckwoldt  |     1 |
| Brown      | Grant       | GB-999          |     1 |
| Cox        | Christian   | christiancox97  |     1 |
| Dunham     | Wills       | dunhamwc        |     1 |
| Fleisig    | Evan        | elfleisig       |     1 |
| Gimbel     | Jeremy      | jeremyg1998     |     1 |
| Klinenberg | Dani        | dklinenberg     |     2 |
| McNeill    | Annabelle   | NA              |     2 |
| Miller     | Will        | jwillmiller     |     2 |
| Muhammd    | Maryam      | muhammadM20     |     2 |
| Nguyen     | Megan       | megannguyen6898 |     2 |
| Obert      | Chloe       | chloeobert      |     2 |
| Roth       | Andrew      | andrewsroth     |     2 |
| Weck       | Josie       | josiemweck      |     2 |
