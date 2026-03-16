# ---------------------------------------------
# Intelligent Crop Recommendation System
# Data Exploration Script
# ---------------------------------------------

# Load required libraries
library(data.table)
library(ggplot2)

# Set seed for reproducibility
set.seed(42)

# Load dataset
data_path <- "data/raw/crop_data.csv"
crop_data <- fread(data_path)

# ---------------------------------------------
# 1. Basic Dataset Information
# ---------------------------------------------

cat("Dataset Dimensions:\n")
print(dim(crop_data))

cat("\nColumn Names:\n")
print(colnames(crop_data))

cat("\nData Types:\n")
print(str(crop_data))

# ---------------------------------------------
# 2. Summary Statistics
# ---------------------------------------------

cat("\nSummary Statistics:\n")
print(summary(crop_data))

# ---------------------------------------------
# 3. Check Missing Values
# ---------------------------------------------

missing_values <- colSums(is.na(crop_data))
cat("\nMissing Values per Column:\n")
print(missing_values)

# ---------------------------------------------
# 4. Check Duplicate Records
# ---------------------------------------------

duplicate_count <- sum(duplicated(crop_data))
cat("\nNumber of Duplicate Rows:\n")
print(duplicate_count)

# ---------------------------------------------
# 5. Target Variable Distribution
# ---------------------------------------------

cat("\nCrop Label Distribution:\n")
print(table(crop_data$label))

ggplot(crop_data, aes(x = label)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Crop Class Distribution",
       x = "Crop Type",
       y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# ---------------------------------------------
# 6. Numerical Feature Distribution
# ---------------------------------------------

numeric_cols <- names(crop_data)[sapply(crop_data, is.numeric)]

for (col in numeric_cols) {
  print(
    ggplot(crop_data, aes_string(x = col)) +
      geom_histogram(bins = 30, fill = "darkgreen", color = "black") +
      labs(title = paste("Distribution of", col),
           x = col,
           y = "Frequency") +
      theme_minimal()
  )
}

# ---------------------------------------------
# 7. Boxplots for Outlier Detection
# ---------------------------------------------

for (col in numeric_cols) {
  print(
    ggplot(crop_data, aes_string(y = col)) +
      geom_boxplot(fill = "orange") +
      labs(title = paste("Boxplot of", col),
           y = col) +
      theme_minimal()
  )
}

# ---------------------------------------------
# 8. Correlation Analysis
# ---------------------------------------------

cor_matrix <- cor(crop_data[, ..numeric_cols])
print(cor_matrix)

# ---------------------------------------------
# End of Script
# ---------------------------------------------
