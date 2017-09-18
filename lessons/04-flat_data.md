Working With Flat Data Files
================

Flat data is data that is arranged with one case per row, with one column per variable-- more or less. It's stored in a variety of formats, with different conventions. Our goal is to get it into the most useful format for analysis: what's known as tidy data.

``` r
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
library(haven)
library(readxl)
```

CSV or other delimited files
----------------------------

We'll start with a csv file which is among the most common formats for datasets. CSV stands for \_Comma \_Separated \_Value, meaning that each row is divided into cells by commas. An end of line completes the row.

``` r
#Delimited files

#Load in the HSB dataset from the UCLA statistical computing site

hsb<-read_csv(file="https://stats.idre.ucla.edu/wp-content/uploads/2016/02/hsb2-2.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   id = col_integer(),
    ##   female = col_integer(),
    ##   race = col_integer(),
    ##   ses = col_integer(),
    ##   schtyp = col_integer(),
    ##   prog = col_integer(),
    ##   read = col_integer(),
    ##   write = col_integer(),
    ##   math = col_integer(),
    ##   science = col_integer(),
    ##   socst = col_integer()
    ## )

``` r
write_csv(hsb,path="hsb.csv")

#Check it out
head(hsb)
```

    ## # A tibble: 6 × 11
    ##      id female  race   ses schtyp  prog  read write  math science socst
    ##   <int>  <int> <int> <int>  <int> <int> <int> <int> <int>   <int> <int>
    ## 1    70      0     4     1      1     1    57    52    41      47    57
    ## 2   121      1     4     2      1     3    68    59    53      63    61
    ## 3    86      0     4     3      1     1    44    33    54      58    31
    ## 4   141      0     4     3      1     3    63    44    47      53    56
    ## 5   172      0     4     2      1     2    47    52    57      53    61
    ## 6   113      0     4     2      1     2    44    52    51      63    61

``` r
##Need these for later
my.names<-names(hsb)

#Write this in a variety of formats to be used later
write_delim(hsb, path="hsb.txt",delim="\t")

write_delim(hsb, path="hsb_semicolon.txt",delim=";")
gdata::write.fwf(data.frame(hsb),file="hsb.dat",sep="",colnames=FALSE)
```

*Quick exercise: write out the HSB file with a semicolon delimiter*

Fixed width files
-----------------

fixed width files are an older file format that you don't see as much of any more. To read these in, you need a file that tells you the locations of the different variables, known as column positions or locations.

``` r
## ------------------------------------------------------------------------

#Fixed width files

#You need to get the "widths" somehere, usually a data dictionary

my.widths=c(3,#id
            1, #female
            1, #race
            1, #ses
            1, #schtyp
            1, #prog
            2, #read
            2, #write
            2, #math 
            2, #science
            2 #socst
            )
            
my_positions<-fwf_widths(my.widths)

hsb3<-read_fwf("hsb.dat",
         col_positions  =my_positions)
```

    ## Parsed with column specification:
    ## cols(
    ##   X1 = col_integer(),
    ##   X2 = col_integer(),
    ##   X3 = col_integer(),
    ##   X4 = col_integer(),
    ##   X5 = col_integer(),
    ##   X6 = col_integer(),
    ##   X7 = col_integer(),
    ##   X8 = col_integer(),
    ##   X9 = col_integer(),
    ##   X10 = col_integer(),
    ##   X11 = col_integer()
    ## )

``` r
head(hsb3)
```

    ## # A tibble: 6 × 11
    ##      X1    X2    X3    X4    X5    X6    X7    X8    X9   X10   X11
    ##   <int> <int> <int> <int> <int> <int> <int> <int> <int> <int> <int>
    ## 1    70     0     4     1     1     1    57    52    41    47    57
    ## 2   121     1     4     2     1     3    68    59    53    63    61
    ## 3    86     0     4     3     1     1    44    33    54    58    31
    ## 4   141     0     4     3     1     3    63    44    47    53    56
    ## 5   172     0     4     2     1     2    47    52    57    53    61
    ## 6   113     0     4     2     1     2    44    52    51    63    61

``` r
names(hsb3)<-my.names

