Unsupervised Learning
================
Doyle
11/13/2019

# Introduction

K means clustering is an example of *unsupervised learning*, a set of
techniques used to identify patterns of association within a dataset
that are not driven by the analyst. This technique is employed when it
is strongly suspected that there are latent classifications of
individuals in a dataset, but those classifications are unknown.

There are many types of unsupervised learning—this is a very active area
of development in data science. K-means is among the simplest, and is
relatively easy to explain. It’s also pretty good— it tends to get
decent answers. K-means proceeds by finding some number (K) groups of
observations that are quite similar to one another, but quite different
from other groups of observations. Similarity in this case is defined as
having minimum variation within the group. The way this is done in
practice is to start by randomly assigning each observation to a
cluster, then to calculate the cluster centroid, which is the means of
the variables used for the algorithm. Next, assign each observation to
the cluster centroid which is closest to its means. This continues until
no more changes are possible.

If the data have clear underlying partitions, then the cluster
assignment will be pretty stable. If not, then each time you run this
algorithm, you could get different answers. There are solutions to this
problem we’ll go over, but please remember this basic fact about K-means
clustering, which is different than any of the algorithms we cover in
this class:

*K MEANS CLUSTERING IN ITS BASIC FORM CAN GIVE YOU DIFFERENT ANSWERS
EACH TIME YOUR RUN IT*.

We’ll be working with the NBA data that we scraped earlier this semester
to define different classes of players based on their characteristics
across the season. Based on these results, we’ll see what we can figure
out about the likely points contribution of players from different
groups.

There are two new libraries today: LICORS and factoextra.

We’ll pull in the NBA dataset, which has data on all players from all
teams from 1993 to 2018

We’re going to subset the data to players who put in at least 500
minutes, which is roughly averaging half a quarter per game (6\*82=492).

The first step in running cluster analysis is to figure out how many
clusters are needed. It’s generally assumed that there are at least 3
clusters, but it’s not easy to think about how many more might be
needed.

The `stepFlexClust` command can be helpful here. What it will do is to
run a cluster analysis a certain number of times for a certain number of
clusters, choosing the best fit (minimum distance) from each set of runs
for each number of clusters. We can then take a look at the distances
generated and plot them.

