## Quick implementation of lasso, varying parameters

library(tidyverse)
library(caret)
library(elasticnet)
library(glmnet)

data(mtcars)

y <- mtcars %>% select(mpg) %>% as.matrix()
X <- mtcars %>% select(-mpg) %>% as.matrix()

lambdas_to_try <- seq(0, 1, length.out = 1000)

lasso_cv<-cv.glmnet(X, y, alpha = 1, lambda = lambdas_to_try,
          standardize = TRUE, nfolds = 10)

fitControl <- trainControl(method = "cv",
                           n=10)

fit1<-train(mpg~.,
            data=mtcars,
            method="glmnet",
            trControl=fitControl,
            tuneGrid = expand.grid(alpha = 1,
                                   lambda = lambdas_to_try))
lasso_cv$lambda.min
fit1$bestTune
