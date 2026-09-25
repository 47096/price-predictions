#!/usr/bin/env Rscript
packages <- c("corrplot", "DALEX", "DataExplorer", "Metrics", "modelStudio", "tidymodels", "tidyverse")
install.packages(packages[!packages %in% installed.packages()[, "Package"]])