head(hsb3)
```

    ## # A tibble: 6 × 11
    ##      id female  race   ses schtyp  prog  read write  math science socst
    ##   <int>  <int> <int> <int>  <int> <int> <int> <int> <int>   <int> <int>
    ## 1    70      0     4     1      1     1    57    52    41      47    57
    ## 2   121      1     4     2      1     3    68    59    53      63    61
    ## 3    86      0     4     3      1     1    44    33    54      58    31
    ## 4   141      0     4     3      1     3    63    44    47      53    56
    ## 5   172      0     4     2      1     2    47    52    57      53    61
    ## 6   113      0     4     2      1     2    44    52    51      63    61

Excel (sigh)
------------

In most business applications you'll work with excel files the most often. To get these into shape you'll have to do some wrangling. Below I show how this is done with data in a common reporting format.

``` r
## ------------------------------------------------------------------------

#Excel files

##http://nces.ed.gov/programs/digest/d14/tables/dt14_204.10.asp

download.file("http://nces.ed.gov/programs/digest/d14/tables/xls/tabn204.10.xls",destfile="free.xls")
```

    ## Warning in download.file("http://nces.ed.gov/programs/digest/d14/tables/
    ## xls/tabn204.10.xls", : "internal" method cannot handle https redirection
    ## to: 'https://nces.ed.gov/programs/digest/d14/tables/xls/tabn204.10.xls'

    ## switching to method = "libcurl" because of redirection to https

``` r
free<-read_excel("free.xls",skip=4,col_names=FALSE)
```

    ## DEFINEDNAME: 00 00 00 0f 02 00 00 00 00 00 00 00 00 00 00 5f 34 57 4f 52 44 5f 4d 5f 30 30 31 5f 30 37 1c 2a 
    ## DEFINEDNAME: 00 00 00 0f 02 00 00 00 00 00 00 00 00 00 00 5f 34 57 4f 52 44 5f 4f 5f 30 30 35 5f 4c 5f 1c 2a 
    ## DEFINEDNAME: 01 00 00 0f 03 00 00 00 01 00 00 00 00 00 00 5f 52 65 67 72 65 73 73 69 6f 6e 5f 49 6e 74 1e 01 00 
    ## DEFINEDNAME: 20 00 00 01 0b 00 00 00 01 00 00 00 00 00 00 06 3b 00 00 00 00 44 00 00 00 12 00 
    ## DEFINEDNAME: 00 00 00 0d 0b 00 00 00 01 00 00 00 00 00 00 50 72 69 6e 74 5f 41 72 65 61 5f 4d 49 3b 00 00 00 00 46 00 00 00 0d 00 
    ## DEFINEDNAME: 00 00 00 0f 02 00 00 00 00 00 00 00 00 00 00 5f 34 57 4f 52 44 5f 4d 5f 30 30 31 5f 30 37 1c 2a 
    ## DEFINEDNAME: 00 00 00 0f 02 00 00 00 00 00 00 00 00 00 00 5f 34 57 4f 52 44 5f 4f 5f 30 30 35 5f 4c 5f 1c 2a 
    ## DEFINEDNAME: 01 00 00 0f 03 00 00 00 01 00 00 00 00 00 00 5f 52 65 67 72 65 73 73 69 6f 6e 5f 49 6e 74 1e 01 00 
    ## DEFINEDNAME: 20 00 00 01 0b 00 00 00 01 00 00 00 00 00 00 06 3b 00 00 00 00 44 00 00 00 12 00 
    ## DEFINEDNAME: 00 00 00 0d 0b 00 00 00 01 00 00 00 00 00 00 50 72 69 6e 74 5f 41 72 65 61 5f 4d 49 3b 00 00 00 00 46 00 00 00 0d 00 
    ## DEFINEDNAME: 00 00 00 0f 02 00 00 00 00 00 00 00 00 00 00 5f 34 57 4f 52 44 5f 4d 5f 30 30 31 5f 30 37 1c 2a 
    ## DEFINEDNAME: 00 00 00 0f 02 00 00 00 00 00 00 00 00 00 00 5f 34 57 4f 52 44 5f 4f 5f 30 30 35 5f 4c 5f 1c 2a 
    ## DEFINEDNAME: 01 00 00 0f 03 00 00 00 01 00 00 00 00 00 00 5f 52 65 67 72 65 73 73 69 6f 6e 5f 49 6e 74 1e 01 00 
    ## DEFINEDNAME: 20 00 00 01 0b 00 00 00 01 00 00 00 00 00 00 06 3b 00 00 00 00 44 00 00 00 12 00 
    ## DEFINEDNAME: 00 00 00 0d 0b 00 00 00 01 00 00 00 00 00 00 50 72 69 6e 74 5f 41 72 65 61 5f 4d 49 3b 00 00 00 00 46 00 00 00 0d 00

``` r
head(free)
```

    ## # A tibble: 6 × 19
    ##                               X1       X2    X3       X4       X5    X6
    ##                            <chr>    <dbl> <chr>    <dbl>    <dbl> <chr>
    ## 1    United States ............. 46579068 \\1\\ 48941267 48995812 \\1\\
    ## 2   Alabama ....................   728351  <NA>   730427   731556  <NA>
    ## 3      Alaska ..................   105333  <NA>   132104   131166  <NA>
    ## 4  Arizona .....................   877696 \\2\\  1067210  1024454  <NA>
    ## 5    Arkansas ..................   449959  <NA>   482114   483114  <NA>
    ## 6   California .................  6050753  <NA>  6169427  6202862 \\2\\
    ## # ... with 13 more variables: X7 <dbl>, X8 <dbl>, X9 <chr>, X10 <dbl>,
    ## #   X11 <dbl>, X12 <chr>, X13 <dbl>, X14 <dbl>, X15 <chr>, X16 <dbl>,
    ## #   X17 <dbl>, X18 <chr>, X19 <dbl>

``` r
# Now need to clean up 
#Get rid of unwanted columns

