Using Databases
================
Will Doyle

Introduction: What's a Database?
================================

Databases are the primary way large organizations and governments organize and store data. What makes a database distinct from a dataset is that it stores data in multiple tables, which are called "flat files" in the parlance of databases. The relationships between each of the tables is recorded in a schema. Some terms from database land and their translation in R:

-   A table (sometimes called a file) in a database is like a data frame in R: a 2 dimensional array. The 2 dimensions are referred to as "records" and "fields". These are typically organized by their primary id, or unit of analysis.

-   A record is what we could call a case or a unit of observation. A record is composed of fields.

-   A field is what we would call a variable name. A field is composed of multiple records

-   A relational database is a set of tables that are linked by a set of common identifiers. Not every table can be linked to every other table, and tables do not need to have the same primary ids.

-   A database management system is software that provides a way to interact with a database.

The DBMS that is used most frequently is SQL and its variants, MYSQL and sqlite. Mariadb is a newer "sort of" variant of sql. Google BigQuery is one used by many companies, while Microsoft Access is a plague that has been set upon us for our transgressions. We hope someday the curse will be lifted.

An R analyst typically doesn't want to be a database person-- they just want to get the data out in a way that they can use for data analysis. It's not worth it to store data on your own computer in a database-- it will just slow you down. Instead, this lesson is intended for when you have a chance to interact with a truly large database.

NYC Flights
===========

Today we'll use the `nyclfights13` database, which contains information on every single flight departing New York City in 2013, including airline information, airport information, flight information, plane information and weather information.

Here is the schema for the nycflights13 database

We'll also use the Lahman database, which contains information on every single player to ever play any professional baseball since 1871, including batting, pitching, team information and so on.

``` r
# Mostly taken from : http://cran.r-project.org/web/packages/dplyr/vignettes/databases.html circa 2014

# Will need: nycflights13 RSQLite, Lahman

#Get libraries

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
library(DBI)
library(dbplyr)
```

    ## 
    ## Attaching package: 'dbplyr'

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     ident, sql

``` r
#library(RSQLite)
library(nycflights13)
library(Lahman)
```

The first thing we'll do is get all of the various tables open. They're stored in `data()` from the `nycflights` library.

``` r
# Data sources from NYC flights
data(flights)
data(airlines)
data(airports)
data(weather)
data(planes)
```

Connecting to a database
========================

I'm going to do something kind of unusual for this class: I'm going to create a database from existing flat files. You should NEVER do this-- it's just for teaching. I'm using the RSQLite package to open a connection to a database. In your work, you would just open the connection, many times through a secure network. You'll need instructions from a database admin on how to do this.

`con` below refers to our connection to a database. It remains open until we close it. It will be based on the properties of the database we're trying to access.

``` r
con <- dbConnect(RSQLite::SQLite(), ":memory:")

#Write flights tables to database (you won't usually do this)
dbWriteTable(con,
             "flights", 
             as.data.frame(flights))

dbWriteTable(con,
             "planes", 
             as.data.frame(planes))

dbWriteTable(con,
             "airlines", 
             as.data.frame(airlines))

dbWriteTable(con,
             "weather", 
             as.data.frame(weather))

dbWriteTable(con,
             "airports", 
             as.data.frame(airports))
```

Now I have an open connection to a database that contains multiple tables. Let's ask which tables we have access to:

``` r
#List tables in database
dbListTables(con)
```

    ## [1] "airlines" "airports" "flights"  "planes"   "weather"

For some of these tables, what fields are included?

``` r
#List fields in various tables
dbListFields(con,"airlines")
```

    ## [1] "carrier" "name"

``` r
dbListFields(con,"flights")
```

    ##  [1] "year"           "month"          "day"            "dep_time"      
    ##  [5] "sched_dep_time" "dep_delay"      "arr_time"       "sched_arr_time"
    ##  [9] "arr_delay"      "carrier"        "flight"         "tailnum"       
    ## [13] "origin"         "dest"           "air_time"       "distance"      
    ## [17] "hour"           "minute"         "time_hour"

