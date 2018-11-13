Assignment 8 Key
================

Libraries
---------

``` r
library(arm)
```

    ## Loading required package: MASS

    ## Loading required package: Matrix

    ## Loading required package: lme4

    ## 
    ## arm (Version 1.10-1, built: 2018-4-12)

    ## Working directory is /Users/doylewr/hoddatasci_fall18/assignments

``` r
library(modelr)
library(AUC)
```

    ## AUC 0.3.0

    ## Type AUCNews() to see the change log and ?AUC to get an overview.

``` r
library(knitr)
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.1.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.7
    ## ✔ tidyr   0.8.2     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ── Conflicts ────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ tidyr::expand() masks Matrix::expand()
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ✖ dplyr::select() masks MASS::select()

Read in Data
------------

``` r
tr<-read_csv("training.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_character(),
    ##   RefId = col_integer(),
    ##   IsBadBuy = col_integer(),
    ##   VehYear = col_integer(),
    ##   VehicleAge = col_integer(),
    ##   VehOdo = col_integer(),
    ##   BYRNO = col_integer(),
    ##   VNZIP1 = col_integer(),
    ##   VehBCost = col_integer(),
    ##   IsOnlineSale = col_integer(),
    ##   WarrantyCost = col_integer()
    ## )

    ## See spec(...) for full column specifications.

    ## Warning in rbind(names(probs), probs_f): number of columns of result is not
    ## a multiple of vector length (arg 1)

    ## Warning: 68 parsing failures.
    ## row # A tibble: 5 x 5 col     row col      expected               actual file           expected   <int> <chr>    <chr>                  <chr>  <chr>          actual 1  6264 VehBCost no trailing characters .02    'training.csv' file 2 15331 VehBCost no trailing characters .57    'training.csv' row 3 18602 VehBCost no trailing characters .85    'training.csv' col 4 19133 VehBCost no trailing characters .79    'training.csv' expected 5 20846 VehBCost no trailing characters .47    'training.csv'
    ## ... ................. ... ............................................................. ........ ............................................................. ...... ............................................................. .... ............................................................. ... ............................................................. ... ............................................................. ........ .............................................................
    ## See problems(...) for more details.

``` r
test<-read_csv("test.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_character(),
    ##   RefId = col_integer(),
    ##   VehYear = col_integer(),
    ##   VehicleAge = col_integer(),
    ##   VehOdo = col_integer(),
    ##   MMRAcquisitionAuctionAveragePrice = col_integer(),
    ##   MMRAcquisitionAuctionCleanPrice = col_integer(),
    ##   MMRAcquisitionRetailAveragePrice = col_integer(),
    ##   MMRAcquisitonRetailCleanPrice = col_integer(),
    ##   BYRNO = col_integer(),
    ##   VNZIP1 = col_integer(),
    ##   VehBCost = col_integer(),
    ##   IsOnlineSale = col_integer(),
    ##   WarrantyCost = col_integer()
    ## )
    ## See spec(...) for full column specifications.

    ## Warning in rbind(names(probs), probs_f): number of columns of result is not
    ## a multiple of vector length (arg 1)

    ## Warning: 69 parsing failures.
    ## row # A tibble: 5 x 5 col     row col                               expected   actual file       expected   <int> <chr>                             <chr>      <chr>  <chr>      actual 1  2316 MMRAcquisitionAuctionAveragePrice an integer NULL   'test.csv' file 2  2316 MMRAcquisitionAuctionCleanPrice   an integer NULL   'test.csv' row 3  2316 MMRAcquisitionRetailAveragePrice  an integer NULL   'test.csv' col 4  2316 MMRAcquisitonRetailCleanPrice     an integer NULL   'test.csv' expected 5  2418 MMRAcquisitionAuctionAveragePrice an integer NULL   'test.csv'
    ## ... ................. ... ...................................................................... ........ ...................................................................... ...... ...................................................................... .... ...................................................................... ... ...................................................................... ... ...................................................................... ........ ......................................................................
    ## See problems(...) for more details.

1. Calculate the proportion of lemons in the training dataset using the `IsBadBuy` variable.
--------------------------------------------------------------------------------------------

``` r
tr%>%summarize(mean(IsBadBuy))
```

    ## # A tibble: 1 x 1
    ##   `mean(IsBadBuy)`
    ##              <dbl>
    ## 1            0.123

2. Calculate the proportion of lemons by Make.
----------------------------------------------

``` r
tr%>%
  group_by(Make)%>%
  summarize(mean_lemon=mean(IsBadBuy))%>%
  arrange(-mean_lemon)%>%
  kable()
```

| Make         |  mean\_lemon|
|:-------------|------------:|
| PLYMOUTH     |    0.5000000|
| LEXUS        |    0.3548387|
| INFINITI     |    0.3333333|
| MINI         |    0.3333333|
| LINCOLN      |    0.2989691|
| ACURA        |    0.2727273|
| SUBARU       |    0.2142857|
| OLDSMOBILE   |    0.2016461|
| MERCURY      |    0.1697700|
| MAZDA        |    0.1613892|
| NISSAN       |    0.1597122|
| BUICK        |    0.1569444|
| JEEP         |    0.1545012|
| FORD         |    0.1540911|
| CADILLAC     |    0.1515152|
| SUZUKI       |    0.1468373|
| VOLKSWAGEN   |    0.1417910|
| SATURN       |    0.1414702|
| HYUNDAI      |    0.1286582|
| CHRYSLER     |    0.1285617|
| MITSUBISHI   |    0.1194175|
| PONTIAC      |    0.1190700|
| KIA          |    0.1175523|
| GMC          |    0.1155624|
| HONDA        |    0.1086519|
| DODGE        |    0.1032373|
| TOYOTA       |    0.0996503|
| CHEVROLET    |    0.0974606|
| SCION        |    0.0852713|
| ISUZU        |    0.0671642|
| HUMMER       |    0.0000000|
| TOYOTA SCION |    0.0000000|
| VOLVO        |    0.0000000|

Data Wrangling: Model and Year are going to be highly predicitve, but I want to only take the 100 or so most common
-------------------------------------------------------------------------------------------------------------------

``` r
model_prop=.001

tr<-tr%>%mutate(new_model_lump=fct_lump(as_factor(Model),prop = model_prop))

test<-test%>%mutate(new_model_lump=fct_lump(as_factor(Model),prop=model_prop))
           
miss_levels<-levels(test$new_model_lump)[!(levels(test$new_model_lump)%in%levels(tr$new_model_lump))]

test<-test%>%mutate(new_model_lump=ifelse(as.character(new_model_lump)%in%miss_levels,
                                          "Other",
                                          as.character(new_model_lump)))%>%
  mutate(new_model_lump=as_factor(new_model_lump))
```

4. Now, predict the probability of being a lemon using a linear model (`lm(y~x`), with covariates of your choosing from the training dataset.
---------------------------------------------------------------------------------------------------------------------------------------------

``` r
mod_lm<-lm(IsBadBuy~
             as.factor(VehYear)+
             as.factor(new_model_lump)+
             VehicleAge+
             Auction+
             WarrantyCost,
           data=tr);summary(mod_lm)
```

    ## 
    ## Call:
    ## lm(formula = IsBadBuy ~ as.factor(VehYear) + as.factor(new_model_lump) + 
    ##     VehicleAge + Auction + WarrantyCost, data = tr)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.49938 -0.14649 -0.09822 -0.04961  1.04187 
    ## 
    ## Coefficients:
    ##                                                 Estimate Std. Error
    ## (Intercept)                                   -2.525e-02  4.074e-02
    ## as.factor(VehYear)2002                        -1.500e-02  1.081e-02
    ## as.factor(VehYear)2003                        -3.285e-02  1.199e-02
    ## as.factor(VehYear)2004                        -2.304e-02  1.436e-02
    ## as.factor(VehYear)2005                        -1.721e-02  1.716e-02
    ## as.factor(VehYear)2006                        -2.258e-02  2.035e-02
    ## as.factor(VehYear)2007                        -1.771e-02  2.362e-02
    ## as.factor(VehYear)2008                        -2.671e-02  2.728e-02
    ## as.factor(VehYear)2009                        -2.318e-02  3.207e-02
    ## as.factor(VehYear)2010                        -3.283e-02  3.237e-01
    ## as.factor(new_model_lump)1500 RAM PICKUP 2WD   1.527e-02  2.469e-02
    ## as.factor(new_model_lump)STRATUS V6           -8.833e-03  2.654e-02
    ## as.factor(new_model_lump)NEON                  1.223e-01  2.814e-02
    ## as.factor(new_model_lump)FOCUS                 4.819e-02  2.504e-02
    ## as.factor(new_model_lump)GALANT 4C             5.609e-03  2.920e-02
    ## as.factor(new_model_lump)SPECTRA               4.523e-02  2.589e-02
    ## as.factor(new_model_lump)TAURUS                3.547e-02  2.419e-02
    ## as.factor(new_model_lump)FIVE HUNDRED         -9.187e-03  2.674e-02
    ## as.factor(new_model_lump)1500 SIERRA PICKUP 2 -3.492e-02  3.605e-02
    ## as.factor(new_model_lump)F150 PICKUP 2WD V6    4.416e-02  3.675e-02
    ## as.factor(new_model_lump)CARAVAN GRAND FWD V6  1.266e-02  2.453e-02
    ## as.factor(new_model_lump)ALTIMA                2.308e-02  2.580e-02
    ## as.factor(new_model_lump)CAVALIER 4C           5.854e-02  3.088e-02
    ## as.factor(new_model_lump)TRAILBLAZER 2WD 6C   -1.342e-02  2.687e-02
    ## as.factor(new_model_lump)VUE 2WD 4C            5.644e-03  3.352e-02
    ## as.factor(new_model_lump)IMPALA               -3.456e-02  2.404e-02
    ## as.factor(new_model_lump)MONTE CARLO           7.461e-03  3.325e-02
    ## as.factor(new_model_lump)VENTURE FWD V6       -1.244e-01  3.539e-02
    ## as.factor(new_model_lump)HHR                   2.965e-02  2.651e-02
    ## as.factor(new_model_lump)SABLE                 2.853e-02  3.292e-02
    ## as.factor(new_model_lump)DURANGO 4WD V8       -8.025e-03  2.832e-02
    ## as.factor(new_model_lump)EXPLORER 2WD V6       1.283e-01  3.079e-02
    ## as.factor(new_model_lump)300                   2.093e-02  3.085e-02
    ## as.factor(new_model_lump)MUSTANG V6            6.763e-02  2.917e-02
    ## as.factor(new_model_lump)AVALANCHE 1500 2WD V -3.332e-02  3.822e-02
    ## as.factor(new_model_lump)WINDSTAR FWD V6       1.663e-01  3.820e-02
    ## as.factor(new_model_lump)FREESTAR FWD V6      -5.828e-04  2.904e-02
    ## as.factor(new_model_lump)SONATA V6             3.232e-02  3.035e-02
    ## as.factor(new_model_lump)CALIBER               8.179e-02  2.447e-02
    ## as.factor(new_model_lump)SENTRA                7.766e-02  2.982e-02
    ## as.factor(new_model_lump)PACIFICA FWD          1.123e-02  2.736e-02
    ## as.factor(new_model_lump)IMPALA V6            -2.353e-02  2.524e-02
    ## as.factor(new_model_lump)XTERRA 2WD V6         1.768e-01  3.865e-02
    ## as.factor(new_model_lump)COROLLA               2.175e-02  3.315e-02
    ## as.factor(new_model_lump)G6 V6                 2.466e-03  2.645e-02
    ## as.factor(new_model_lump)ION                   6.170e-02  2.563e-02
    ## as.factor(new_model_lump)DURANGO 2WD V8       -2.837e-02  2.700e-02
    ## as.factor(new_model_lump)FUSION 4C             6.095e-02  2.777e-02
    ## as.factor(new_model_lump)GRAND PRIX           -2.119e-02  2.533e-02
    ## as.factor(new_model_lump)SEBRING V6            5.434e-02  2.694e-02
    ## as.factor(new_model_lump)FORENZA               1.131e-01  2.598e-02
    ## as.factor(new_model_lump)LIBERTY 2WD V6       -8.359e-03  3.078e-02
    ## as.factor(new_model_lump)DAKOTA PICKUP 2WD V6  5.640e-02  3.312e-02
    ## as.factor(new_model_lump)TAHOE 2WD            -1.053e-01  3.972e-02
    ## as.factor(new_model_lump)COBALT                6.810e-02  2.463e-02
    ## as.factor(new_model_lump)EXPEDITION 2WD V8     8.764e-02  3.053e-02
    ## as.factor(new_model_lump)SUNFIRE               6.543e-02  4.111e-02
    ## as.factor(new_model_lump)F150 PICKUP 2WD V8    4.348e-02  2.886e-02
    ## as.factor(new_model_lump)TRAILBLAZER EXT 2WD   9.819e-03  3.217e-02
    ## as.factor(new_model_lump)PT CRUISER            9.780e-02  2.362e-02
    ## as.factor(new_model_lump)DURANGO 2WD V6        2.219e-02  3.516e-02
    ## as.factor(new_model_lump)MALIBU V6            -1.219e-02  2.629e-02
    ## as.factor(new_model_lump)TOWN & COUNTRY FWD V  1.772e-03  2.709e-02
    ## as.factor(new_model_lump)MAGNUM V6            -4.954e-03  3.188e-02
    ## as.factor(new_model_lump)EQUINOX FWD V6        1.010e-02  2.874e-02
    ## as.factor(new_model_lump)STRATUS 4C            4.511e-02  2.683e-02
    ## as.factor(new_model_lump)MAZDA6                7.901e-02  2.977e-02
    ## as.factor(new_model_lump)CAMRY 4C             -6.230e-03  2.816e-02
    ## as.factor(new_model_lump)FREESTYLE FWD V6      1.183e-02  3.536e-02
    ## as.factor(new_model_lump)L SERIES              3.584e-02  3.327e-02
    ## as.factor(new_model_lump)RENO                  8.722e-02  3.911e-02
    ## as.factor(new_model_lump)SEBRING 4C            2.047e-02  2.463e-02
    ## as.factor(new_model_lump)OPTIMA 4C             5.290e-02  2.936e-02
    ## as.factor(new_model_lump)RANGER PICKUP 2WD V6  2.226e-02  3.537e-02
    ## as.factor(new_model_lump)G6 4C                 5.114e-02  2.844e-02
    ## as.factor(new_model_lump)ENVOY 2WD 6C         -5.200e-02  4.128e-02
    ## as.factor(new_model_lump)ACCENT                5.891e-02  3.404e-02
    ## as.factor(new_model_lump)UPLANDER FWD V6      -2.678e-02  2.686e-02
    ## as.factor(new_model_lump)ELANTRA               2.030e-02  2.861e-02
    ## as.factor(new_model_lump)1500 SILVERADO PICKU -3.219e-02  2.627e-02
    ## as.factor(new_model_lump)EXPLORER 4WD V6       1.189e-01  3.507e-02
    ## as.factor(new_model_lump)ESCAPE 2WD V6         2.453e-02  3.303e-02
    ## as.factor(new_model_lump)CARAVAN FWD V6       -7.200e-02  2.988e-02
    ## as.factor(new_model_lump)SONATA 4C             4.088e-02  3.202e-02
    ## as.factor(new_model_lump)RENDEZVOUS FWD       -7.335e-02  4.212e-02
    ## as.factor(new_model_lump)ACCORD 4C            -1.262e-03  3.301e-02
    ## as.factor(new_model_lump)ESCAPE 2WD 4C         4.279e-02  3.422e-02
    ## as.factor(new_model_lump)MALIBU MAXX V6       -1.320e-02  3.042e-02
    ## as.factor(new_model_lump)COLORADO PICKUP 2WD  -1.451e-02  3.588e-02
    ## as.factor(new_model_lump)GRAND CHEROKEE 2WD V  2.830e-02  3.004e-02
    ## as.factor(new_model_lump)MALIBU 4C            -8.768e-03  2.443e-02
    ## as.factor(new_model_lump)AVEO                  1.251e-01  2.797e-02
    ## as.factor(new_model_lump)CHARGER V6            1.874e-02  2.942e-02
    ## as.factor(new_model_lump)AVENGER 4C            3.943e-02  2.616e-02
    ## as.factor(new_model_lump)RIO                   6.965e-02  3.212e-02
    ## as.factor(new_model_lump)FUSION V6            -2.200e-04  3.258e-02
    ## as.factor(new_model_lump)VIBE                  4.967e-02  3.563e-02
    ## as.factor(new_model_lump)TOWN & COUNTRY 2WD V -1.552e-02  2.823e-02
    ## as.factor(new_model_lump)CHARGER               2.770e-02  3.890e-02
    ## as.factor(new_model_lump)SABLE 3.0L V6 EFI     9.628e-02  4.054e-02
    ## as.factor(new_model_lump)PACIFICA FWD 3.5L V6 -6.373e-03  2.924e-02
    ## as.factor(new_model_lump)IMPALA 3.5L V6 SFI   -3.784e-02  2.578e-02
    ## as.factor(new_model_lump)COBALT 2.2L I4 MPI    1.995e-02  2.768e-02
    ## as.factor(new_model_lump)UPLANDER FWD V6 3.9L -2.658e-02  3.537e-02
    ## as.factor(new_model_lump)EXPEDITION 4WD V8 5.  5.687e-02  4.147e-02
    ## as.factor(new_model_lump)MALIBU V6 3.5L V6 SF  2.838e-03  2.944e-02
    ## as.factor(new_model_lump)LIBERTY 4WD V6 3.7L   3.183e-03  3.460e-02
    ## as.factor(new_model_lump)IMPALA 3.4L V6 SFI   -5.064e-03  2.725e-02
    ## as.factor(new_model_lump)CHARGER V6 2.7L V6 M  4.553e-02  3.775e-02
    ## as.factor(new_model_lump)300 2.7L V6 MPI       1.607e-03  3.348e-02
    ## as.factor(new_model_lump)MAGNUM V6 2.7L V6 MP -2.948e-03  3.103e-02
    ## as.factor(new_model_lump)ION 2.2L I4 EFI / SF  7.676e-02  4.322e-02
    ## as.factor(new_model_lump)AVEO 1.6L I4 EFI      1.063e-01  4.076e-02
    ## as.factor(new_model_lump)SEBRING 4C 2.4L I4 E  5.374e-02  2.739e-02
    ## as.factor(new_model_lump)MALIBU 4C 2.2L I4 MP  9.477e-03  2.586e-02
    ## as.factor(new_model_lump)FIVE HUNDRED 3.0L V6  2.069e-02  2.766e-02
    ## as.factor(new_model_lump)MALIBU MAXX V6 3.5L   2.803e-02  3.492e-02
    ## as.factor(new_model_lump)SEBRING 4C 2.4L I4 S  4.907e-02  3.478e-02
    ## as.factor(new_model_lump)ELANTRA 2.0L I4 MPI   1.555e-02  3.315e-02
    ## as.factor(new_model_lump)SEBRING V6 2.7L V6 M  4.793e-02  3.320e-02
    ## as.factor(new_model_lump)TRAILBLAZER 4WD 6C 4 -2.624e-02  3.048e-02
    ## as.factor(new_model_lump)PT CRUISER 2.4L I4 M  7.509e-02  3.232e-02
    ## as.factor(new_model_lump)CAVALIER 4C 2.2L I4   4.247e-02  3.003e-02
    ## as.factor(new_model_lump)ALTIMA 2.5L I4 MPI    3.428e-02  3.776e-02
    ## as.factor(new_model_lump)HHR 2.2L I4 MPI       3.811e-02  3.950e-02
    ## as.factor(new_model_lump)STRATUS 4C 2.4L I4 S  8.689e-02  3.316e-02
    ## as.factor(new_model_lump)GRAND PRIX 3.8L V6 S -3.845e-02  2.559e-02
    ## as.factor(new_model_lump)PT CRUISER 2.4L I4 S  4.304e-02  2.486e-02
    ## as.factor(new_model_lump)STRATUS 4C 2.4L I4 M  1.680e-02  2.967e-02
    ## as.factor(new_model_lump)PT CRUISER 2.4L I-4  -6.619e-03  4.306e-02
    ## as.factor(new_model_lump)GRAND AM V6 3.4L V6   2.875e-02  3.397e-02
    ## as.factor(new_model_lump)EQUINOX AWD V6 3.4L   1.684e-02  3.692e-02
    ## as.factor(new_model_lump)FORENZA 2.0L I4 EFI   8.892e-02  2.860e-02
    ## as.factor(new_model_lump)ION 2.2L I4 EFI       6.411e-03  3.175e-02
    ## as.factor(new_model_lump)VENTURE FWD V6 3.4L  -1.357e-01  3.632e-02
    ## as.factor(new_model_lump)MALIBU V6 3.1L V6 SF  1.144e-01  3.784e-02
    ## as.factor(new_model_lump)WINDSTAR FWD V6 3.8L  1.161e-01  3.571e-02
    ## as.factor(new_model_lump)PACIFICA AWD 3.5L V6 -6.191e-02  4.057e-02
    ## as.factor(new_model_lump)EXPLORER 4WD V6 4.0L  5.106e-02  3.794e-02
    ## as.factor(new_model_lump)ESCAPE 2WD V6 3.0L V  9.972e-03  3.634e-02
    ## as.factor(new_model_lump)ACCENT 1.6L I4 MPI    7.615e-02  4.107e-02
    ## as.factor(new_model_lump)OPTIMA 4C 2.4L I4 MP  7.569e-02  3.398e-02
    ## as.factor(new_model_lump)FOCUS 2.0L I4 SFI     5.740e-02  2.947e-02
    ## as.factor(new_model_lump)MONTE CARLO 3.4L V6  -3.118e-02  4.029e-02
    ## as.factor(new_model_lump)LIBERTY 4WD V6        5.179e-02  3.287e-02
    ## as.factor(new_model_lump)CARAVAN FWD 4C        3.804e-02  3.887e-02
    ## as.factor(new_model_lump)GRAND AM V6           8.215e-02  3.511e-02
    ## as.factor(new_model_lump)PACIFICA AWD          1.091e-01  3.932e-02
    ## as.factor(new_model_lump)EQUINOX AWD V6        8.326e-02  3.888e-02
    ## as.factor(new_model_lump)TRAILBLAZER EXT 4WD  -1.820e-02  3.433e-02
    ## as.factor(new_model_lump)LANCER                4.856e-02  3.638e-02
    ## as.factor(new_model_lump)MAXIMA                2.452e-01  4.062e-02
    ## as.factor(new_model_lump)EXPEDITION 4WD V8     9.559e-02  4.219e-02
    ## as.factor(new_model_lump)MILAN 4C              3.587e-02  4.235e-02
    ## as.factor(new_model_lump)CENTURY V6           -2.386e-03  4.252e-02
    ## as.factor(new_model_lump)TRAILBLAZER 4WD 6C   -4.016e-02  3.035e-02
    ## as.factor(new_model_lump)GRAND CHEROKEE 4WD V  6.384e-02  3.592e-02
    ## as.factor(new_model_lump)TAURUS 3.0L V6 EFI    4.247e-02  2.479e-02
    ## as.factor(new_model_lump)SPECTRA 2.0L I4 EFI   3.733e-02  2.991e-02
    ## as.factor(new_model_lump)PACIFICA FWD 3.8L V6  5.149e-02  3.708e-02
    ## as.factor(new_model_lump)CIVIC                 6.688e-02  4.033e-02
    ## as.factor(new_model_lump)TRAILBLAZER 2WD 6C 4 -1.527e-02  2.806e-02
    ## as.factor(new_model_lump)IMPALA V6 3.5L V6 SF -1.717e-02  3.162e-02
    ## as.factor(new_model_lump)MUSTANG V6 3.8L V6 E  9.951e-02  3.842e-02
    ## as.factor(new_model_lump)G6 V6 3.5L V6 SFI    -6.506e-04  3.342e-02
    ## as.factor(new_model_lump)CARAVAN FWD 4C 2.4L   8.256e-02  4.159e-02
    ## as.factor(new_model_lump)EXPLORER 2WD V6 4.0L  1.199e-01  3.079e-02
    ## as.factor(new_model_lump)LIBERTY 2WD V6 3.7L   5.447e-02  3.380e-02
    ## as.factor(new_model_lump)CHARGER 2.7L V6 MPI  -2.319e-02  3.968e-02
    ## as.factor(new_model_lump)DAKOTA PICKUP 2WD V8 -5.564e-03  4.334e-02
    ## as.factor(new_model_lump)AURA V6               3.946e-03  4.395e-02
    ## as.factor(new_model_lump)RANGER PICKUP 2WD 4C  4.259e-02  3.878e-02
    ## as.factor(new_model_lump)MATRIX 2WD            7.670e-02  3.891e-02
    ## as.factor(new_model_lump)F150 PICKUP 2WD V8 5  7.215e-02  4.245e-02
    ## as.factor(new_model_lump)FREESTAR FWD V6 3.9L  1.216e-02  2.858e-02
    ## as.factor(new_model_lump)UPLANDER FWD V6 3.5L -3.042e-02  3.036e-02
    ## as.factor(new_model_lump)DURANGO 2WD V8 4.7L  -3.870e-02  2.961e-02
    ## as.factor(new_model_lump)CALIBER 2.0L I4 SFI   5.549e-02  2.732e-02
    ## as.factor(new_model_lump)F150 PICKUP 2WD V8 4 -2.241e-02  3.302e-02
    ## as.factor(new_model_lump)SORENTO 2WD 3.5L V6   3.130e-02  3.980e-02
    ## as.factor(new_model_lump)EQUINOX FWD V6 3.4L   2.188e-02  3.340e-02
    ## as.factor(new_model_lump)ENVOY 2WD 6C 4.2L I6 -7.029e-02  4.212e-02
    ## as.factor(new_model_lump)TITAN PICKUP 2WD V8  -3.431e-02  3.416e-02
    ## as.factor(new_model_lump)AVENGER 4C 2.4L I4 S  4.502e-02  2.857e-02
    ## as.factor(new_model_lump)CENTURY V6 3.1L V6 S  2.771e-02  3.933e-02
    ## as.factor(new_model_lump)FUSION 4C 2.3L I4 EF  2.553e-02  4.005e-02
    ## as.factor(new_model_lump)FREESTYLE FWD V6 3.0 -4.060e-03  3.575e-02
    ## as.factor(new_model_lump)DURANGO 4WD V8 4.7L  -3.190e-02  3.252e-02
    ## as.factor(new_model_lump)LACROSSE             -4.642e-02  3.977e-02
    ## as.factor(new_model_lump)NEON 2.0L I4 SFI      1.097e-01  2.907e-02
    ## as.factor(new_model_lump)GRAND CHEROKEE 2WD 6  1.842e-02  3.906e-02
    ## as.factor(new_model_lump)LANCER 2.0L I4 MPI    8.390e-02  4.305e-02
    ## as.factor(new_model_lump)EXPEDITION 2WD V8 5.  7.609e-02  3.786e-02
    ## as.factor(new_model_lump)OPTIMA V6             2.097e-02  4.158e-02
    ## as.factor(new_model_lump)CARAVAN FWD V6 3.3L  -7.955e-03  2.850e-02
    ## as.factor(new_model_lump)FOCUS 2.0L I4 SPI     5.389e-02  4.061e-02
    ## as.factor(new_model_lump)STRATUS V6 2.7L V6 M -3.365e-02  2.510e-02
    ## as.factor(new_model_lump)ESCAPE 2WD 4C 2.3L I  2.126e-02  4.384e-02
    ## as.factor(new_model_lump)F150 PICKUP 2WD V6 4  3.693e-02  3.823e-02
    ## as.factor(new_model_lump)SORENTO 2WD           1.085e-01  3.489e-02
    ## as.factor(new_model_lump)DURANGO 2WD V6 3.7L   3.375e-02  4.282e-02
    ## as.factor(new_model_lump)GALANT 4C 2.4L I4 EF  1.696e-02  4.048e-02
    ## as.factor(new_model_lump)ALERO 4C 2.2L I4 MPI  1.714e-03  3.950e-02
    ## as.factor(new_model_lump)SUNFIRE 2.2L I4 MPI   3.313e-02  4.344e-02
    ## as.factor(new_model_lump)EXPEDITION 2WD V8 4. -5.695e-03  3.403e-02
    ## as.factor(new_model_lump)Other                 3.890e-02  2.299e-02
    ## VehicleAge                                     2.799e-02  3.659e-03
    ## AuctionMANHEIM                                -3.573e-02  3.128e-03
    ## AuctionOTHER                                  -1.428e-02  3.755e-03
    ## WarrantyCost                                   3.853e-05  3.637e-06
    ##                                               t value Pr(>|t|)    
    ## (Intercept)                                    -0.620 0.535369    
    ## as.factor(VehYear)2002                         -1.388 0.165153    
    ## as.factor(VehYear)2003                         -2.739 0.006167 ** 
    ## as.factor(VehYear)2004                         -1.604 0.108653    
    ## as.factor(VehYear)2005                         -1.003 0.316045    
    ## as.factor(VehYear)2006                         -1.110 0.267102    
    ## as.factor(VehYear)2007                         -0.750 0.453534    
    ## as.factor(VehYear)2008                         -0.979 0.327610    
    ## as.factor(VehYear)2009                         -0.723 0.469756    
    ## as.factor(VehYear)2010                         -0.101 0.919201    
    ## as.factor(new_model_lump)1500 RAM PICKUP 2WD    0.618 0.536285    
    ## as.factor(new_model_lump)STRATUS V6            -0.333 0.739293    
    ## as.factor(new_model_lump)NEON                   4.345 1.39e-05 ***
    ## as.factor(new_model_lump)FOCUS                  1.924 0.054356 .  
    ## as.factor(new_model_lump)GALANT 4C              0.192 0.847672    
    ## as.factor(new_model_lump)SPECTRA                1.747 0.080695 .  
    ## as.factor(new_model_lump)TAURUS                 1.466 0.142591    
    ## as.factor(new_model_lump)FIVE HUNDRED          -0.344 0.731150    
    ## as.factor(new_model_lump)1500 SIERRA PICKUP 2  -0.969 0.332761    
    ## as.factor(new_model_lump)F150 PICKUP 2WD V6     1.202 0.229541    
    ## as.factor(new_model_lump)CARAVAN GRAND FWD V6   0.516 0.605884    
    ## as.factor(new_model_lump)ALTIMA                 0.894 0.371132    
    ## as.factor(new_model_lump)CAVALIER 4C            1.896 0.058000 .  
    ## as.factor(new_model_lump)TRAILBLAZER 2WD 6C    -0.499 0.617489    
    ## as.factor(new_model_lump)VUE 2WD 4C             0.168 0.866308    
    ## as.factor(new_model_lump)IMPALA                -1.438 0.150477    
    ## as.factor(new_model_lump)MONTE CARLO            0.224 0.822429    
    ## as.factor(new_model_lump)VENTURE FWD V6        -3.514 0.000441 ***
    ## as.factor(new_model_lump)HHR                    1.118 0.263362    
    ## as.factor(new_model_lump)SABLE                  0.867 0.386082    
    ## as.factor(new_model_lump)DURANGO 4WD V8        -0.283 0.776861    
    ## as.factor(new_model_lump)EXPLORER 2WD V6        4.168 3.07e-05 ***
    ## as.factor(new_model_lump)300                    0.679 0.497368    
    ## as.factor(new_model_lump)MUSTANG V6             2.319 0.020418 *  
    ## as.factor(new_model_lump)AVALANCHE 1500 2WD V  -0.872 0.383435    
    ## as.factor(new_model_lump)WINDSTAR FWD V6        4.354 1.34e-05 ***
    ## as.factor(new_model_lump)FREESTAR FWD V6       -0.020 0.983989    
    ## as.factor(new_model_lump)SONATA V6              1.065 0.286830    
    ## as.factor(new_model_lump)CALIBER                3.342 0.000832 ***
    ## as.factor(new_model_lump)SENTRA                 2.604 0.009215 ** 
    ## as.factor(new_model_lump)PACIFICA FWD           0.411 0.681400    
    ## as.factor(new_model_lump)IMPALA V6             -0.932 0.351258    
    ## as.factor(new_model_lump)XTERRA 2WD V6          4.574 4.78e-06 ***
    ## as.factor(new_model_lump)COROLLA                0.656 0.511828    
    ## as.factor(new_model_lump)G6 V6                  0.093 0.925738    
    ## as.factor(new_model_lump)ION                    2.407 0.016075 *  
    ## as.factor(new_model_lump)DURANGO 2WD V8        -1.051 0.293362    
    ## as.factor(new_model_lump)FUSION 4C              2.195 0.028177 *  
    ## as.factor(new_model_lump)GRAND PRIX            -0.837 0.402736    
    ## as.factor(new_model_lump)SEBRING V6             2.017 0.043662 *  
    ## as.factor(new_model_lump)FORENZA                4.352 1.35e-05 ***
    ## as.factor(new_model_lump)LIBERTY 2WD V6        -0.272 0.785937    
    ## as.factor(new_model_lump)DAKOTA PICKUP 2WD V6   1.703 0.088590 .  
    ## as.factor(new_model_lump)TAHOE 2WD             -2.651 0.008024 ** 
    ## as.factor(new_model_lump)COBALT                 2.765 0.005700 ** 
    ## as.factor(new_model_lump)EXPEDITION 2WD V8      2.870 0.004101 ** 
    ## as.factor(new_model_lump)SUNFIRE                1.592 0.111484    
    ## as.factor(new_model_lump)F150 PICKUP 2WD V8     1.507 0.131936    
    ## as.factor(new_model_lump)TRAILBLAZER EXT 2WD    0.305 0.760181    
    ## as.factor(new_model_lump)PT CRUISER             4.141 3.47e-05 ***
    ## as.factor(new_model_lump)DURANGO 2WD V6         0.631 0.528092    
    ## as.factor(new_model_lump)MALIBU V6             -0.464 0.642966    
    ## as.factor(new_model_lump)TOWN & COUNTRY FWD V   0.065 0.947856    
    ## as.factor(new_model_lump)MAGNUM V6             -0.155 0.876534    
    ## as.factor(new_model_lump)EQUINOX FWD V6         0.351 0.725307    
    ## as.factor(new_model_lump)STRATUS 4C             1.682 0.092663 .  
    ## as.factor(new_model_lump)MAZDA6                 2.653 0.007969 ** 
    ## as.factor(new_model_lump)CAMRY 4C              -0.221 0.824900    
    ## as.factor(new_model_lump)FREESTYLE FWD V6       0.334 0.738026    
    ## as.factor(new_model_lump)L SERIES               1.077 0.281318    
    ## as.factor(new_model_lump)RENO                   2.230 0.025731 *  
    ## as.factor(new_model_lump)SEBRING 4C             0.831 0.406002    
    ## as.factor(new_model_lump)OPTIMA 4C              1.802 0.071603 .  
    ## as.factor(new_model_lump)RANGER PICKUP 2WD V6   0.629 0.529168    
    ## as.factor(new_model_lump)G6 4C                  1.798 0.072183 .  
    ## as.factor(new_model_lump)ENVOY 2WD 6C          -1.260 0.207852    
    ## as.factor(new_model_lump)ACCENT                 1.731 0.083516 .  
    ## as.factor(new_model_lump)UPLANDER FWD V6       -0.997 0.318818    
    ## as.factor(new_model_lump)ELANTRA                0.710 0.477885    
    ## as.factor(new_model_lump)1500 SILVERADO PICKU  -1.225 0.220518    
    ## as.factor(new_model_lump)EXPLORER 4WD V6        3.390 0.000698 ***
    ## as.factor(new_model_lump)ESCAPE 2WD V6          0.742 0.457817    
    ## as.factor(new_model_lump)CARAVAN FWD V6        -2.410 0.015967 *  
    ## as.factor(new_model_lump)SONATA 4C              1.277 0.201612    
    ## as.factor(new_model_lump)RENDEZVOUS FWD        -1.741 0.081644 .  
    ## as.factor(new_model_lump)ACCORD 4C             -0.038 0.969512    
    ## as.factor(new_model_lump)ESCAPE 2WD 4C          1.250 0.211155    
    ## as.factor(new_model_lump)MALIBU MAXX V6        -0.434 0.664345    
    ## as.factor(new_model_lump)COLORADO PICKUP 2WD   -0.405 0.685796    
    ## as.factor(new_model_lump)GRAND CHEROKEE 2WD V   0.942 0.346063    
    ## as.factor(new_model_lump)MALIBU 4C             -0.359 0.719704    
    ## as.factor(new_model_lump)AVEO                   4.472 7.78e-06 ***
    ## as.factor(new_model_lump)CHARGER V6             0.637 0.524091    
    ## as.factor(new_model_lump)AVENGER 4C             1.507 0.131789    
    ## as.factor(new_model_lump)RIO                    2.169 0.030111 *  
    ## as.factor(new_model_lump)FUSION V6             -0.007 0.994612    
    ## as.factor(new_model_lump)VIBE                   1.394 0.163335    
    ## as.factor(new_model_lump)TOWN & COUNTRY 2WD V  -0.550 0.582444    
    ## as.factor(new_model_lump)CHARGER                0.712 0.476441    
    ## as.factor(new_model_lump)SABLE 3.0L V6 EFI      2.375 0.017564 *  
    ## as.factor(new_model_lump)PACIFICA FWD 3.5L V6  -0.218 0.827495    
    ## as.factor(new_model_lump)IMPALA 3.5L V6 SFI    -1.468 0.142085    
    ## as.factor(new_model_lump)COBALT 2.2L I4 MPI     0.721 0.470986    
    ## as.factor(new_model_lump)UPLANDER FWD V6 3.9L  -0.751 0.452399    
    ## as.factor(new_model_lump)EXPEDITION 4WD V8 5.   1.371 0.170357    
    ## as.factor(new_model_lump)MALIBU V6 3.5L V6 SF   0.096 0.923211    
    ## as.factor(new_model_lump)LIBERTY 4WD V6 3.7L    0.092 0.926707    
    ## as.factor(new_model_lump)IMPALA 3.4L V6 SFI    -0.186 0.852583    
    ## as.factor(new_model_lump)CHARGER V6 2.7L V6 M   1.206 0.227747    
    ## as.factor(new_model_lump)300 2.7L V6 MPI        0.048 0.961734    
    ## as.factor(new_model_lump)MAGNUM V6 2.7L V6 MP  -0.095 0.924305    
    ## as.factor(new_model_lump)ION 2.2L I4 EFI / SF   1.776 0.075715 .  
    ## as.factor(new_model_lump)AVEO 1.6L I4 EFI       2.608 0.009117 ** 
    ## as.factor(new_model_lump)SEBRING 4C 2.4L I4 E   1.962 0.049756 *  
    ## as.factor(new_model_lump)MALIBU 4C 2.2L I4 MP   0.366 0.714020    
    ## as.factor(new_model_lump)FIVE HUNDRED 3.0L V6   0.748 0.454442    
    ## as.factor(new_model_lump)MALIBU MAXX V6 3.5L    0.803 0.422171    
    ## as.factor(new_model_lump)SEBRING 4C 2.4L I4 S   1.411 0.158281    
    ## as.factor(new_model_lump)ELANTRA 2.0L I4 MPI    0.469 0.639098    
    ## as.factor(new_model_lump)SEBRING V6 2.7L V6 M   1.443 0.148918    
    ## as.factor(new_model_lump)TRAILBLAZER 4WD 6C 4  -0.861 0.389328    
    ## as.factor(new_model_lump)PT CRUISER 2.4L I4 M   2.323 0.020166 *  
    ## as.factor(new_model_lump)CAVALIER 4C 2.2L I4    1.414 0.157222    
    ## as.factor(new_model_lump)ALTIMA 2.5L I4 MPI     0.908 0.363897    
    ## as.factor(new_model_lump)HHR 2.2L I4 MPI        0.965 0.334679    
    ## as.factor(new_model_lump)STRATUS 4C 2.4L I4 S   2.620 0.008800 ** 
    ## as.factor(new_model_lump)GRAND PRIX 3.8L V6 S  -1.503 0.132866    
    ## as.factor(new_model_lump)PT CRUISER 2.4L I4 S   1.731 0.083440 .  
    ## as.factor(new_model_lump)STRATUS 4C 2.4L I4 M   0.566 0.571151    
    ## as.factor(new_model_lump)PT CRUISER 2.4L I-4   -0.154 0.877827    
    ## as.factor(new_model_lump)GRAND AM V6 3.4L V6    0.846 0.397399    
    ## as.factor(new_model_lump)EQUINOX AWD V6 3.4L    0.456 0.648278    
    ## as.factor(new_model_lump)FORENZA 2.0L I4 EFI    3.110 0.001874 ** 
    ## as.factor(new_model_lump)ION 2.2L I4 EFI        0.202 0.839961    
    ## as.factor(new_model_lump)VENTURE FWD V6 3.4L   -3.737 0.000186 ***
    ## as.factor(new_model_lump)MALIBU V6 3.1L V6 SF   3.023 0.002505 ** 
    ## as.factor(new_model_lump)WINDSTAR FWD V6 3.8L   3.250 0.001153 ** 
    ## as.factor(new_model_lump)PACIFICA AWD 3.5L V6  -1.526 0.126978    
    ## as.factor(new_model_lump)EXPLORER 4WD V6 4.0L   1.346 0.178381    
    ## as.factor(new_model_lump)ESCAPE 2WD V6 3.0L V   0.274 0.783790    
    ## as.factor(new_model_lump)ACCENT 1.6L I4 MPI     1.854 0.063679 .  
    ## as.factor(new_model_lump)OPTIMA 4C 2.4L I4 MP   2.227 0.025934 *  
    ## as.factor(new_model_lump)FOCUS 2.0L I4 SFI      1.948 0.051439 .  
    ## as.factor(new_model_lump)MONTE CARLO 3.4L V6   -0.774 0.438915    
    ## as.factor(new_model_lump)LIBERTY 4WD V6         1.576 0.115095    
    ## as.factor(new_model_lump)CARAVAN FWD 4C         0.978 0.327844    
    ## as.factor(new_model_lump)GRAND AM V6            2.340 0.019302 *  
    ## as.factor(new_model_lump)PACIFICA AWD           2.774 0.005540 ** 
    ## as.factor(new_model_lump)EQUINOX AWD V6         2.142 0.032232 *  
    ## as.factor(new_model_lump)TRAILBLAZER EXT 4WD   -0.530 0.596049    
    ## as.factor(new_model_lump)LANCER                 1.335 0.181903    
    ## as.factor(new_model_lump)MAXIMA                 6.038 1.57e-09 ***
    ## as.factor(new_model_lump)EXPEDITION 4WD V8      2.265 0.023486 *  
    ## as.factor(new_model_lump)MILAN 4C               0.847 0.396975    
    ## as.factor(new_model_lump)CENTURY V6            -0.056 0.955243    
    ## as.factor(new_model_lump)TRAILBLAZER 4WD 6C    -1.323 0.185724    
    ## as.factor(new_model_lump)GRAND CHEROKEE 4WD V   1.777 0.075519 .  
    ## as.factor(new_model_lump)TAURUS 3.0L V6 EFI     1.713 0.086671 .  
    ## as.factor(new_model_lump)SPECTRA 2.0L I4 EFI    1.248 0.211895    
    ## as.factor(new_model_lump)PACIFICA FWD 3.8L V6   1.389 0.164933    
    ## as.factor(new_model_lump)CIVIC                  1.658 0.097277 .  
    ## as.factor(new_model_lump)TRAILBLAZER 2WD 6C 4  -0.544 0.586402    
    ## as.factor(new_model_lump)IMPALA V6 3.5L V6 SF  -0.543 0.587217    
    ## as.factor(new_model_lump)MUSTANG V6 3.8L V6 E   2.590 0.009600 ** 
    ## as.factor(new_model_lump)G6 V6 3.5L V6 SFI     -0.019 0.984467    
    ## as.factor(new_model_lump)CARAVAN FWD 4C 2.4L    1.985 0.047138 *  
    ## as.factor(new_model_lump)EXPLORER 2WD V6 4.0L   3.893 9.91e-05 ***
    ## as.factor(new_model_lump)LIBERTY 2WD V6 3.7L    1.612 0.107036    
    ## as.factor(new_model_lump)CHARGER 2.7L V6 MPI   -0.584 0.558958    
    ## as.factor(new_model_lump)DAKOTA PICKUP 2WD V8  -0.128 0.897853    
    ## as.factor(new_model_lump)AURA V6                0.090 0.928462    
    ## as.factor(new_model_lump)RANGER PICKUP 2WD 4C   1.098 0.272106    
    ## as.factor(new_model_lump)MATRIX 2WD             1.971 0.048715 *  
    ## as.factor(new_model_lump)F150 PICKUP 2WD V8 5   1.699 0.089237 .  
    ## as.factor(new_model_lump)FREESTAR FWD V6 3.9L   0.425 0.670522    
    ## as.factor(new_model_lump)UPLANDER FWD V6 3.5L  -1.002 0.316241    
    ## as.factor(new_model_lump)DURANGO 2WD V8 4.7L   -1.307 0.191260    
    ## as.factor(new_model_lump)CALIBER 2.0L I4 SFI    2.031 0.042282 *  
    ## as.factor(new_model_lump)F150 PICKUP 2WD V8 4  -0.679 0.497389    
    ## as.factor(new_model_lump)SORENTO 2WD 3.5L V6    0.786 0.431654    
    ## as.factor(new_model_lump)EQUINOX FWD V6 3.4L    0.655 0.512395    
    ## as.factor(new_model_lump)ENVOY 2WD 6C 4.2L I6  -1.669 0.095209 .  
    ## as.factor(new_model_lump)TITAN PICKUP 2WD V8   -1.004 0.315193    
    ## as.factor(new_model_lump)AVENGER 4C 2.4L I4 S   1.576 0.115077    
    ## as.factor(new_model_lump)CENTURY V6 3.1L V6 S   0.704 0.481141    
    ## as.factor(new_model_lump)FUSION 4C 2.3L I4 EF   0.637 0.523891    
    ## as.factor(new_model_lump)FREESTYLE FWD V6 3.0  -0.114 0.909580    
    ## as.factor(new_model_lump)DURANGO 4WD V8 4.7L   -0.981 0.326659    
    ## as.factor(new_model_lump)LACROSSE              -1.167 0.243133    
    ## as.factor(new_model_lump)NEON 2.0L I4 SFI       3.774 0.000161 ***
    ## as.factor(new_model_lump)GRAND CHEROKEE 2WD 6   0.472 0.637214    
    ## as.factor(new_model_lump)LANCER 2.0L I4 MPI     1.949 0.051294 .  
    ## as.factor(new_model_lump)EXPEDITION 2WD V8 5.   2.010 0.044475 *  
    ## as.factor(new_model_lump)OPTIMA V6              0.504 0.614039    
    ## as.factor(new_model_lump)CARAVAN FWD V6 3.3L   -0.279 0.780188    
    ## as.factor(new_model_lump)FOCUS 2.0L I4 SPI      1.327 0.184478    
    ## as.factor(new_model_lump)STRATUS V6 2.7L V6 M  -1.341 0.180005    
    ## as.factor(new_model_lump)ESCAPE 2WD 4C 2.3L I   0.485 0.627752    
    ## as.factor(new_model_lump)F150 PICKUP 2WD V6 4   0.966 0.333960    
    ## as.factor(new_model_lump)SORENTO 2WD            3.109 0.001881 ** 
    ## as.factor(new_model_lump)DURANGO 2WD V6 3.7L    0.788 0.430634    
    ## as.factor(new_model_lump)GALANT 4C 2.4L I4 EF   0.419 0.675287    
    ## as.factor(new_model_lump)ALERO 4C 2.2L I4 MPI   0.043 0.965382    
    ## as.factor(new_model_lump)SUNFIRE 2.2L I4 MPI    0.763 0.445661    
    ## as.factor(new_model_lump)EXPEDITION 2WD V8 4.  -0.167 0.867090    
    ## as.factor(new_model_lump)Other                  1.692 0.090652 .  
    ## VehicleAge                                      7.649 2.04e-14 ***
    ## AuctionMANHEIM                                -11.421  < 2e-16 ***
    ## AuctionOTHER                                   -3.804 0.000143 ***
    ## WarrantyCost                                   10.592  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.3215 on 72773 degrees of freedom
    ## Multiple R-squared:  0.04445,    Adjusted R-squared:  0.04171 
    ## F-statistic:  16.2 on 209 and 72773 DF,  p-value: < 2.2e-16

5. Make predictions from the linear model.
------------------------------------------

``` r
tr<-tr%>%add_predictions(mod_lm)%>%
  mutate(pred_lm=ifelse(pred<0,0,pred))%>% ## Trim <0s
  mutate(pred_lm=ifelse(pred>1,1,pred)) ## Trim >1s
```

6. Calculate the AUC for the linear predictions from the ROC against the outcome for the training dataset.
----------------------------------------------------------------------------------------------------------

``` r
lm_roc<-roc(predictions =   tr$pred_lm, labels = as.factor(tr$IsBadBuy))
auc(lm_roc)
```

    ## [1] 0.6756595

7. Now, predict the probability of being a lemon using a logistic regression (`glm(y~x,family=binomial(link="logit")`)), again using covariates of your choosing.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

``` r
run_logit=TRUE

if(run_logit==TRUE){
mod_logit<-glm(IsBadBuy~
             as.factor(VehYear)+
             as.factor(new_model_lump)+
             VehicleAge+
             Auction+
             WarrantyCost,
            family=binomial(link="logit"),
           data=tr); print(summary(mod_logit))

save(mod_logit,file="mod_logit.Robject")
}else{
  load("mod_logit.Robject")
  summary(mod_logit)
  }
```

    ## 
    ## Call:
    ## glm(formula = IsBadBuy ~ as.factor(VehYear) + as.factor(new_model_lump) + 
    ##     VehicleAge + Auction + WarrantyCost, family = binomial(link = "logit"), 
    ##     data = tr)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -1.3514  -0.5531  -0.4437  -0.3339   2.8975  
    ## 
    ## Coefficients:
    ##                                                 Estimate Std. Error
    ## (Intercept)                                   -3.702e+00  4.091e-01
    ## as.factor(VehYear)2002                         4.654e-02  8.033e-02
    ## as.factor(VehYear)2003                         2.795e-02  9.788e-02
    ## as.factor(VehYear)2004                         1.581e-01  1.249e-01
    ## as.factor(VehYear)2005                         2.304e-01  1.544e-01
    ## as.factor(VehYear)2006                         1.455e-01  1.872e-01
    ## as.factor(VehYear)2007                         1.320e-01  2.208e-01
    ## as.factor(VehYear)2008                        -1.209e-01  2.602e-01
    ## as.factor(VehYear)2009                        -3.431e-01  3.409e-01
    ## as.factor(VehYear)2010                        -6.432e+00  7.246e+01
    ## as.factor(new_model_lump)1500 RAM PICKUP 2WD   1.964e-01  2.726e-01
    ## as.factor(new_model_lump)STRATUS V6           -1.310e-02  2.937e-01
    ## as.factor(new_model_lump)NEON                  9.327e-01  2.834e-01
    ## as.factor(new_model_lump)FOCUS                 4.829e-01  2.705e-01
    ## as.factor(new_model_lump)GALANT 4C            -9.647e-02  3.457e-01
    ## as.factor(new_model_lump)SPECTRA               4.284e-01  2.899e-01
    ## as.factor(new_model_lump)TAURUS                3.911e-01  2.662e-01
    ## as.factor(new_model_lump)FIVE HUNDRED         -6.353e-03  3.017e-01
    ## as.factor(new_model_lump)1500 SIERRA PICKUP 2 -2.972e-01  4.075e-01
    ## as.factor(new_model_lump)F150 PICKUP 2WD V6    4.260e-01  3.590e-01
    ## as.factor(new_model_lump)CARAVAN GRAND FWD V6  2.441e-01  2.705e-01
    ## as.factor(new_model_lump)ALTIMA                2.384e-01  2.834e-01
    ## as.factor(new_model_lump)CAVALIER 4C           5.187e-01  3.031e-01
    ## as.factor(new_model_lump)TRAILBLAZER 2WD 6C   -4.236e-02  2.931e-01
    ## as.factor(new_model_lump)VUE 2WD 4C            1.754e-01  3.470e-01
    ## as.factor(new_model_lump)IMPALA               -2.285e-01  2.700e-01
    ## as.factor(new_model_lump)MONTE CARLO           2.039e-01  3.275e-01
    ## as.factor(new_model_lump)VENTURE FWD V6       -6.936e-01  3.430e-01
    ## as.factor(new_model_lump)HHR                   2.671e-01  3.042e-01
    ## as.factor(new_model_lump)SABLE                 3.293e-01  3.202e-01
    ## as.factor(new_model_lump)DURANGO 4WD V8        6.583e-02  2.985e-01
    ## as.factor(new_model_lump)EXPLORER 2WD V6       9.431e-01  2.952e-01
    ## as.factor(new_model_lump)300                   3.132e-01  3.351e-01
    ## as.factor(new_model_lump)MUSTANG V6            6.013e-01  2.966e-01
    ## as.factor(new_model_lump)AVALANCHE 1500 2WD V -1.705e-01  3.999e-01
    ## as.factor(new_model_lump)WINDSTAR FWD V6       9.275e-01  3.234e-01
    ## as.factor(new_model_lump)FREESTAR FWD V6       1.093e-01  3.070e-01
    ## as.factor(new_model_lump)SONATA V6             3.464e-01  3.257e-01
    ## as.factor(new_model_lump)CALIBER               9.704e-01  2.734e-01
    ## as.factor(new_model_lump)SENTRA                7.023e-01  3.038e-01
    ## as.factor(new_model_lump)PACIFICA FWD          1.990e-01  2.974e-01
    ## as.factor(new_model_lump)IMPALA V6            -2.989e-01  3.047e-01
    ## as.factor(new_model_lump)XTERRA 2WD V6         1.194e+00  3.337e-01
    ## as.factor(new_model_lump)COROLLA               2.116e-01  3.539e-01
    ## as.factor(new_model_lump)G6 V6                 5.710e-02  3.002e-01
    ## as.factor(new_model_lump)ION                   5.932e-01  2.758e-01
    ## as.factor(new_model_lump)DURANGO 2WD V8       -1.814e-01  2.986e-01
    ## as.factor(new_model_lump)FUSION 4C             6.787e-01  3.048e-01
    ## as.factor(new_model_lump)GRAND PRIX           -4.839e-02  2.799e-01
    ## as.factor(new_model_lump)SEBRING V6            5.879e-01  2.867e-01
    ## as.factor(new_model_lump)FORENZA               1.082e+00  2.777e-01
    ## as.factor(new_model_lump)LIBERTY 2WD V6       -7.575e-02  3.377e-01
    ## as.factor(new_model_lump)DAKOTA PICKUP 2WD V6  5.556e-01  3.248e-01
    ## as.factor(new_model_lump)TAHOE 2WD            -9.085e-01  4.696e-01
    ## as.factor(new_model_lump)COBALT                7.053e-01  2.710e-01
    ## as.factor(new_model_lump)EXPEDITION 2WD V8     7.009e-01  2.975e-01
    ## as.factor(new_model_lump)SUNFIRE               5.680e-01  3.693e-01
    ## as.factor(new_model_lump)F150 PICKUP 2WD V8    4.381e-01  3.007e-01
    ## as.factor(new_model_lump)TRAILBLAZER EXT 2WD   1.889e-01  3.300e-01
    ## as.factor(new_model_lump)PT CRUISER            9.161e-01  2.611e-01
    ## as.factor(new_model_lump)DURANGO 2WD V6        2.962e-01  3.690e-01
    ## as.factor(new_model_lump)MALIBU V6            -4.277e-02  2.892e-01
    ## as.factor(new_model_lump)TOWN & COUNTRY FWD V  1.556e-01  2.894e-01
    ## as.factor(new_model_lump)MAGNUM V6            -1.818e-02  3.656e-01
    ## as.factor(new_model_lump)EQUINOX FWD V6        2.049e-01  3.086e-01
    ## as.factor(new_model_lump)STRATUS 4C            4.777e-01  2.841e-01
    ## as.factor(new_model_lump)MAZDA6                7.308e-01  2.990e-01
    ## as.factor(new_model_lump)CAMRY 4C             -2.052e-01  3.299e-01
    ## as.factor(new_model_lump)FREESTYLE FWD V6      2.406e-01  3.751e-01
    ## as.factor(new_model_lump)L SERIES              3.507e-01  3.119e-01
    ## as.factor(new_model_lump)RENO                  8.800e-01  3.938e-01
    ## as.factor(new_model_lump)SEBRING 4C            1.598e-01  2.826e-01
    ## as.factor(new_model_lump)OPTIMA 4C             5.490e-01  3.119e-01
    ## as.factor(new_model_lump)RANGER PICKUP 2WD V6  2.873e-01  3.509e-01
    ## as.factor(new_model_lump)G6 4C                 5.891e-01  3.137e-01
    ## as.factor(new_model_lump)ENVOY 2WD 6C         -4.110e-01  4.524e-01
    ## as.factor(new_model_lump)ACCENT                5.810e-01  3.426e-01
    ## as.factor(new_model_lump)UPLANDER FWD V6      -1.295e-01  3.049e-01
    ## as.factor(new_model_lump)ELANTRA               1.963e-01  3.111e-01
    ## as.factor(new_model_lump)1500 SILVERADO PICKU -2.396e-01  2.934e-01
    ## as.factor(new_model_lump)EXPLORER 4WD V6       8.432e-01  3.161e-01
    ## as.factor(new_model_lump)ESCAPE 2WD V6         2.843e-01  3.361e-01
    ## as.factor(new_model_lump)CARAVAN FWD V6       -6.781e-01  3.503e-01
    ## as.factor(new_model_lump)SONATA 4C             4.183e-01  3.457e-01
    ## as.factor(new_model_lump)RENDEZVOUS FWD       -3.468e-01  4.106e-01
    ## as.factor(new_model_lump)ACCORD 4C            -2.791e-02  3.624e-01
    ## as.factor(new_model_lump)ESCAPE 2WD 4C         4.555e-01  3.556e-01
    ## as.factor(new_model_lump)MALIBU MAXX V6       -6.533e-02  3.340e-01
    ## as.factor(new_model_lump)COLORADO PICKUP 2WD  -2.612e-01  4.302e-01
    ## as.factor(new_model_lump)GRAND CHEROKEE 2WD V  3.912e-01  3.093e-01
    ## as.factor(new_model_lump)MALIBU 4C            -2.048e-01  2.819e-01
    ## as.factor(new_model_lump)AVEO                  1.142e+00  2.885e-01
    ## as.factor(new_model_lump)CHARGER V6            2.698e-01  3.431e-01
    ## as.factor(new_model_lump)AVENGER 4C            4.055e-01  3.161e-01
    ## as.factor(new_model_lump)RIO                   6.932e-01  3.404e-01
    ## as.factor(new_model_lump)FUSION V6            -2.554e-02  4.035e-01
    ## as.factor(new_model_lump)VIBE                  4.802e-01  3.652e-01
    ## as.factor(new_model_lump)TOWN & COUNTRY 2WD V -1.574e-01  3.354e-01
    ## as.factor(new_model_lump)CHARGER               3.879e-01  4.004e-01
    ## as.factor(new_model_lump)SABLE 3.0L V6 EFI     8.132e-01  3.576e-01
    ## as.factor(new_model_lump)PACIFICA FWD 3.5L V6 -4.537e-02  3.316e-01
    ## as.factor(new_model_lump)IMPALA 3.5L V6 SFI   -6.335e-01  3.177e-01
    ## as.factor(new_model_lump)COBALT 2.2L I4 MPI    1.015e-01  3.198e-01
    ## as.factor(new_model_lump)UPLANDER FWD V6 3.9L -4.094e-01  4.926e-01
    ## as.factor(new_model_lump)EXPEDITION 4WD V8 5.  5.714e-01  3.753e-01
    ## as.factor(new_model_lump)MALIBU V6 3.5L V6 SF  5.601e-02  3.294e-01
    ## as.factor(new_model_lump)LIBERTY 4WD V6 3.7L   8.881e-02  3.704e-01
    ## as.factor(new_model_lump)IMPALA 3.4L V6 SFI    1.308e-01  2.905e-01
    ## as.factor(new_model_lump)CHARGER V6 2.7L V6 M  5.274e-01  4.340e-01
    ## as.factor(new_model_lump)300 2.7L V6 MPI      -3.967e-02  4.048e-01
    ## as.factor(new_model_lump)MAGNUM V6 2.7L V6 MP -1.637e-01  3.849e-01
    ## as.factor(new_model_lump)ION 2.2L I4 EFI / SF  7.425e-01  4.172e-01
    ## as.factor(new_model_lump)AVEO 1.6L I4 EFI      9.823e-01  3.833e-01
    ## as.factor(new_model_lump)SEBRING 4C 2.4L I4 E  5.109e-01  3.202e-01
    ## as.factor(new_model_lump)MALIBU 4C 2.2L I4 MP  6.491e-02  2.922e-01
    ## as.factor(new_model_lump)FIVE HUNDRED 3.0L V6  2.987e-01  3.070e-01
    ## as.factor(new_model_lump)MALIBU MAXX V6 3.5L   3.470e-01  3.647e-01
    ## as.factor(new_model_lump)SEBRING 4C 2.4L I4 S  5.267e-01  3.491e-01
    ## as.factor(new_model_lump)ELANTRA 2.0L I4 MPI   1.521e-01  3.590e-01
    ## as.factor(new_model_lump)SEBRING V6 2.7L V6 M  5.323e-01  3.414e-01
    ## as.factor(new_model_lump)TRAILBLAZER 4WD 6C 4 -5.194e-02  3.224e-01
    ## as.factor(new_model_lump)PT CRUISER 2.4L I4 M  6.588e-01  3.065e-01
    ## as.factor(new_model_lump)CAVALIER 4C 2.2L I4   4.697e-01  3.053e-01
    ## as.factor(new_model_lump)ALTIMA 2.5L I4 MPI    3.192e-01  4.092e-01
    ## as.factor(new_model_lump)HHR 2.2L I4 MPI       3.013e-01  4.699e-01
    ## as.factor(new_model_lump)STRATUS 4C 2.4L I4 S  8.866e-01  3.331e-01
    ## as.factor(new_model_lump)GRAND PRIX 3.8L V6 S -4.032e-01  2.951e-01
    ## as.factor(new_model_lump)PT CRUISER 2.4L I4 S  4.702e-01  2.756e-01
    ## as.factor(new_model_lump)STRATUS 4C 2.4L I4 M  2.415e-01  3.133e-01
    ## as.factor(new_model_lump)PT CRUISER 2.4L I-4   2.020e-01  3.840e-01
    ## as.factor(new_model_lump)GRAND AM V6 3.4L V6   3.798e-01  3.251e-01
    ## as.factor(new_model_lump)EQUINOX AWD V6 3.4L   2.662e-01  3.910e-01
    ## as.factor(new_model_lump)FORENZA 2.0L I4 EFI   8.667e-01  3.043e-01
    ## as.factor(new_model_lump)ION 2.2L I4 EFI      -4.549e-03  3.661e-01
    ## as.factor(new_model_lump)VENTURE FWD V6 3.4L  -7.313e-01  3.580e-01
    ## as.factor(new_model_lump)MALIBU V6 3.1L V6 SF  8.046e-01  3.280e-01
    ## as.factor(new_model_lump)WINDSTAR FWD V6 3.8L  8.297e-01  3.171e-01
    ## as.factor(new_model_lump)PACIFICA AWD 3.5L V6 -6.886e-01  5.280e-01
    ## as.factor(new_model_lump)EXPLORER 4WD V6 4.0L  5.543e-01  3.545e-01
    ## as.factor(new_model_lump)ESCAPE 2WD V6 3.0L V  1.788e-01  3.783e-01
    ## as.factor(new_model_lump)ACCENT 1.6L I4 MPI    7.236e-01  3.901e-01
    ## as.factor(new_model_lump)OPTIMA 4C 2.4L I4 MP  7.333e-01  3.455e-01
    ## as.factor(new_model_lump)FOCUS 2.0L I4 SFI     5.858e-01  3.008e-01
    ## as.factor(new_model_lump)MONTE CARLO 3.4L V6  -1.355e-01  4.234e-01
    ## as.factor(new_model_lump)LIBERTY 4WD V6        4.805e-01  3.196e-01
    ## as.factor(new_model_lump)CARAVAN FWD 4C        4.534e-01  3.749e-01
    ## as.factor(new_model_lump)GRAND AM V6           6.084e-01  3.183e-01
    ## as.factor(new_model_lump)PACIFICA AWD          8.732e-01  3.466e-01
    ## as.factor(new_model_lump)EQUINOX AWD V6        7.954e-01  3.580e-01
    ## as.factor(new_model_lump)TRAILBLAZER EXT 4WD   1.569e-02  3.461e-01
    ## as.factor(new_model_lump)LANCER                4.658e-01  3.620e-01
    ## as.factor(new_model_lump)MAXIMA                1.527e+00  3.370e-01
    ## as.factor(new_model_lump)EXPEDITION 4WD V8     7.147e-01  3.611e-01
    ## as.factor(new_model_lump)MILAN 4C              3.031e-01  5.301e-01
    ## as.factor(new_model_lump)CENTURY V6            1.207e-01  3.768e-01
    ## as.factor(new_model_lump)TRAILBLAZER 4WD 6C   -1.820e-01  3.183e-01
    ## as.factor(new_model_lump)GRAND CHEROKEE 4WD V  6.315e-01  3.365e-01
    ## as.factor(new_model_lump)TAURUS 3.0L V6 EFI    4.623e-01  2.709e-01
    ## as.factor(new_model_lump)SPECTRA 2.0L I4 EFI   2.819e-01  3.406e-01
    ## as.factor(new_model_lump)PACIFICA FWD 3.8L V6  5.710e-01  3.788e-01
    ## as.factor(new_model_lump)CIVIC                 6.044e-01  3.795e-01
    ## as.factor(new_model_lump)TRAILBLAZER 2WD 6C 4 -8.369e-02  3.115e-01
    ## as.factor(new_model_lump)IMPALA V6 3.5L V6 SF -4.925e-01  4.648e-01
    ## as.factor(new_model_lump)MUSTANG V6 3.8L V6 E  8.170e-01  3.415e-01
    ## as.factor(new_model_lump)G6 V6 3.5L V6 SFI    -8.428e-02  4.047e-01
    ## as.factor(new_model_lump)CARAVAN FWD 4C 2.4L   7.640e-01  3.767e-01
    ## as.factor(new_model_lump)EXPLORER 2WD V6 4.0L  9.526e-01  2.977e-01
    ## as.factor(new_model_lump)LIBERTY 2WD V6 3.7L   5.403e-01  3.379e-01
    ## as.factor(new_model_lump)CHARGER 2.7L V6 MPI  -5.260e-01  5.724e-01
    ## as.factor(new_model_lump)DAKOTA PICKUP 2WD V8  7.914e-02  4.272e-01
    ## as.factor(new_model_lump)AURA V6              -3.440e-01  7.639e-01
    ## as.factor(new_model_lump)RANGER PICKUP 2WD 4C  4.226e-01  3.813e-01
    ## as.factor(new_model_lump)MATRIX 2WD            7.631e-01  3.986e-01
    ## as.factor(new_model_lump)F150 PICKUP 2WD V8 5  6.842e-01  3.927e-01
    ## as.factor(new_model_lump)FREESTAR FWD V6 3.9L  2.243e-01  3.077e-01
    ## as.factor(new_model_lump)UPLANDER FWD V6 3.5L -2.308e-01  3.523e-01
    ## as.factor(new_model_lump)DURANGO 2WD V8 4.7L  -3.212e-01  3.352e-01
    ## as.factor(new_model_lump)CALIBER 2.0L I4 SFI   4.742e-01  3.273e-01
    ## as.factor(new_model_lump)F150 PICKUP 2WD V8 4 -2.759e-01  3.869e-01
    ## as.factor(new_model_lump)SORENTO 2WD 3.5L V6   4.139e-01  3.949e-01
    ## as.factor(new_model_lump)EQUINOX FWD V6 3.4L   2.959e-01  3.546e-01
    ## as.factor(new_model_lump)ENVOY 2WD 6C 4.2L I6 -7.102e-01  5.293e-01
    ## as.factor(new_model_lump)TITAN PICKUP 2WD V8  -4.202e-01  4.157e-01
    ## as.factor(new_model_lump)AVENGER 4C 2.4L I4 S  2.161e-01  3.802e-01
    ## as.factor(new_model_lump)CENTURY V6 3.1L V6 S  3.839e-01  3.549e-01
    ## as.factor(new_model_lump)FUSION 4C 2.3L I4 EF  5.370e-02  5.273e-01
    ## as.factor(new_model_lump)FREESTYLE FWD V6 3.0 -6.185e-02  4.312e-01
    ## as.factor(new_model_lump)DURANGO 4WD V8 4.7L  -1.808e-01  3.546e-01
    ## as.factor(new_model_lump)LACROSSE             -5.872e-01  5.266e-01
    ## as.factor(new_model_lump)NEON 2.0L I4 SFI      9.333e-01  2.930e-01
    ## as.factor(new_model_lump)GRAND CHEROKEE 2WD 6  2.951e-01  3.566e-01
    ## as.factor(new_model_lump)LANCER 2.0L I4 MPI    7.671e-01  4.000e-01
    ## as.factor(new_model_lump)EXPEDITION 2WD V8 5.  7.029e-01  3.514e-01
    ## as.factor(new_model_lump)OPTIMA V6             2.185e-01  4.371e-01
    ## as.factor(new_model_lump)CARAVAN FWD V6 3.3L   8.491e-02  3.048e-01
    ## as.factor(new_model_lump)FOCUS 2.0L I4 SPI     5.474e-01  3.658e-01
    ## as.factor(new_model_lump)STRATUS V6 2.7L V6 M -6.733e-01  3.040e-01
    ## as.factor(new_model_lump)ESCAPE 2WD 4C 2.3L I  1.813e-01  4.987e-01
    ## as.factor(new_model_lump)F150 PICKUP 2WD V6 4  4.120e-01  3.758e-01
    ## as.factor(new_model_lump)SORENTO 2WD           9.149e-01  3.230e-01
    ## as.factor(new_model_lump)DURANGO 2WD V6 3.7L   3.919e-01  4.386e-01
    ## as.factor(new_model_lump)GALANT 4C 2.4L I4 EF  1.058e-01  4.531e-01
    ## as.factor(new_model_lump)ALERO 4C 2.2L I4 MPI  1.822e-01  3.765e-01
    ## as.factor(new_model_lump)SUNFIRE 2.2L I4 MPI   3.970e-01  4.081e-01
    ## as.factor(new_model_lump)EXPEDITION 2WD V8 4.  8.162e-02  3.519e-01
    ## as.factor(new_model_lump)Other                 4.203e-01  2.578e-01
    ## VehicleAge                                     2.589e-01  3.511e-02
    ## AuctionMANHEIM                                -3.244e-01  2.868e-02
    ## AuctionOTHER                                  -1.075e-01  3.468e-02
    ## WarrantyCost                                   2.508e-04  2.856e-05
    ##                                               z value Pr(>|z|)    
    ## (Intercept)                                    -9.051  < 2e-16 ***
    ## as.factor(VehYear)2002                          0.579 0.562360    
    ## as.factor(VehYear)2003                          0.286 0.775225    
    ## as.factor(VehYear)2004                          1.266 0.205616    
    ## as.factor(VehYear)2005                          1.492 0.135780    
    ## as.factor(VehYear)2006                          0.777 0.436914    
    ## as.factor(VehYear)2007                          0.598 0.549932    
    ## as.factor(VehYear)2008                         -0.465 0.642282    
    ## as.factor(VehYear)2009                         -1.007 0.314161    
    ## as.factor(VehYear)2010                         -0.089 0.929273    
    ## as.factor(new_model_lump)1500 RAM PICKUP 2WD    0.720 0.471305    
    ## as.factor(new_model_lump)STRATUS V6            -0.045 0.964411    
    ## as.factor(new_model_lump)NEON                   3.291 0.001000 ***
    ## as.factor(new_model_lump)FOCUS                  1.785 0.074223 .  
    ## as.factor(new_model_lump)GALANT 4C             -0.279 0.780207    
    ## as.factor(new_model_lump)SPECTRA                1.478 0.139395    
    ## as.factor(new_model_lump)TAURUS                 1.469 0.141785    
    ## as.factor(new_model_lump)FIVE HUNDRED          -0.021 0.983199    
    ## as.factor(new_model_lump)1500 SIERRA PICKUP 2  -0.729 0.465842    
    ## as.factor(new_model_lump)F150 PICKUP 2WD V6     1.186 0.235483    
    ## as.factor(new_model_lump)CARAVAN GRAND FWD V6   0.902 0.366794    
    ## as.factor(new_model_lump)ALTIMA                 0.841 0.400206    
    ## as.factor(new_model_lump)CAVALIER 4C            1.712 0.086986 .  
    ## as.factor(new_model_lump)TRAILBLAZER 2WD 6C    -0.145 0.885091    
    ## as.factor(new_model_lump)VUE 2WD 4C             0.506 0.613177    
    ## as.factor(new_model_lump)IMPALA                -0.846 0.397439    
    ## as.factor(new_model_lump)MONTE CARLO            0.622 0.533633    
    ## as.factor(new_model_lump)VENTURE FWD V6        -2.022 0.043146 *  
    ## as.factor(new_model_lump)HHR                    0.878 0.379913    
    ## as.factor(new_model_lump)SABLE                  1.028 0.303752    
    ## as.factor(new_model_lump)DURANGO 4WD V8         0.221 0.825447    
    ## as.factor(new_model_lump)EXPLORER 2WD V6        3.195 0.001400 ** 
    ## as.factor(new_model_lump)300                    0.935 0.349929    
    ## as.factor(new_model_lump)MUSTANG V6             2.027 0.042632 *  
    ## as.factor(new_model_lump)AVALANCHE 1500 2WD V  -0.426 0.669901    
    ## as.factor(new_model_lump)WINDSTAR FWD V6        2.868 0.004130 ** 
    ## as.factor(new_model_lump)FREESTAR FWD V6        0.356 0.721839    
    ## as.factor(new_model_lump)SONATA V6              1.063 0.287556    
    ## as.factor(new_model_lump)CALIBER                3.549 0.000386 ***
    ## as.factor(new_model_lump)SENTRA                 2.312 0.020792 *  
    ## as.factor(new_model_lump)PACIFICA FWD           0.669 0.503512    
    ## as.factor(new_model_lump)IMPALA V6             -0.981 0.326584    
    ## as.factor(new_model_lump)XTERRA 2WD V6          3.578 0.000347 ***
    ## as.factor(new_model_lump)COROLLA                0.598 0.549966    
    ## as.factor(new_model_lump)G6 V6                  0.190 0.849144    
    ## as.factor(new_model_lump)ION                    2.151 0.031476 *  
    ## as.factor(new_model_lump)DURANGO 2WD V8        -0.608 0.543481    
    ## as.factor(new_model_lump)FUSION 4C              2.227 0.025953 *  
    ## as.factor(new_model_lump)GRAND PRIX            -0.173 0.862733    
    ## as.factor(new_model_lump)SEBRING V6             2.051 0.040285 *  
    ## as.factor(new_model_lump)FORENZA                3.896 9.80e-05 ***
    ## as.factor(new_model_lump)LIBERTY 2WD V6        -0.224 0.822507    
    ## as.factor(new_model_lump)DAKOTA PICKUP 2WD V6   1.710 0.087197 .  
    ## as.factor(new_model_lump)TAHOE 2WD             -1.934 0.053071 .  
    ## as.factor(new_model_lump)COBALT                 2.602 0.009255 ** 
    ## as.factor(new_model_lump)EXPEDITION 2WD V8      2.356 0.018490 *  
    ## as.factor(new_model_lump)SUNFIRE                1.538 0.124114    
    ## as.factor(new_model_lump)F150 PICKUP 2WD V8     1.457 0.145145    
    ## as.factor(new_model_lump)TRAILBLAZER EXT 2WD    0.573 0.566917    
    ## as.factor(new_model_lump)PT CRUISER             3.509 0.000450 ***
    ## as.factor(new_model_lump)DURANGO 2WD V6         0.803 0.422052    
    ## as.factor(new_model_lump)MALIBU V6             -0.148 0.882446    
    ## as.factor(new_model_lump)TOWN & COUNTRY FWD V   0.538 0.590736    
    ## as.factor(new_model_lump)MAGNUM V6             -0.050 0.960328    
    ## as.factor(new_model_lump)EQUINOX FWD V6         0.664 0.506760    
    ## as.factor(new_model_lump)STRATUS 4C             1.681 0.092731 .  
    ## as.factor(new_model_lump)MAZDA6                 2.444 0.014510 *  
    ## as.factor(new_model_lump)CAMRY 4C              -0.622 0.534067    
    ## as.factor(new_model_lump)FREESTYLE FWD V6       0.642 0.521149    
    ## as.factor(new_model_lump)L SERIES               1.124 0.260895    
    ## as.factor(new_model_lump)RENO                   2.235 0.025428 *  
    ## as.factor(new_model_lump)SEBRING 4C             0.566 0.571719    
    ## as.factor(new_model_lump)OPTIMA 4C              1.760 0.078363 .  
    ## as.factor(new_model_lump)RANGER PICKUP 2WD V6   0.819 0.412894    
    ## as.factor(new_model_lump)G6 4C                  1.878 0.060372 .  
    ## as.factor(new_model_lump)ENVOY 2WD 6C          -0.908 0.363687    
    ## as.factor(new_model_lump)ACCENT                 1.696 0.089912 .  
    ## as.factor(new_model_lump)UPLANDER FWD V6       -0.425 0.671049    
    ## as.factor(new_model_lump)ELANTRA                0.631 0.527956    
    ## as.factor(new_model_lump)1500 SILVERADO PICKU  -0.817 0.414044    
    ## as.factor(new_model_lump)EXPLORER 4WD V6        2.668 0.007640 ** 
    ## as.factor(new_model_lump)ESCAPE 2WD V6          0.846 0.397596    
    ## as.factor(new_model_lump)CARAVAN FWD V6        -1.936 0.052918 .  
    ## as.factor(new_model_lump)SONATA 4C              1.210 0.226365    
    ## as.factor(new_model_lump)RENDEZVOUS FWD        -0.845 0.398328    
    ## as.factor(new_model_lump)ACCORD 4C             -0.077 0.938602    
    ## as.factor(new_model_lump)ESCAPE 2WD 4C          1.281 0.200284    
    ## as.factor(new_model_lump)MALIBU MAXX V6        -0.196 0.844897    
    ## as.factor(new_model_lump)COLORADO PICKUP 2WD   -0.607 0.543730    
    ## as.factor(new_model_lump)GRAND CHEROKEE 2WD V   1.265 0.205884    
    ## as.factor(new_model_lump)MALIBU 4C             -0.727 0.467450    
    ## as.factor(new_model_lump)AVEO                   3.960 7.51e-05 ***
    ## as.factor(new_model_lump)CHARGER V6             0.786 0.431659    
    ## as.factor(new_model_lump)AVENGER 4C             1.283 0.199560    
    ## as.factor(new_model_lump)RIO                    2.037 0.041674 *  
    ## as.factor(new_model_lump)FUSION V6             -0.063 0.949527    
    ## as.factor(new_model_lump)VIBE                   1.315 0.188475    
    ## as.factor(new_model_lump)TOWN & COUNTRY 2WD V  -0.469 0.638788    
    ## as.factor(new_model_lump)CHARGER                0.969 0.332672    
    ## as.factor(new_model_lump)SABLE 3.0L V6 EFI      2.274 0.022953 *  
    ## as.factor(new_model_lump)PACIFICA FWD 3.5L V6  -0.137 0.891161    
    ## as.factor(new_model_lump)IMPALA 3.5L V6 SFI    -1.994 0.046143 *  
    ## as.factor(new_model_lump)COBALT 2.2L I4 MPI     0.317 0.750917    
    ## as.factor(new_model_lump)UPLANDER FWD V6 3.9L  -0.831 0.405957    
    ## as.factor(new_model_lump)EXPEDITION 4WD V8 5.   1.523 0.127867    
    ## as.factor(new_model_lump)MALIBU V6 3.5L V6 SF   0.170 0.864998    
    ## as.factor(new_model_lump)LIBERTY 4WD V6 3.7L    0.240 0.810506    
    ## as.factor(new_model_lump)IMPALA 3.4L V6 SFI     0.450 0.652489    
    ## as.factor(new_model_lump)CHARGER V6 2.7L V6 M   1.215 0.224285    
    ## as.factor(new_model_lump)300 2.7L V6 MPI       -0.098 0.921937    
    ## as.factor(new_model_lump)MAGNUM V6 2.7L V6 MP  -0.425 0.670636    
    ## as.factor(new_model_lump)ION 2.2L I4 EFI / SF   1.780 0.075093 .  
    ## as.factor(new_model_lump)AVEO 1.6L I4 EFI       2.563 0.010390 *  
    ## as.factor(new_model_lump)SEBRING 4C 2.4L I4 E   1.596 0.110583    
    ## as.factor(new_model_lump)MALIBU 4C 2.2L I4 MP   0.222 0.824192    
    ## as.factor(new_model_lump)FIVE HUNDRED 3.0L V6   0.973 0.330637    
    ## as.factor(new_model_lump)MALIBU MAXX V6 3.5L    0.951 0.341414    
    ## as.factor(new_model_lump)SEBRING 4C 2.4L I4 S   1.509 0.131331    
    ## as.factor(new_model_lump)ELANTRA 2.0L I4 MPI    0.424 0.671872    
    ## as.factor(new_model_lump)SEBRING V6 2.7L V6 M   1.559 0.118999    
    ## as.factor(new_model_lump)TRAILBLAZER 4WD 6C 4  -0.161 0.872014    
    ## as.factor(new_model_lump)PT CRUISER 2.4L I4 M   2.150 0.031581 *  
    ## as.factor(new_model_lump)CAVALIER 4C 2.2L I4    1.539 0.123898    
    ## as.factor(new_model_lump)ALTIMA 2.5L I4 MPI     0.780 0.435309    
    ## as.factor(new_model_lump)HHR 2.2L I4 MPI        0.641 0.521329    
    ## as.factor(new_model_lump)STRATUS 4C 2.4L I4 S   2.662 0.007771 ** 
    ## as.factor(new_model_lump)GRAND PRIX 3.8L V6 S  -1.366 0.171831    
    ## as.factor(new_model_lump)PT CRUISER 2.4L I4 S   1.706 0.088013 .  
    ## as.factor(new_model_lump)STRATUS 4C 2.4L I4 M   0.771 0.440893    
    ## as.factor(new_model_lump)PT CRUISER 2.4L I-4    0.526 0.598813    
    ## as.factor(new_model_lump)GRAND AM V6 3.4L V6    1.168 0.242727    
    ## as.factor(new_model_lump)EQUINOX AWD V6 3.4L    0.681 0.495996    
    ## as.factor(new_model_lump)FORENZA 2.0L I4 EFI    2.848 0.004403 ** 
    ## as.factor(new_model_lump)ION 2.2L I4 EFI       -0.012 0.990087    
    ## as.factor(new_model_lump)VENTURE FWD V6 3.4L   -2.043 0.041091 *  
    ## as.factor(new_model_lump)MALIBU V6 3.1L V6 SF   2.453 0.014149 *  
    ## as.factor(new_model_lump)WINDSTAR FWD V6 3.8L   2.617 0.008883 ** 
    ## as.factor(new_model_lump)PACIFICA AWD 3.5L V6  -1.304 0.192156    
    ## as.factor(new_model_lump)EXPLORER 4WD V6 4.0L   1.564 0.117899    
    ## as.factor(new_model_lump)ESCAPE 2WD V6 3.0L V   0.473 0.636495    
    ## as.factor(new_model_lump)ACCENT 1.6L I4 MPI     1.855 0.063605 .  
    ## as.factor(new_model_lump)OPTIMA 4C 2.4L I4 MP   2.123 0.033791 *  
    ## as.factor(new_model_lump)FOCUS 2.0L I4 SFI      1.947 0.051503 .  
    ## as.factor(new_model_lump)MONTE CARLO 3.4L V6   -0.320 0.748979    
    ## as.factor(new_model_lump)LIBERTY 4WD V6         1.503 0.132774    
    ## as.factor(new_model_lump)CARAVAN FWD 4C         1.209 0.226508    
    ## as.factor(new_model_lump)GRAND AM V6            1.912 0.055929 .  
    ## as.factor(new_model_lump)PACIFICA AWD           2.519 0.011772 *  
    ## as.factor(new_model_lump)EQUINOX AWD V6         2.222 0.026276 *  
    ## as.factor(new_model_lump)TRAILBLAZER EXT 4WD    0.045 0.963849    
    ## as.factor(new_model_lump)LANCER                 1.287 0.198196    
    ## as.factor(new_model_lump)MAXIMA                 4.532 5.83e-06 ***
    ## as.factor(new_model_lump)EXPEDITION 4WD V8      1.979 0.047801 *  
    ## as.factor(new_model_lump)MILAN 4C               0.572 0.567424    
    ## as.factor(new_model_lump)CENTURY V6             0.320 0.748713    
    ## as.factor(new_model_lump)TRAILBLAZER 4WD 6C    -0.572 0.567539    
    ## as.factor(new_model_lump)GRAND CHEROKEE 4WD V   1.876 0.060611 .  
    ## as.factor(new_model_lump)TAURUS 3.0L V6 EFI     1.706 0.087946 .  
    ## as.factor(new_model_lump)SPECTRA 2.0L I4 EFI    0.828 0.407823    
    ## as.factor(new_model_lump)PACIFICA FWD 3.8L V6   1.508 0.131641    
    ## as.factor(new_model_lump)CIVIC                  1.593 0.111250    
    ## as.factor(new_model_lump)TRAILBLAZER 2WD 6C 4  -0.269 0.788216    
    ## as.factor(new_model_lump)IMPALA V6 3.5L V6 SF  -1.060 0.289304    
    ## as.factor(new_model_lump)MUSTANG V6 3.8L V6 E   2.392 0.016742 *  
    ## as.factor(new_model_lump)G6 V6 3.5L V6 SFI     -0.208 0.835022    
    ## as.factor(new_model_lump)CARAVAN FWD 4C 2.4L    2.028 0.042553 *  
    ## as.factor(new_model_lump)EXPLORER 2WD V6 4.0L   3.200 0.001373 ** 
    ## as.factor(new_model_lump)LIBERTY 2WD V6 3.7L    1.599 0.109890    
    ## as.factor(new_model_lump)CHARGER 2.7L V6 MPI   -0.919 0.358103    
    ## as.factor(new_model_lump)DAKOTA PICKUP 2WD V8   0.185 0.853045    
    ## as.factor(new_model_lump)AURA V6               -0.450 0.652484    
    ## as.factor(new_model_lump)RANGER PICKUP 2WD 4C   1.108 0.267736    
    ## as.factor(new_model_lump)MATRIX 2WD             1.914 0.055569 .  
    ## as.factor(new_model_lump)F150 PICKUP 2WD V8 5   1.742 0.081463 .  
    ## as.factor(new_model_lump)FREESTAR FWD V6 3.9L   0.729 0.466076    
    ## as.factor(new_model_lump)UPLANDER FWD V6 3.5L  -0.655 0.512297    
    ## as.factor(new_model_lump)DURANGO 2WD V8 4.7L   -0.958 0.337817    
    ## as.factor(new_model_lump)CALIBER 2.0L I4 SFI    1.449 0.147328    
    ## as.factor(new_model_lump)F150 PICKUP 2WD V8 4  -0.713 0.475832    
    ## as.factor(new_model_lump)SORENTO 2WD 3.5L V6    1.048 0.294664    
    ## as.factor(new_model_lump)EQUINOX FWD V6 3.4L    0.834 0.404066    
    ## as.factor(new_model_lump)ENVOY 2WD 6C 4.2L I6  -1.342 0.179707    
    ## as.factor(new_model_lump)TITAN PICKUP 2WD V8   -1.011 0.312115    
    ## as.factor(new_model_lump)AVENGER 4C 2.4L I4 S   0.569 0.569675    
    ## as.factor(new_model_lump)CENTURY V6 3.1L V6 S   1.082 0.279437    
    ## as.factor(new_model_lump)FUSION 4C 2.3L I4 EF   0.102 0.918895    
    ## as.factor(new_model_lump)FREESTYLE FWD V6 3.0  -0.143 0.885949    
    ## as.factor(new_model_lump)DURANGO 4WD V8 4.7L   -0.510 0.610198    
    ## as.factor(new_model_lump)LACROSSE              -1.115 0.264815    
    ## as.factor(new_model_lump)NEON 2.0L I4 SFI       3.186 0.001444 ** 
    ## as.factor(new_model_lump)GRAND CHEROKEE 2WD 6   0.827 0.407956    
    ## as.factor(new_model_lump)LANCER 2.0L I4 MPI     1.918 0.055171 .  
    ## as.factor(new_model_lump)EXPEDITION 2WD V8 5.   2.001 0.045433 *  
    ## as.factor(new_model_lump)OPTIMA V6              0.500 0.617099    
    ## as.factor(new_model_lump)CARAVAN FWD V6 3.3L    0.279 0.780568    
    ## as.factor(new_model_lump)FOCUS 2.0L I4 SPI      1.497 0.134507    
    ## as.factor(new_model_lump)STRATUS V6 2.7L V6 M  -2.215 0.026752 *  
    ## as.factor(new_model_lump)ESCAPE 2WD 4C 2.3L I   0.363 0.716266    
    ## as.factor(new_model_lump)F150 PICKUP 2WD V6 4   1.096 0.272894    
    ## as.factor(new_model_lump)SORENTO 2WD            2.833 0.004614 ** 
    ## as.factor(new_model_lump)DURANGO 2WD V6 3.7L    0.893 0.371592    
    ## as.factor(new_model_lump)GALANT 4C 2.4L I4 EF   0.233 0.815381    
    ## as.factor(new_model_lump)ALERO 4C 2.2L I4 MPI   0.484 0.628342    
    ## as.factor(new_model_lump)SUNFIRE 2.2L I4 MPI    0.973 0.330716    
    ## as.factor(new_model_lump)EXPEDITION 2WD V8 4.   0.232 0.816589    
    ## as.factor(new_model_lump)Other                  1.630 0.103125    
    ## VehicleAge                                      7.374 1.65e-13 ***
    ## AuctionMANHEIM                                -11.313  < 2e-16 ***
    ## AuctionOTHER                                   -3.100 0.001935 ** 
    ## WarrantyCost                                    8.783  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 54421  on 72982  degrees of freedom
    ## Residual deviance: 51304  on 72773  degrees of freedom
    ## AIC: 51724
    ## 
    ## Number of Fisher Scoring iterations: 8

8. Make predictions from the logit model. Make sure these are probabilities.
----------------------------------------------------------------------------

``` r
tr<-tr%>%add_predictions(mod_logit)%>%
  mutate(pred_logit=arm::invlogit(pred)) ## This transforms to probabilities
```

9. Calculate the AUC for the predictions from the ROC based on the logit model.
-------------------------------------------------------------------------------

``` r
roc_logit<-roc(predictions = tr$pred_logit,labels=as.factor(tr$IsBadBuy))
logit_auc<-auc(roc_logit)
logit_gini<-(2*logit_auc)-1;logit_gini
```

    ## [1] 0.3521479

10. (optional) submit your predictions from the testing dataset as a late submission to Kaggle and see how you do against real-wolrd competition.
-------------------------------------------------------------------------------------------------------------------------------------------------

``` r
test<-test%>%add_predictions(mod_logit)%>%
  mutate(pred_logit=arm::invlogit(pred))%>%
  mutate(IsBadBuy=pred_logit)

submit<-test%>%select(RefId,IsBadBuy)
  

write_csv(submit,path="submit.csv")
```