free2<-free[ ,-(c(3,6,9,12,15,18))]

#Get rid of unwanted rows
free2<-free2%>%filter(is.na(X1)==FALSE)

##50 states plus dc only
free2<-free2[2:52,]


head(free2)
```

    ## # A tibble: 6 × 13
    ##                              X1      X2      X4      X5      X7      X8
    ##                           <chr>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    ## 1  Alabama ....................  728351  730427  731556  740475  335143
    ## 2     Alaska ..................  105333  132104  131166  131483   32468
    ## 3 Arizona .....................  877696 1067210 1024454  990378  274277
    ## 4   Arkansas ..................  449959  482114  483114  486157  205058
    ## 5  California ................. 6050753 6169427 6202862 6178788 2820611
    ## 6 Colorado ....................  724349  842864  853610  863121  195148
    ## # ... with 7 more variables: X10 <dbl>, X11 <dbl>, X13 <dbl>, X14 <dbl>,
    ## #   X16 <dbl>, X17 <dbl>, X19 <dbl>

``` r
tail(free2)
```

    ## # A tibble: 6 × 13
    ##                              X1      X2      X4      X5      X7     X8
    ##                           <chr>   <dbl>   <dbl>   <dbl>   <dbl>  <dbl>
    ## 1  Vermont ....................  102049   85144   83451   83568  23986
    ## 2 Virginia .................... 1067710 1250206 1227099 1235561 320233
    ## 3 Washington .................. 1004770 1043466 1041934 1050904 326295
    ## 4     West Virginia ...........  286285  282879  282870  283044 143446
    ## 5    Wisconsin ................  859276  872164  869670  871376 219276
    ## 6   Wyoming ...................   89895   88779   89363   91533  43483
    ## # ... with 7 more variables: X10 <dbl>, X11 <dbl>, X13 <dbl>, X14 <dbl>,
    ## #   X16 <dbl>, X17 <dbl>, X19 <dbl>

``` r
names(free2)<-c("state",
                "total.2000",
                "total.2010",
                "total.2011",
                "total.2012",
                "frl.2000",
                "frl.2010",
                "frl.2011",
                "frl.2012",
                "pc.frl.2000",
                "pc.frl.2010",
                "pc.frl.2011",
                "pc.frl.2012")
