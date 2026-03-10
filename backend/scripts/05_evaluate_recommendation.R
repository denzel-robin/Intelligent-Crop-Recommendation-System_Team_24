# ============================================
# Recommendation Evaluation Metrics
# ============================================

library(xgboost)

data <- readRDS("data/processed/train_test_data.rds")
model <- xgb.load("model/xgboost_crop.model")

dtest <- xgb.DMatrix(data$X_test)
pred <- matrix(
  predict(model, dtest),
  ncol = length(data$labels),
  byrow = TRUE
)

y_test <- data$y_test

top_k_accuracy <- function(p, y, k) {
  mean(sapply(1:nrow(p), function(i) {
    y[i] %in% (order(p[i, ], decreasing = TRUE)[1:k] - 1)
  }))
}

mrr <- mean(sapply(1:nrow(pred), function(i) {
  1 / which(order(pred[i, ], decreasing = TRUE) - 1 == y_test[i])
}))

results <- data.frame(
  Metric = c("Top-1", "Top-3", "Top-5", "Top-7", "MRR"),
  Value = round(c(
    top_k_accuracy(pred, y_test, 1),
    top_k_accuracy(pred, y_test, 3),
    top_k_accuracy(pred, y_test, 5),
    top_k_accuracy(pred, y_test, 7),
    mrr
  ) * 100, 2)
)

print(results)
write.csv(results, "results/evaluation_metrics.csv", row.names = FALSE)
