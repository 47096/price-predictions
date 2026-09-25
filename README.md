# What drives home prices?

**A valuation insight problem, solved with property data.**

Buyers, sellers, and investors argue about value from gut feel. I turn **property features into a price estimate and a reason list** — what actually moves the number.

---

## The stake

Misprice a home and you leave money on the table or sit on the market. Appraisals are slow. Spreadsheets ignore non-linear effects (quality × location × timing). You need **both** a number and **why**.

## The story

1,459 homes in Ames, Iowa with **79 features** — lot, neighbourhood, build year, pool, garage, finishes.

I built a full pipeline toward a competition-grade score **and** an explainability pass:

1. **Clean** — drop hopelessly sparse columns instead of fake precision  
2. **Train** XGBoost on rich mixed-type features  
3. **Score** in percentage terms (**RMSLE**), not just raw dollars  
4. **Explain** — which features drove a given estimate (modelStudio)  
5. **Ship** a submission file — the workflow is production-shaped  

**Outcome on this build:**
- **R² ≈ 0.87** — most of price variance explained on holdout  
- **MAE ≈ $18.5K** on typical Ames prices  
- **RMSLE ≈ 0.15** — errors treated fairly for under/over estimates  
- Sample predictions you can show next to actuals  

> **The commercial idea:** price conversations start with **evidence + drivers**, not vibes.

---

## What that looks like in your world

| You have | I turn it into |
|----------|----------------|
| Listing / sale tables | **Estimated price** + **top drivers** |
| “Comparable sales” debates | Model view of **what pays** |
| Valuation ops | Repeatable scoring, not hero spreadsheets |
| Investor screening | Rank / filter on expected value |

**Typical engagement:** define the price job (list price, AVM, offer range) → train on your market → score + feature story for the desk.

**[Talk to me about price modelling →](https://datafying.co/#contactus)** · [datafying](https://datafying.co/)

---

## Why property & analytics leaders bring me in

- Starts from **value and error cost**, not Kaggle leaderboard  
- Keeps **explainability** next to accuracy (modelStudio)  
- Metric choice (**RMSLE**) matches how people feel about price miss  
- Honest: Ames ≠ your market — retrain locally  

---

## Proof of craft *(technical)*

### Job
Predict `SalePrice` from 79 property features (mixed types).

### Pipeline
Combine train/test for consistent prep → drop ultra-sparse columns (`PoolQC`, `MiscFeature`, `Alley`, `Fence`, `FireplaceQu`) → 80/20 split → **XGBoost (tidymodels)** → metrics → **DALEX / modelStudio** on sample rows → CSV export.

### Results

| Metric | Score |
|--------|-------|
| R² | **0.865** |
| MAE | **$18,494** |
| RMSE | $26,430 |
| RMSLE | **0.151** |

### Feature groups
Location · size · quality · age · rooms · basement · garage · outdoor · sale terms.

### Limits (honesty)
- **Ames, Iowa** — patterns may not transfer to Melbourne/Sydney  
- Defaults used — tuning would move the needle  
- Sparse amenity features removed rather than imputed  
- Use as **decision support**, not a formal valuation  

---

## Reproduce

```bash
git clone https://github.com/47096/price-predictions.git
cd price-predictions
```

```r
source("setup.R")
source("analysis.R")
```

**Data:** `data/train.csv` · `data/test.csv` · `data_description.txt` (Kaggle House Prices, vendored)

**Stack:** `tidyverse` · `tidymodels` · `xgboost` · `DALEX` · `modelStudio` · `Metrics`

---

## Next step

If pricing still runs on instinct — that is the engagement I run.

**[Book a conversation →](https://datafying.co/#contactus)** · Property & customer analytics · [datafying](https://datafying.co/)
