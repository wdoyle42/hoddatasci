In Class Work: Conditional Means
---------------------------------

For today's class, I'd like for you to continue using the county-level dataset. Today, instead of predicting per capita income, use the variables in the dataset to predict retail sales. Here are some (but not all!) of the things that you'll need to do along the way:

* Open up the dataset, `load("pd.RData"")`

* Calculate the mean of the outcome variable of retail sales: `pd%>%summarize(mean_retail=mean(retail,na.rm=TRUE))`

* Create new variables that indicate the quantiles of another variable, using `cut` and `quantile`.

* Generate some tables of the conditional mean of the outcome variable by levels of the predictor variable. 

* Create predictions for each county based on conditional means within each grouping of the predictor variable. 

* Generate summary measures of the error terms: the difference between actual retail sales and your predicted retail sales, using `rmse` or `mae`

* You should also create some graphics. 
