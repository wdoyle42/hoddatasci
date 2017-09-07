Assignment 2
------------------------------

For this assignment, you'll be working with the county level dataset to predict a home ownership rates using conditional means. You'll need to select the county-level characteristics that you think might be related to home ownership rates. Please complete the following steps:

1. Calculate the mean of the outcome.
2. Use your mean as a prediction: Create a new variable that consists of the mean of the outcome.
3. Calculate a summary measure of the errors for each observation---the difference between your prediction and the outcome. 
4. Calculate the mean of the outcome at levels of a predictor variable.  
5. Use these conditional means as a prediction: for every county, use the conditional mean to provide a ''best guess'' as to that county's level of the outcome.  
6. Calculate a summary measure or two of the error in your predictions.
7. Repeat the above process using the tool of conditional means, try to find 3-4 variables that predict the outcome with better (closer to 0) summary measures of error. Report the summary measures of error and the variables (as text in your `.Rmd` file).

Submit your assignment as `assignment2_<yourlastname>.Rmd`, where `<yourlastname>` is your last name. (By the way, any time you see this: `<sometext>`, that indicates that you need to substitute something in, so if I were to submit the above assignment, it would be as: `assignment2_doyle.Rmd`)

I expect that the `.Rmd` file you submit will run cleanly, and that there shouldn't be any errors. Use LOTS of comments to tell me what you are doing. 