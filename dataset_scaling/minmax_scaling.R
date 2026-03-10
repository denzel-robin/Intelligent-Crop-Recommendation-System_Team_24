# Min-Max Normalization Script for Crop Recommendation Dataset
# Applies Min-Max scaling to numeric features of the cleaned dataset
# Formula: X_normalized = (X - X_min) / (X_max - X_min)

# Clear environment
rm(list = ls())

# Set working directory
setwd("/home/minhaj/Coder/ProjectR/Intelligent-Crop-Recommendation-System")

# ============================
# 1. Load Cleaned Dataset
# ============================
cat("========================================\n")
cat("LOADING CLEANED DATASET\n")
cat("========================================\n")

data <- read.csv("dataset/Crop_recommendation_cleaned.csv", stringsAsFactors = FALSE)

cat("Dataset loaded successfully!\n")
cat("Dimensions:", nrow(data), "rows x", ncol(data), "columns\n\n")

# Display structure
cat("Dataset Structure:\n")
str(data)
cat("\n")

# ============================
# 2. Identify Numeric Columns
# ============================
cat("========================================\n")
cat("IDENTIFYING NUMERIC FEATURES\n")
cat("========================================\n")

numeric_cols <- names(data)[sapply(data, is.numeric)]
cat("Numeric columns to scale:", paste(numeric_cols, collapse = ", "), "\n")

non_numeric_cols <- names(data)[!sapply(data, is.numeric)]
cat("Non-numeric columns (excluded):", paste(non_numeric_cols, collapse = ", "), "\n\n")

# ============================
# 3. Summary Before Scaling
# ============================
cat("========================================\n")
cat("SUMMARY BEFORE MIN-MAX SCALING\n")
cat("========================================\n")

before_stats <- data.frame(
  Column  = numeric_cols,
  Min     = sapply(data[numeric_cols], min, na.rm = TRUE),
  Max     = sapply(data[numeric_cols], max, na.rm = TRUE),
  Mean    = round(sapply(data[numeric_cols], mean, na.rm = TRUE), 4),
  SD      = round(sapply(data[numeric_cols], sd, na.rm = TRUE), 4),
  row.names = NULL
)

cat("Before Scaling:\n")
print(before_stats)
cat("\n")

# ============================
# 4. Min-Max Normalization
# ============================
cat("========================================\n")
cat("APPLYING MIN-MAX NORMALIZATION\n")
cat("========================================\n")

# Min-Max normalization function
min_max_normalize <- function(x) {
  min_val <- min(x, na.rm = TRUE)
  max_val <- max(x, na.rm = TRUE)

  # Handle constant columns (avoid division by zero)
  if (max_val == min_val) {
    warning("Column has constant values. Returning 0.")
    return(rep(0, length(x)))
  }

  return((x - min_val) / (max_val - min_val))
}

# Create a copy of the dataset for scaling
scaled_data <- data

# Apply Min-Max normalization to each numeric column
for (col in numeric_cols) {
  min_val <- min(data[[col]], na.rm = TRUE)
  max_val <- max(data[[col]], na.rm = TRUE)

  scaled_data[[col]] <- min_max_normalize(data[[col]])

  cat(sprintf("  %-15s | Min: %10.4f  Max: %10.4f  | Scaled to [0, 1]\n",
              col, min_val, max_val))
}

cat("\nMin-Max normalization applied successfully!\n\n")

# ============================
# 5. Summary After Scaling
# ============================
cat("========================================\n")
cat("SUMMARY AFTER MIN-MAX SCALING\n")
cat("========================================\n")

after_stats <- data.frame(
  Column  = numeric_cols,
  Min     = sapply(scaled_data[numeric_cols], min, na.rm = TRUE),
  Max     = sapply(scaled_data[numeric_cols], max, na.rm = TRUE),
  Mean    = round(sapply(scaled_data[numeric_cols], mean, na.rm = TRUE), 4),
  SD      = round(sapply(scaled_data[numeric_cols], sd, na.rm = TRUE), 4),
  row.names = NULL
)

cat("After Scaling:\n")
print(after_stats)
cat("\n")

# ============================
# 6. Verification
# ============================
cat("========================================\n")
cat("VERIFICATION\n")
cat("========================================\n")

cat("First 6 rows of scaled data:\n")
print(head(scaled_data))
cat("\n")

# Verify all scaled values are in [0, 1]
all_in_range <- all(sapply(scaled_data[numeric_cols], function(x) {
  all(x >= 0 & x <= 1, na.rm = TRUE)
}))
cat("All scaled values in [0, 1]:", all_in_range, "\n\n")

# ============================
# 7. Save Scaled Dataset
# ============================
cat("========================================\n")
cat("SAVING SCALED DATASET\n")
cat("========================================\n")

output_path <- "dataset/Crop_recommendation_scaled.csv"
write.csv(scaled_data, output_path, row.names = FALSE)
cat("Scaled dataset saved to:", output_path, "\n")
cat("Dimensions:", nrow(scaled_data), "rows x", ncol(scaled_data), "columns\n\n")

# ============================
# 8. Comparison Table
# ============================
cat("========================================\n")
cat("BEFORE vs AFTER COMPARISON\n")
cat("========================================\n")

comparison <- data.frame(
  Column       = numeric_cols,
  Before_Min   = before_stats$Min,
  Before_Max   = before_stats$Max,
  Before_Mean  = before_stats$Mean,
  After_Min    = after_stats$Min,
  After_Max    = after_stats$Max,
  After_Mean   = after_stats$Mean,
  row.names    = NULL
)

print(comparison)
cat("\n")

cat("========================================\n")
cat("MIN-MAX SCALING COMPLETE\n")
cat("========================================\n")
