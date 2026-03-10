# ============================================
# Data Cleaning Script
# ============================================

library(data.table)

input_path <- "data/raw/crop_data.csv"
output_path <- "data/processed/crop_cleaned.csv"

data <- fread(input_path)

# Remove duplicates
data <- unique(data)

# Ensure numeric columns
num_cols <- c("N", "P", "K", "temperature", "humidity", "ph", "rainfall")
data[, (num_cols) := lapply(.SD, as.numeric), .SDcols = num_cols]

# Remove rows with invalid values
data <- data[
  N >= 0 & P >= 0 & K >= 0 &
  temperature > 0 &
  humidity > 0 &
  ph > 0 & ph <= 14 &
  rainfall >= 0
]

# Convert label to factor
data$label <- as.factor(data$label)

fwrite(data, output_path)
cat("Cleaned data saved to:", output_path, "\n")
