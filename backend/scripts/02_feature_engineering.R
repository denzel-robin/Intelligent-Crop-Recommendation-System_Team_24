# ---------------------------------------------
# Intelligent Crop Recommendation System
# Feature Engineering Script
# ---------------------------------------------
#
# Load required library
library(data.table)

# Load cleaned dataset
input_path <- "data/processed/crop_cleaned.csv"
crop_data <- fread(input_path)

# ---------------------------------------------
# 1. Initial Overview
# ---------------------------------------------

cat("Dataset Dimensions (Before Feature Engineering):\n")
print(dim(crop_data))

# ---------------------------------------------
# 2. Create Derived Features
# ---------------------------------------------
# Nutrient ratios help capture relative soil composition

crop_data[, NP_ratio := N / (P + 1)]
crop_data[, NK_ratio := N / (K + 1)]
crop_data[, PK_ratio := P / (K + 1)]

# ---------------------------------------------
# 3. Environmental Interaction Features
# ---------------------------------------------

crop_data[, temp_humidity_interaction := temperature * humidity]
crop_data[, rainfall_ph_interaction := rainfall * ph]

# ---------------------------------------------
# 4. Log Transformation (Skewed Features)
# ---------------------------------------------
# Prevents extreme value dominance

skewed_features <- c("rainfall")

for (col in skewed_features) {
  crop_data[, (paste0(col, "_log")) := log(get(col) + 1)]
}

# ---------------------------------------------
# 5. Feature Validation
# ---------------------------------------------

cat("\nNew Features Created:\n")
print(setdiff(names(crop_data),
              c("N", "P", "K", "temperature", "humidity", "ph", "rainfall", "label")))

# ---------------------------------------------
# 6. Remove Redundant Features (Optional)
# ---------------------------------------------
# Keep original rainfall along with log-transformed version
# Uncomment if required
# crop_data[, rainfall := NULL]

# ---------------------------------------------
# 7. Final Dataset Summary
# ---------------------------------------------

cat("\nDataset Dimensions (After Feature Engineering):\n")
print(dim(crop_data))

cat("\nData Types:\n")
print(str(crop_data))

# ---------------------------------------------
# 8. Save Feature-Engineered Dataset
# ---------------------------------------------

output_path <- "data/processed/crop_feature_engineered.csv"
fwrite(crop_data, output_path)

cat("\nFeature-engineered dataset saved to:", output_path, "\n")

# ---------------------------------------------
# End of Script
# ---------------------------------------------