```

\*Quick Exercise: Read in this file: <http://nces.ed.gov/programs/digest/d14/tables/xls/tabn302.10.xls*>

``` r
download.file("http://nces.ed.gov/programs/digest/d14/tables/xls/tabn302.10.xls",destfile="grad.xls")
```

    ## Warning in download.file("http://nces.ed.gov/programs/digest/d14/tables/
    ## xls/tabn302.10.xls", : "internal" method cannot handle https redirection
    ## to: 'https://nces.ed.gov/programs/digest/d14/tables/xls/tabn302.10.xls'

    ## switching to method = "libcurl" because of redirection to https

``` r
grad<-read_excel("grad.xls",skip=6,col_names=FALSE)
```

    ## DEFINEDNAME: 01 00 00 0f 03 00 00 00 01 00 00 00 00 00 00 5f 52 65 67 72 65 73 73 69 6f 6e 5f 49 6e 74 1e 01 00 
    ## DEFINEDNAME: 20 00 00 01 0b 00 00 00 01 00 00 00 00 00 00 06 3b 00 00 00 00 4c 00 00 00 18 00 
    ## DEFINEDNAME: 20 00 00 01 02 00 00 00 00 00 00 00 00 00 00 06 1c 2a 
    ## DEFINEDNAME: 00 00 00 0d 0b 00 00 00 01 00 00 00 00 00 00 50 72 69 6e 74 5f 41 72 65 61 5f 4d 49 3b 00 00 00 00 4c 00 00 00 14 00 
    ## DEFINEDNAME: 00 00 00 0d 02 00 00 00 00 00 00 00 00 00 00 50 52 49 4e 54 5f 41 52 45 41 5f 4d 49 1c 2a 
    ## DEFINEDNAME: 01 00 00 0f 03 00 00 00 01 00 00 00 00 00 00 5f 52 65 67 72 65 73 73 69 6f 6e 5f 49 6e 74 1e 01 00 
    ## DEFINEDNAME: 20 00 00 01 0b 00 00 00 01 00 00 00 00 00 00 06 3b 00 00 00 00 4c 00 00 00 18 00 
    ## DEFINEDNAME: 20 00 00 01 02 00 00 00 00 00 00 00 00 00 00 06 1c 2a 
    ## DEFINEDNAME: 00 00 00 0d 0b 00 00 00 01 00 00 00 00 00 00 50 72 69 6e 74 5f 41 72 65 61 5f 4d 49 3b 00 00 00 00 4c 00 00 00 14 00 
    ## DEFINEDNAME: 00 00 00 0d 02 00 00 00 00 00 00 00 00 00 00 50 52 49 4e 54 5f 41 52 45 41 5f 4d 49 1c 2a 
    ## DEFINEDNAME: 01 00 00 0f 03 00 00 00 01 00 00 00 00 00 00 5f 52 65 67 72 65 73 73 69 6f 6e 5f 49 6e 74 1e 01 00 
    ## DEFINEDNAME: 20 00 00 01 0b 00 00 00 01 00 00 00 00 00 00 06 3b 00 00 00 00 4c 00 00 00 18 00 
    ## DEFINEDNAME: 20 00 00 01 02 00 00 00 00 00 00 00 00 00 00 06 1c 2a 
    ## DEFINEDNAME: 00 00 00 0d 0b 00 00 00 01 00 00 00 00 00 00 50 72 69 6e 74 5f 41 72 65 61 5f 4d 49 3b 00 00 00 00 4c 00 00 00 14 00 
    ## DEFINEDNAME: 00 00 00 0d 02 00 00 00 00 00 00 00 00 00 00 50 52 49 4e 54 5f 41 52 45 41 5f 4d 49 1c 2a

``` r
#Get rid of unwanted rows
grad<-grad%>%filter(is.na(X1)==FALSE)
```

Tidy data
---------

Tidy data follows two key principles: each column is one variable and one variable only, while each row is a case. Below, I show how to make the data from the above spreadsheet tidy, and why we would do this.

``` r
free_total<-free2%>%select(state,
                           total.2000,
                           total.2010,
                           total.2011,
                           total.2012)
names(free_total)<-c("state","2000","2010","2011","2012")

free_total<-free_total%>%gather(`2000`,`2010`,`2011`,`2012`,key=year,value=total_students)


frl_total<-free2%>%select(state,
                           frl.2000,
                           frl.2010,
                           frl.2011,
                           frl.2012)

names(frl_total)<-c("state","2000","2010","2011","2012")

frl_total<-frl_total%>%gather(`2000`,`2010`,`2011`,`2012`,key=year,value=frl_students)



free_tidy<-left_join(free_total,frl_total,by=c("state","year"))

