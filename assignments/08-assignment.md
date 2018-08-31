Assignment 8
---

"When life gives you lemons, don’t make lemonade. Make life take the lemons back! Get mad!" -Cave Johnson

For this assignment, you'll be using the lemons dataset, which is a subset of the dataset used for a Kaggle competition described here: 
https://www.kaggle.com/c/DontGetKicked/data. Your job is to predict which cars are most likely to be lemons. 

Complete the following steps.

1. Calculate the proportion of lemons in the training dataset using the `IsBadBuy` variable. 
2. Calculate the proportion of lemons by Make. 
4. Now, predict the probability of being a lemon using a linear model (`lm(y~x`), with covariates of your choosing from the training dataset. 
5. Make predictions from the linear model.
6. Calculate the AUC for the linear predictions from the ROC against the outcome for the training dataset. 
7. Now, predict the probability of being a lemon using a logistic regression (`glm(y~x,family=binomial(link="logit")`)), again using covariates of your choosing. Add these to the existing linear model already give to you.  
8. Make predictions from the logit model. Make sure these are probabilities. 
9. Calculate the AUC for the predictions from the ROC based on the logit model. 
10. (optional) submit your predictions from the testing dataset as a late submission to Kaggle and see how you do against real-wolrd competition. 