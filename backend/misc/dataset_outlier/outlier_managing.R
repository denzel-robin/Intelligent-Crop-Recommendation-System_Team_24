# -------------------------------
# 1. Set Working Directory
# -------------------------------
setwd("~/Github/icrs/dataset/")   # Change this to your folder path

# -------------------------------
# 2. Load Dataset
# -------------------------------
data <- read.csv("Crop_recommendation_cleaned.csv", stringsAsFactors = FALSE)

# View summary before cleaning
cat("Summary BEFORE removing outliers:\n")
print(summary(data))

# -------------------------------
# 3. Function to Remove Outliers (IQR Method)
# -------------------------------
remove_outliers <- function(df) {
  
  # Keep only numeric columns for outlier detection
  numeric_cols <- sapply(df, is.numeric)
  
  # Create a logical vector to keep rows
  keep_rows <- rep(TRUE, nrow(df))
  
  for (col in names(df)[numeric_cols]) {
    
    Q1 <- quantile(df[[col]], 0.25, na.rm = TRUE)
    Q3 <- quantile(df[[col]], 0.75, na.rm = TRUE)
    IQR_value <- IQR(df[[col]], na.rm = TRUE)
    
    lower_bound <- Q1 - 1.5 * IQR_value
    upper_bound <- Q3 + 1.5 * IQR_value
    
    keep_rows <- keep_rows & 
      (df[[col]] >= lower_bound & df[[col]] <= upper_bound)
  }
  
  return(df[keep_rows, ])
}

# -------------------------------
# 4. Apply Outlier Removal
# -------------------------------
cleaned_data <- remove_outliers(data)

# View summary after cleaning
cat("\nSummary AFTER removing outliers:\n")
print(summary(cleaned_data))

# -------------------------------
# 5. Save Cleaned Dataset
# -------------------------------
write.csv(cleaned_data, "Outlier_removed.csv", row.names = FALSE)

cat("\nOutliers removed successfully. Cleaned file saved.\n")

