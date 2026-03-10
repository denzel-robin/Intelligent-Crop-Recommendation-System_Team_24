# ============================================
# XGBoost Training (Recommendation Model)
# ============================================

library(xgboost)

data <- readRDS("data/processed/train_test_data.rds")

dtrain <- xgb.DMatrix(data$X_train, label = data$y_train)
dtest  <- xgb.DMatrix(data$X_test,  label = data$y_test)

params <- list(
  objective = "multi:softprob",
  num_class = length(data$labels),
  eval_metric = "mlogloss",
  max_depth = 5,
  eta = 0.05,
  subsample = 0.8,
  colsample_bytree = 0.8
)

model <- xgb.train(
  params = params,
  data = dtrain,
  nrounds = 2000,
  evals = list(test = dtest),
  early_stopping_rounds = 50,
  verbose = 1
)

xgb.save(model, "model/xgboost_crop.model")
cat("Model saved.\n")
