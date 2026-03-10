# ============================================
# Train-Test Split + Encoding
# ============================================

library(data.table)
library(caret)

set.seed(42)

data <- fread("data/processed/crop_cleaned.csv")

train_idx <- createDataPartition(data$label, p = 0.8, list = FALSE)

train <- data[train_idx]
test  <- data[-train_idx]

# Stable label encoding
labels <- sort(unique(data$label))
label_map <- setNames(seq_along(labels) - 1, labels)

y_train <- as.integer(label_map[as.character(train$label)])
y_test  <- as.integer(label_map[as.character(test$label)])

X_train <- as.matrix(train[, !"label"])
X_test  <- as.matrix(test[, !"label"])

# Median imputation (CRITICAL)
for (j in seq_len(ncol(X_train))) {
  med <- median(X_train[, j], na.rm = TRUE)
  X_train[is.na(X_train[, j]), j] <- med
  X_test[is.na(X_test[, j]), j] <- med
}

saveRDS(
  list(
    X_train = X_train,
    y_train = y_train,
    X_test  = X_test,
    y_test  = y_test,
    labels  = labels
  ),
  "data/processed/train_test_data.rds"
)

cat("Train-test data saved.\n")
