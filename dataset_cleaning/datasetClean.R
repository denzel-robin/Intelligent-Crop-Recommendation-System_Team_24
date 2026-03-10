# Data Preprocessing Script for Crop Recommendation Dataset
# This script handles missing values and duplicates

# Clear environment
rm(list = ls())

# Load necessary libraries
library(dplyr)

# # Set working directory (adjust if needed)
setwd("/home/minhaj/Coder/ProjectR/Intelligent-Crop-Recommendation-System")

# ============================
# 1. Load Dataset
# ============================
cat("========================================\n")
cat("LOADING DATASET\n")
cat("========================================\n")

data <- read.csv("Crop_recommendation.csv", stringsAsFactors = FALSE)

cat("Dataset loaded successfully!\n")
cat("Dimensions:", nrow(data), "rows x", ncol(data), "columns\n\n")

# Display first few rows
cat("First few rows of the dataset:\n")
print(head(data))
cat("\n")

# Display structure
cat("Dataset structure:\n")
str(data)
cat("\n")

# ============================
# 2. MISSING VALUE HANDLING
# ============================
cat("========================================\n")
cat("MISSING VALUE ANALYSIS\n")
cat("========================================\n")

# Check for missing values
missing_count <- colSums(is.na(data))
missing_percentage <- round((missing_count / nrow(data)) * 100, 2)

missing_summary <- data.frame(
  Column = names(missing_count),
  Missing_Count = missing_count,
  Missing_Percentage = missing_percentage
)

cat("Missing values per column:\n")
print(missing_summary)
cat("\n")

total_missing <- sum(missing_count)
cat("Total missing values in dataset:", total_missing, "\n\n")

# Handle missing values if any exist
if (total_missing > 0) {
  cat("Handling missing values...\n")
  
  # Store original data for comparison
  data_before_missing <- data
  
  # For numerical columns: impute with median
  numerical_cols <- c("N", "P", "K", "temperature", "humidity", "ph", "rainfall")
  
  for (col in numerical_cols) {
    if (col %in% names(data) && sum(is.na(data[[col]])) > 0) {
      median_value <- median(data[[col]], na.rm = TRUE)
      data[[col]][is.na(data[[col]])] <- median_value
      cat("  - Imputed", col, "with median:", median_value, "\n")
    }
  }
  
  # For categorical columns: impute with mode
  if ("label" %in% names(data) && sum(is.na(data$label)) > 0) {
    mode_value <- names(sort(table(data$label), decreasing = TRUE))[1]
    data$label[is.na(data$label)] <- mode_value
    cat("  - Imputed 'label' with mode:", mode_value, "\n")
  }
  
  cat("\nMissing values handled successfully!\n\n")
  
  # Verify no missing values remain
  remaining_missing <- sum(is.na(data))
  cat("Remaining missing values:", remaining_missing, "\n\n")
} else {
  cat("No missing values found in the dataset!\n\n")
}

# ============================
# 3. DUPLICATE HANDLING
# ============================
cat("========================================\n")
cat("DUPLICATE ANALYSIS\n")
cat("========================================\n")

# Count duplicates
duplicate_count <- sum(duplicated(data))
cat("Number of duplicate rows:", duplicate_count, "\n")
cat("Percentage of duplicates:", round((duplicate_count / nrow(data)) * 100, 2), "%\n\n")

# Store dimensions before removing duplicates
rows_before <- nrow(data)

# Remove duplicates if any exist
if (duplicate_count > 0) {
  cat("Removing duplicate rows...\n")
  data <- data[!duplicated(data), ]
  rows_after <- nrow(data)
  rows_removed <- rows_before - rows_after
  
  cat("Duplicates removed:", rows_removed, "\n")
  cat("Remaining rows:", rows_after, "\n\n")
} else {
  cat("No duplicate rows found in the dataset!\n\n")
}

# ============================
# 4. FINAL SUMMARY
# ============================
cat("========================================\n")
cat("PREPROCESSING SUMMARY\n")
cat("========================================\n")

cat("Original dataset dimensions:", rows_before, "rows\n")
cat("Final dataset dimensions:", nrow(data), "rows x", ncol(data), "columns\n")
cat("Rows removed:", rows_before - nrow(data), "\n\n")

# Display summary statistics
cat("Summary statistics of cleaned data:\n")
print(summary(data))
cat("\n")

# ============================
# 5. SAVE CLEANED DATASET
# ============================
cat("========================================\n")
cat("SAVING CLEANED DATASET\n")
cat("========================================\n")

output_file <- "Crop_recommendation_cleaned.csv"
write.csv(data, output_file, row.names = FALSE)
cat("Cleaned dataset saved as:", output_file, "\n")

cat("\n========================================\n")
cat("PREPROCESSING COMPLETE!\n")
cat("========================================\n")
