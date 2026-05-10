# Predicting House Prices

Predicting sale prices for the Kaggle House Prices competition using XGBoost — with 80 features, model explainability via modelStudio, and a competition submission.

## Problem

The Kaggle House Prices challenge: predict the sale price of 1,459 homes in Ames, Iowa based on 79 features (lot size, neighbourhood, year built, pool, garage, etc.). The goal is minimising RMSLE (root mean squared log error) — getting the price right in percentage terms, not just dollar terms.

## Approach

1. **Combine** train (1,460) and test (1,459) sets for consistent preprocessing
2. **Clean** — remove features with excessive missing data (PoolQC, MiscFeature, Alley, Fence, FireplaceQu)
3. **Split** — 80/20 with stratification on SalePrice
4. **Train** — XGBoost via tidymodels with default parameters
5. **Evaluate** — R², MAE, RMSE, RMSLE
6. **Explain** — modelStudio interactive dashboard on 5 sample predictions
7. **Submit** — generate Kaggle submission CSV

## Results

| Metric | Score |
|--------|-------|
| R² | 0.865 |
| MAE | $18,494 |
| RMSE | $26,430 |
| RMSLE | 0.151 |

The model explains 86.5% of price variance. On average, predictions are within ~$18.5K of actual sale prices — strong for a default-parameter model on 80 features.

### Sample Predictions

| Id | Predicted | Actual | Error |
|----|-----------|--------|-------|
| 641 | $276,033 | $274,000 | +$2,033 |
| 1388 | $173,678 | $136,000 | +$37,678 |
| 1434 | $177,981 | $186,500 | -$8,519 |

## Feature Groups

The 79 features span every aspect of a property:

| Category | Examples |
|----------|---------|
| Location | Neighbourhood, zoning, street type |
| Size | Lot area, living area, lot frontage |
| Quality | Overall quality, exterior quality, kitchen quality |
| Structure | Year built, year remodelled, building type, house style |
| Rooms | Bedrooms, bathrooms, kitchens, total rooms |
| Basement | Total basement SF, basement quality, basement finish |
| Garage | Garage cars, garage area, garage year built |
| Outdoor | Wood deck, porch, pool area, fence |
| Sale | Sale type, sale condition, month sold |

## Setup

```bash
git clone https://github.com/wsamuelw/kaggle-predict-house-prices.git
cd kaggle-predict-house-prices
```

```r
install.packages(c("tidyverse", "tidymodels", "corrplot", "modelStudio", "DALEX", "Metrics", "DataExplorer"))
source("code/code.R")
```

## Data

From the [Kaggle House Prices competition](https://www.kaggle.com/c/house-prices-advanced-regression-techniques/data). Included in `data/`:

| File | Rows | Purpose |
|------|------|---------|
| `train.csv` | 1,460 | Training data with SalePrice |
| `test.csv` | 1,459 | Unseen test data for Kaggle submission |

`data_description.txt` contains detailed descriptions of all 79 features.

## Key Decisions

- **Removed 5 features** with excessive missing values (PoolQC, MiscFeature, Alley, Fence, FireplaceQu) rather than imputing — too sparse to be useful
- **XGBoost over linear models** — 80 features with many categoricals and non-linear relationships; tree-based handles this naturally
- **Default parameters** — focused on establishing a baseline before investing in tuning
- **RMSLE as primary metric** — penalises underestimation more than overestimation, which is appropriate for house prices

## Tech Stack

- **tidymodels** — unified modelling framework
- **XGBoost** — gradient boosting engine
- **modelStudio / DALEX** — interactive model explainability
- **DataExplorer** — missing data visualisation
- **Metrics** — RMSLE calculation

## References

- [Kaggle House Prices competition](https://www.kaggle.com/c/house-prices-advanced-regression-techniques)
- [modelStudio documentation](https://modelstudio.drwhy.ai/)
- [Ames Housing data description](https://www.kaggle.com/c/house-prices-advanced-regression-techniques/data)

## License

MIT
