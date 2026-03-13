# ============================================
# XGBoost Training (Recommendation Model)
# ============================================
library(xgboost)
data <- readRDS("data/processed/train_test_data.rds")
dtrain <- xgb.DMatrix(data$X_train, label = data$y_train)
dtest  <- xgb.DMatrix(data$X_test,  label = data$y_test)
params <- list(
  objective    = "multi:softprob",
  num_class    = 22,
  eval_metric  = "merror",
  max_depth    = 5,
  eta          = 0.05,
  subsample    = 0.8,
  colsample_bytree = 0.8
)
model <- xgb.train(
  params                = params,
  data                  = dtrain,
  nrounds               = 200,
  evals                 = list(test = dtest),
  early_stopping_rounds = 50,
  verbose               = 1
)

# ✅ Fixed accuracy measurement for softprob
pred_raw    <- predict(model, dtest)
pred_matrix <- matrix(pred_raw, ncol = 22, byrow = FALSE)
pred_labels <- max.col(pred_matrix) - 1
cat("Final Accuracy:", round(mean(pred_labels == data$y_test) * 100, 2), "%\n")

# ✅ Save as .json
xgb.save(model, "model/xgboost_crop.json")