SQL is its own language. One of the main things people do with SQL is to generate requests. Below, we create request text which asks for every field from the flights table, then sends that query to the database. Once we get the return back, we turn it into a data frame. As a matter of good practice, we also clear that request. Click [here](http://cse.unl.edu/~sscott/ShowFiles/SQL/CheatSheet/SQLCheatSheet.html) for a cheat sheet on SQL queries.

``` r
#Generate a SQL request to a database
req_text<-"Select * from flights"

#Send query through connection
req<-dbSendQuery(con,req_text)

#Generate dataframe from results
req_df<-dbFetch(req,n=-1)

#Good practice: clear request
dbClearResult(req)
```

Let's take a look at the generated data frame.

``` r
dim(req_df)
```

    ## [1] 336776     19

``` r
head(req_df,20)
```

    ##    year month day dep_time sched_dep_time dep_delay arr_time
    ## 1  2013     1   1      517            515         2      830
    ## 2  2013     1   1      533            529         4      850
    ## 3  2013     1   1      542            540         2      923
    ## 4  2013     1   1      544            545        -1     1004
    ## 5  2013     1   1      554            600        -6      812
    ## 6  2013     1   1      554            558        -4      740
    ## 7  2013     1   1      555            600        -5      913
    ## 8  2013     1   1      557            600        -3      709
    ## 9  2013     1   1      557            600        -3      838
    ## 10 2013     1   1      558            600        -2      753
    ## 11 2013     1   1      558            600        -2      849
    ## 12 2013     1   1      558            600        -2      853
    ## 13 2013     1   1      558            600        -2      924
    ## 14 2013     1   1      558            600        -2      923
    ## 15 2013     1   1      559            600        -1      941
    ## 16 2013     1   1      559            559         0      702
    ## 17 2013     1   1      559            600        -1      854
    ## 18 2013     1   1      600            600         0      851
    ## 19 2013     1   1      600            600         0      837
    ## 20 2013     1   1      601            600         1      844
    ##    sched_arr_time arr_delay carrier flight tailnum origin dest air_time
    ## 1             819        11      UA   1545  N14228    EWR  IAH      227
    ## 2             830        20      UA   1714  N24211    LGA  IAH      227
    ## 3             850        33      AA   1141  N619AA    JFK  MIA      160
    ## 4            1022       -18      B6    725  N804JB    JFK  BQN      183
    ## 5             837       -25      DL    461  N668DN    LGA  ATL      116
    ## 6             728        12      UA   1696  N39463    EWR  ORD      150
    ## 7             854        19      B6    507  N516JB    EWR  FLL      158
    ## 8             723       -14      EV   5708  N829AS    LGA  IAD       53
    ## 9             846        -8      B6     79  N593JB    JFK  MCO      140
    ## 10            745         8      AA    301  N3ALAA    LGA  ORD      138
    ## 11            851        -2      B6     49  N793JB    JFK  PBI      149
    ## 12            856        -3      B6     71  N657JB    JFK  TPA      158
    ## 13            917         7      UA    194  N29129    JFK  LAX      345
    ## 14            937       -14      UA   1124  N53441    EWR  SFO      361
    ## 15            910        31      AA    707  N3DUAA    LGA  DFW      257
    ## 16            706        -4      B6   1806  N708JB    JFK  BOS       44
    ## 17            902        -8      UA   1187  N76515    EWR  LAS      337
    ## 18            858        -7      B6    371  N595JB    LGA  FLL      152
    ## 19            825        12      MQ   4650  N542MQ    LGA  ATL      134
    ## 20            850        -6      B6    343  N644JB    EWR  PBI      147
    ##    distance hour minute  time_hour
    ## 1      1400    5     15 1357016400
    ## 2      1416    5     29 1357016400
    ## 3      1089    5     40 1357016400
    ## 4      1576    5     45 1357016400
    ## 5       762    6      0 1357020000
    ## 6       719    5     58 1357016400
    ## 7      1065    6      0 1357020000
    ## 8       229    6      0 1357020000
    ## 9       944    6      0 1357020000
    ## 10      733    6      0 1357020000
    ## 11     1028    6      0 1357020000
    ## 12     1005    6      0 1357020000
    ## 13     2475    6      0 1357020000
    ## 14     2565    6      0 1357020000
    ## 15     1389    6      0 1357020000
    ## 16      187    5     59 1357016400
    ## 17     2227    6      0 1357020000
    ## 18     1076    6      0 1357020000
    ## 19      762    6      0 1357020000
    ## 20     1023    6      0 1357020000

*Quick Exercise:* Get the weather table and put it in a data frame

Many times we want to generate a request that will only give us part of some tables. We'd also like to join tables together in many circumstances. Below is a SQL request that includes the key verbs SELECT, FROM, JOIN and WHERE.

``` r
#New request: which carriers have longer delays? 
req1_text<-"SELECT a.carrier, a.name, f.dep_delay 
            FROM flights f 
            JOIN airlines a ON a.carrier=f.carrier 
            WHERE f.dep_delay>60
            "
req1<-dbSendQuery(con,req1_text)

req1_df<-dbFetch(req1,n=-1)

dbClearResult(req1)

head(req1_df)
```

    ##   carrier                     name dep_delay
    ## 1      MQ                Envoy Air       101
    ## 2      AA   American Airlines Inc.        71
    ## 3      MQ                Envoy Air       853
    ## 4      UA    United Air Lines Inc.       144
    ## 5      UA    United Air Lines Inc.       134
    ## 6      EV ExpressJet Airlines Inc.        96

``` r
table(req1_df$name)
```

    ## 
    ## AirTran Airways Corporation        Alaska Airlines Inc. 
    ##                         314                          39 
    ##      American Airlines Inc.        Delta Air Lines Inc. 
    ##                        2003                        2651 
    ##           Endeavor Air Inc.                   Envoy Air 
    ##                        1966                        1996 
    ##    ExpressJet Airlines Inc.      Frontier Airlines Inc. 
    ##                        6861                          73 
    ##      Hawaiian Airlines Inc.             JetBlue Airways 
    ##                          10                        4571 
    ##          Mesa Airlines Inc.       SkyWest Airlines Inc. 
    ##                          79                           4 
    ##      Southwest Airlines Co.       United Air Lines Inc. 
    ##                        1061                        3824 
    ##             US Airways Inc.              Virgin America 
    ##                         766                         363

``` r
delay_summary<-req1_df%>%
  group_by(name)%>%
  summarize(avg_delay=mean(dep_delay,na.rm=TRUE))%>%
  arrange(-avg_delay)

delay_summary
```

    ## # A tibble: 16 x 2
    ##                           name avg_delay
    ##                          <chr>     <dbl>
    ##  1      Hawaiian Airlines Inc.  243.3000
    ##  2              Virgin America  146.0992
    ##  3 AirTran Airways Corporation  145.3248
    ##  4      Frontier Airlines Inc.  144.8767
    ##  5        Delta Air Lines Inc.  135.8616
    ##  6      Southwest Airlines Co.  131.9548
    ##  7           Endeavor Air Inc.  124.1501
    ##  8      American Airlines Inc.  123.2781
    ##  9       United Air Lines Inc.  121.1085
    ## 10        Alaska Airlines Inc.  118.3846
    ## 11    ExpressJet Airlines Inc.  118.2507
    ## 12             JetBlue Airways  117.8683
    ## 13          Mesa Airlines Inc.  117.0253
    ## 14             US Airways Inc.  115.6619
    ## 15                   Envoy Air  114.6839
    ## 16       SkyWest Airlines Inc.  109.2500

*Quick Exercise: Get data on airlines who fly at least 1000km, and number of flights over that length*

We can combine multiple tables to answer questions about how multiple factors, like weather and carrier, might be related.

``` r
#SQL request, flight info combined with weather info
weather_text<-"SELECT f.year, f.month, f.day, f.distance, f.dep_delay, w.visib, w.wind_speed, w.wind_gust
              FROM weather w
              JOIN flights f
              ON f.year=w.year
              AND f.month=w.month
              AND f.day=w.day
              WHERE f.dep_delay>20 AND w.wind_gust<1000"

weather_req<-dbSendQuery(con,weather_text)

weather_df<-dbFetch(weather_req,n=-1)

dbClearResult(weather_req)

head(weather_df)
```

    ##   year month day distance dep_delay visib wind_speed wind_gust
    ## 1 2013     1   1      264        21    10   10.35702  11.91865
    ## 2 2013     1   1      266        21    10   10.35702  11.91865
    ## 3 2013     1   1      282        21    10   10.35702  11.91865
    ## 4 2013     1   1      301        21    10   10.35702  11.91865
    ## 5 2013     1   1     1372        21    10   10.35702  11.91865
    ## 6 2013     1   1     2475        21    10   10.35702  11.91865

``` r
weather_summary<-
  weather_df%>%
  group_by(wind_gust)%>%
  summarize(avg_delay=mean(dep_delay,na.rm=TRUE))

weather_summary
```

    ## # A tibble: 34 x 2
    ##    wind_gust avg_delay
    ##        <dbl>     <dbl>
    ##  1  0.000000  75.63677
    ##  2  3.972884  76.08976
    ##  3  5.297178  74.39672
    ##  4  6.621473  73.94190
    ##  5  7.945768  74.43293
    ##  6  9.270062  74.36868
    ##  7 10.594357  74.47958
    ##  8 11.918651  73.36357
    ##  9 13.242946  72.81420
    ## 10 14.567241  73.17774
    ## # ... with 24 more rows

As always, this data can then be plotted to view trends.

``` r
#Plot average delay by visibility
g1<-ggplot(data=weather_summary,aes(x=wind_gust,y=avg_delay))
g1<-g1+geom_point()
g1
```

![](10-databases_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-10-1.png)

*Quick Exercise* Plot average delay by wind speed.

It's good practice to disconnect from a database when done.

``` r
## Disconnect when done
dbDisconnect(con)
```

`dplyr` also has a way to connect with a database. The advantage AND disadvantage of dplyr is that it's not trying to be like SQL, although it has a full suite of SQL commands plus sql translations built in.

``` r
# The dplyr way:

con <- DBI::dbConnect(RSQLite::SQLite())

copy_to(con, nycflights13::flights, "flights",
  indexes = list(
    c("year", "month", "day"), 
    "carrier", 
    "tailnum",
    "dest"
  ),
  temporary=FALSE
)

# Example only: what you might need for a real company database
# con <- DBI::dbConnect(RMySQL::MySQL(), 
#   host = "database.rstudio.com",
#   user = "hadley",
#   password = rstudioapi::askForPassword("Database password")
#)
```

With a table in memory, we can change it to a tibble and do all the fun `dplyr` stuff.

``` r
## Average flight delay for United
ua_flight_delay <- tbl(con, "flights")%>%tbl_df()%>%filter(carrier=="UA")%>%summarize(mean(arr_delay,na.rm=TRUE))
```

We can also ask for SQL translations of dplyr commands:

``` r
show_query(tally(tbl(con, "flights")))
```

    ## <SQL>
    ## SELECT COUNT() AS `n`
    ## FROM `flights`

A famous database in this area is the Lahman database. This contains data on every baseball player who's played Major League baseball since 1871 (more or less). Even though the wrong teams played in the World Series this year (ie not my beloved San Francisco Giants) I still wanted to show you how this might work.

``` r
## Because it's October

library(Lahman)

batting<-Batting%>%
  tbl_df%>%
  filter(yearID==2015,AB>100)%>%
  select(playerID,AB,H)

master<-Master%>%
  tbl_df()%>%
  select(playerID,nameFirst,nameLast,nameGiven)

bat_full<-left_join(batting,master,by="playerID")

bat_full<-bat_full%>%
  mutate(bat_avg=H/AB)%>%
  arrange(-bat_avg)
## Compare to: http://www.baseball-reference.com/leagues/MLB/2016-batting-leaders.shtml
## Why different?
```

*Quick Exercise* Generate a table with batting averages for every professional player who played college ball for Vanderbilt in the last 20 years.

MY ADVICE
---------

Unless you're going to be a database analyst, do a bare minimum in the DBMS. Instead, use the DBMS to generate tables of manageable size for your computer, then get to work with R. Also, buy low and sell high.