![](12-unsupervised_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

The silhouette method measures the fit of each observation within each
cluster. The resulting ploit generally provides a pretty clear
indication of the appropriate number of clusters.

![](12-unsupervised_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

The `kmeanspp` (stands for k-means ++) command will repeat the kmeans
clustering algorithm with different starting points until it converges
on a stable solution. It basically repeats the process we saw above, but
with the intention of getting to a stable solution. This is generally a
preferred way of generating cluster assignments.

Notice how the sample sizes in each group are identical, although the
group numbers (which are arbitrary) are different after each run.

We can visualize the groups by taking a look at a plot of the various
groupings, labeled by player name.
![](12-unsupervised_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

# Understanding cluster assignments

So now what? We need to figure out what these clusters mean by
inspecting them as a function of the constituent variables.

The code below summarizes the average of each variable in the analysis
within each cluster. We need to take a look at these and figure out what
they mean.

We can then plot the averages for each cluster. Remember that these are
standardized variables, so they will generally range from -3 to 3, with
0 being the average.

![](12-unsupervised_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

We can also go back to the original dataset and see if we can make sense
of individaul assignments. The code below shows how each player has been
assigned, selecting the top ten field goal scorers from each cluster.

| cluster | player                 |  fg | total\_rebound | rank |
| ------: | :--------------------- | --: | -------------: | ---: |
|       1 | Klay Thompson          | 575 |            277 |    1 |
|       1 | Carmelo Anthony        | 472 |            453 |    2 |
|       1 | Kyle Kuzma             | 468 |            483 |    3 |
|       1 | Otto Porter            | 445 |            492 |    4 |
|       1 | Gary Harris            | 440 |            176 |    5 |
|       1 | Jordan Clarkson        | 430 |            217 |    6 |
|       1 | E’Twaun Moore          | 423 |            238 |    7 |
|       1 | Thaddeus Young         | 421 |            512 |    8 |
|       1 | Buddy Hield            | 416 |            307 |    9 |
|       1 | Eric Gordon            | 415 |            170 |   10 |
|       2 | Montrezl Harrell       | 348 |            306 |    1 |
|       2 | Robin Lopez            | 342 |            290 |    2 |
|       2 | John Collins           | 314 |            541 |    3 |
|       2 | John Henson            | 287 |            513 |    4 |
|       2 | Michael Kidd-Gilchrist | 282 |            302 |    5 |
|       2 | Mike Scott             | 276 |            247 |    6 |
|       2 | Dwight Powell          | 255 |            444 |    7 |
|       2 | Jakob Poeltl           | 253 |            393 |    8 |
|       2 | Pascal Siakam          | 253 |            364 |    9 |
|       2 | Dewayne Dedmon         | 250 |            489 |   10 |
|       3 | LeBron James           | 857 |            709 |    1 |
|       3 | Russell Westbrook      | 757 |            804 |    2 |
|       3 | Bradley Beal           | 683 |            363 |    3 |
|       3 | CJ McCollum            | 667 |            321 |    4 |
|       3 | James Harden           | 651 |            389 |    5 |
|       3 | DeMar DeRozan          | 645 |            315 |    6 |
|       3 | Victor Oladipo         | 640 |            390 |    7 |
|       3 | Kevin Durant           | 630 |            464 |    8 |
|       3 | Damian Lillard         | 621 |            325 |    9 |
|       3 | Jrue Holiday           | 615 |            365 |   10 |
|       4 | Avery Bradley          | 259 |            116 |    1 |
|       4 | Reggie Jackson         | 246 |            125 |    2 |
|       4 | Malcolm Brogdon        | 244 |            156 |    3 |
|       4 | Doug McDermott         | 237 |            200 |    4 |
|       4 | Troy Daniels           | 232 |            127 |    5 |
|       4 | C.J. Miles             | 227 |            152 |    6 |
|       4 | Raymond Felton         | 224 |            156 |    7 |
|       4 | Ian Clark              | 222 |            127 |    8 |
|       4 | Tyler Ulis             | 214 |            128 |    9 |
|       4 | Bryn Forbes            | 209 |            110 |   10 |
|       5 | Anthony Davis          | 780 |            832 |    1 |
|       5 | Giannis Antetokounmpo  | 742 |            753 |    2 |
|       5 | LaMarcus Aldridge      | 687 |            635 |    3 |
|       5 | Karl-Anthony Towns     | 639 |           1012 |    4 |
|       5 | Ben Simmons            | 544 |            659 |    5 |
|       5 | T.J. Warren            | 529 |            333 |    6 |
|       5 | Joel Embiid            | 510 |            690 |    7 |
|       5 | Dwight Howard          | 506 |           1012 |    8 |
|       5 | Nikola Jokic           | 504 |            803 |    9 |
|       5 | Julius Randle          | 504 |            654 |   10 |

# Modeling Using Clusters

Once you have clusters, then you can use these as independent variables
to predict various outcomes.

<table style="text-align:center">

<tr>

<td colspan="2" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

<em>Dependent variable:</em>

</td>

</tr>

<tr>

<td>

</td>

<td colspan="1" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

pts

</td>

</tr>

<tr>

<td colspan="2" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

as\_factor(cluster)2

</td>

<td>

\-398.112<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(34.061)

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

as\_factor(cluster)3

</td>

<td>

702.261<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(40.011)

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

as\_factor(cluster)4

</td>

<td>

\-493.046<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(26.095)

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

as\_factor(cluster)5

</td>

<td>

432.130<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(48.612)

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

</tr>

<tr>

<td style="text-align:left">

Constant

</td>

<td>

855.520<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(18.180)

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

</tr>

<tr>

<td colspan="2" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

Observations

</td>

<td>

340

</td>

</tr>

<tr>

<td style="text-align:left">

R<sup>2</sup>

</td>

<td>

0.784

</td>

</tr>

<tr>

<td style="text-align:left">

Adjusted R<sup>2</sup>

</td>

<td>

0.781

</td>

</tr>

<tr>

<td style="text-align:left">

Residual Std. Error

</td>

<td>

201.624 (df = 335)

</td>

</tr>

<tr>

<td style="text-align:left">

F Statistic

</td>

<td>

303.609<sup>\*\*\*</sup> (df = 4; 335)

</td>

</tr>

<tr>

<td colspan="2" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

<em>Note:</em>

</td>

<td style="text-align:right">

<sup>*</sup>p\<0.1; <sup>**</sup>p\<0.05; <sup>***</sup>p\<0.01

</td>

</tr>

</table>
