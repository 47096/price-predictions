# https://www.kaggle.com/c/house-prices-advanced-regression-techniques/
# the goal is to predict house prices

# load packages
library(tidyverse)
library(tidymodels)
library(corrplot)
library(modelStudio)
library(DALEX)
library(Metrics)

# local data (vendored)
train <- read.csv('data/train.csv', stringsAsFactors = T); nrow(train) # 1460
test <- read.csv('data/test.csv', stringsAsFactors = T); nrow(test) # 1459

# create SalePrice in the test set
test$SalePrice <- NA

# combine both train and test sets into one dataframe
full <- rbind(train, test); nrow(full) # 2919

# drop the ID column
# full$Id <- NULL

glimpse(full)

# visualise missing data
DataExplorer::plot_missing(full, missing_only = T)

# quickly remove all features below with too many missing values
full_cleaned <- full %>% 
  select(-FireplaceQu, -Fence, -Alley, -MiscFeature, -PoolQC)

DataExplorer::plot_missing(full_cleaned, missing_only = T)

# split full into train and unseen
train_cleaned <- full_cleaned %>% 
  filter(!is.na(SalePrice)); nrow(train_cleaned) # 1460

unseen_cleaned <- full_cleaned %>% 
  filter(is.na(SalePrice)); nrow(unseen_cleaned) # 1459

# split the train set into train and test
set.seed(222) 
house_split <- initial_split(train_cleaned, prop = 0.8, strata = SalePrice) # enforce similar distributions
house_split

# <Analysis/Assess/Total>
# <1166/294/1460>

house_train <- training(house_split); nrow(house_train) # 1166
house_test <- testing(house_split); nrow(house_test) # 294

# define engine for regression using xgboost
model_spec <- boost_tree() %>% 
  set_engine("xgboost") %>% 
  set_mode("regression")

model_spec

# Fit to the data
# *one observation = cannot have features with too many missing values
model_fit <- model_spec %>%
  fit(formula = SalePrice ~ . -Id, data = house_train)

model_fit

# make predictions using the test set
predictions <- predict(model_fit, house_test) %>%
  bind_cols(house_test) # Add the test set

# create an explainer using the test set
explainer <- DALEX::explain(
  model = model_fit,
  data = house_test,
  y = house_test$SalePrice,
  label = "XGBoost"
)

# create a subset of a predictions using a sample of 5
pred_size_s <- predictions %>% 
  sample_n(5)

# s for size S
pred_size_s %>% 
  select(Id, .pred, SalePrice)

# Id   .pred SalePrice
# <int>   <dbl>     <int>
# 1   641 276033.    274000
# 2   711  91053.     52000
# 3  1388 173678.    136000
# 4  1188 305580.    262000
# 5  1434 177981.    186500

# modelStudio dashboard (N/B kept small for speed)
modelStudio(explainer,
            pred_size_s, # use a much smaller dataset for this
            N = 200, # default = 300
            B = 5) # default = 10

# evaluation metrics
# r2
yardstick::rsq(predictions, estimate = .pred, truth = SalePrice) # 0.865

# mae
yardstick::mae(predictions, estimate = .pred, truth = SalePrice) # 18494

# rmse
yardstick::rmse(predictions, estimate = .pred, truth = SalePrice) # 26430

# using the Metrics package
# rmsle
Metrics::rmsle(predictions$SalePrice, predictions$.pred) # 0.1512431
Metrics::rmse(predictions$SalePrice, predictions$.pred) # 26429.85
Metrics::mae(predictions$SalePrice, predictions$.pred) # 18494.34

# now, make predictions using the unseen data
unseen_predictions <- predict(model_fit, unseen_cleaned) %>%
  bind_cols(unseen_cleaned) # Add the test set

unseen_predictions %>% 
  select(Id, .pred) %>% 
  sample_n(5)

# Id   .pred
# <int>   <dbl>
# 1  2130 140402.
# 2  1731 115558.
# 3  2918 134256.
# 4  2267 352237.
# 5  2245  80163.

# make a submission for kaggle
submission <- unseen_predictions %>% 
  select(Id, .pred) %>% 
  rename(SalePrice = .pred)

head(submission)

# export submission
write.csv(submission, "submission.csv", row.names = FALSE)

