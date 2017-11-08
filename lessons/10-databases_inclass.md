Working with Databases
================
Will Doyle
November 2, 2016

Introduction
------------

Today, we'll work with the Lahman Database regarding baseball. Every 15 minutes, each group will hand off its work to another group via github.

Our goal is to identify trends in batting, pitching and team stats and to combine these into a dataset that will predict wins and postseason appearances for a team.

Before you start:
-----------------

-   Clone the github repo: <https://github.com/hoddatascifall17/lahman_2017.git>

-   Create a new project from an existing directory for the repo.

-   You'll need to commit your changes to the repo. Make sure that before each commit, you pull, then commit, then push.

Batting Group: filename: `batting.Rmd`
--------------------------------------

1.  Create a dataset that includes all of the batters with at least 100 plate appearances for the years 2011-2015. A plate appearance is the sum for each player of at bats (`AB`), walks (`BB`), hit by pitches (`HBP`), sacrifice hits (`SH`) and sacrifice flies (`SF`). Call the variable plate appearance `PA`.
2.  Calculate the slugging percentage, which is total bases `TB = H + X2B + 2 * X3B + 3 * HR` divided by `AB`
3.  Calculate the on base percentage, which is hits(`H`) plus walks (`BB`) plus hit by pitches (`HBP`) divided by plate apperances (`PA`).
4.  Calculate the on base plus slugging (OPS) stat. This is just the on base percentage plus the slugging percentage.

Pitching Group: filename: `pitching.Rmd`
----------------------------------------

1.  Create a dataset for pitchers with at least 100 innings pitchedfor the years 2011-2015.
2.  For those pitchers, calculate WHIP (Walks plus hits plus innings pitched) which is `BB` plus `H` divided by `IP` for the years 2011-2015.
3.  Again for those pitchers, calculate BABIP (batting average balls in play) which is:`(H-HR) /(BFP-SO-BB-HR)`, total hits minus home runs divided by batters faced less strikeouts, walks and home runs.

Teams Group filename `teams.Rmd`
--------------------------------

1.  Create a dataset that includes wins, losses, rank and a postseason indicator (Division winner or Wild Card Winner) for every team for the years 2011-2015.
2.  From the salaries table, create a variable for total salary for the team for each season.
3.  From the allstar table, create a variable for number of players that were all stars.

All Groups
----------

Merge the teams, batting and pitching datasets. Summarize these at the team level. Use the predictors to predict games won and postseason appearance. Which teams have the highest predicted number of wins? Which teams have the highest probability of postseason apperances?

Some code to get you started
----------------------------

Lahman database, just table for college playing.

``` r
library(Lahman)
library(RSQLite)
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

Model for wins, using only runs (`R`) as a predictor

`win_mod<-lm(W~R,data=team_data)`

Prediction:

`win_predict<-predict(win_mod)`

Model for postseason, using only runs (`R`) as a predictor

`post_mod<-glm(post~R,data=team_data,family=binomial, link="logit")`