free_tidy
```

    ## # A tibble: 204 × 4
    ##                            state  year total_students frl_students
    ##                            <chr> <chr>          <dbl>        <dbl>
    ## 1   Alabama ....................  2000         728351       335143
    ## 2      Alaska ..................  2000         105333        32468
    ## 3  Arizona .....................  2000         877696       274277
    ## 4    Arkansas ..................  2000         449959       205058
    ## 5   California .................  2000        6050753      2820611
    ## 6  Colorado ....................  2000         724349       195148
    ## 7    Connecticut ...............  2000         562179       143030
    ## 8    Delaware ..................  2000         114676        37766
    ## 9  District of Columbia ........  2000          68380        47839
    ## 10    Florida ..................  2000        2434755      1079009
    ## # ... with 194 more rows

``` r
## Total by year

free_tidy%>%group_by(year)%>%summarize(sum(frl_students))
```

    ## # A tibble: 4 × 2
    ##    year `sum(frl_students)`
    ##   <chr>               <dbl>
    ## 1  2000            17839867
    ## 2  2010            23544479
    ## 3  2011            24291646
    ## 4  2012            25188294

``` r
pc.frl_total<-free2%>%select(state,
                           pc.frl.2000,
                           pc.frl.2010,
                           pc.frl.2011,
                           pc.frl.2012)

names(pc.frl_total)<-c("state","2000","2010","2011","2012")

pc_frl_total<-pc.frl_total%>%gather(`2000`,`2010`,`2011`,`2012`,key=year,value=pc_frl_students)

## ------------------------------------------------------------------------
```

*Quick Exericse: now add in percent of students eligible by state*

Other programming languages
---------------------------

Other statistical programs have their own file formats. These are easy for these programs to read in. R can udnerstand all of them, if the `haven` packages is used.

``` r
#Other data files from stat programming language


# Stata

hsb_stata<-read_dta("https://stats.idre.ucla.edu/stat/stata/notes/hsb2.dta")

head(hsb_stata)
```

    ## # A tibble: 6 × 11
    ##      id    female      race       ses    schtyp      prog  read write
    ##   <dbl> <dbl+lbl> <dbl+lbl> <dbl+lbl> <dbl+lbl> <dbl+lbl> <dbl> <dbl>
    ## 1    70         0         4         1         1         1    57    52
    ## 2   121         1         4         2         1         3    68    59
    ## 3    86         0         4         3         1         1    44    33
    ## 4   141         0         4         3         1         3    63    44
    ## 5   172         0         4         2         1         2    47    52
    ## 6   113         0         4         2         1         2    44    52
    ## # ... with 3 more variables: math <dbl>, science <dbl>, socst <dbl>

``` r
#SPSS
example_spss<-read_spss("https://stats.idre.ucla.edu/stat/data/binary.sav")

head(example_spss)
```

    ## # A tibble: 6 × 4
    ##   admit   gre   gpa  rank
    ##   <dbl> <dbl> <dbl> <dbl>
    ## 1     0   380  3.61     3
    ## 2     1   660  3.67     3
    ## 3     1   800  4.00     1
    ## 4     1   640  3.19     4
    ## 5     0   520  2.93     4
    ## 6     1   760  3.00     2

``` r
#SAS
hsb_sas<-read_sas("https://stats.idre.ucla.edu/wp-content/uploads/2016/02/hsb2.sas7bdat")

head(hsb_sas)
```

    ## # A tibble: 6 × 11
    ##      id female  race   ses schtyp  prog  read write  math science socst
    ##   <dbl>  <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl>   <dbl> <dbl>
    ## 1     3      0     1     1      1     2    63    65    48      63    56
    ## 2     5      0     1     1      1     2    47    40    43      45    31
    ## 3    16      0     1     1      1     3    47    31    44      36    36
    ## 4    35      1     1     1      2     1    60    54    50      50    51
    ## 5     8      1     1     1      1     2    39    44    52      44    48
    ## 6    19      1     1     1      1     1    28    46    43      44    51

Output
------

Most of the time, you should store your data as a csv file. This will ensure that pretty much anyone can take a look at it. If you're sure that the only users will be other R users (why would you be sure of this?), then feel free to save it as an `.Rdata` file.

``` r
## ------------------------------------------------------------------------
#Saving as an R file

save(free2,file="frl.Rdata")

#Outputting delimited

write_csv(free2,"frl.csv")
```
