# -------------------------------
# 1. Set Working Directory
# -------------------------------
setwd("~/Github/icrs/dataset/")   # Change this

# -------------------------------
# 2. Load Dataset
# -------------------------------
data <- read.csv("Crop_recommendation_cleaned.csv", stringsAsFactors = FALSE)

# -------------------------------
# 3. Function to Print Outliers
# -------------------------------
print_outliers <- function(df) {
  
  numeric_cols <- sapply(df, is.numeric)
  
  for (col in names(df)[numeric_cols]) {
    
    Q1 <- quantile(df[[col]], 0.25, na.rm = TRUE)
    Q3 <- quantile(df[[col]], 0.75, na.rm = TRUE)
    IQR_value <- IQR(df[[col]], na.rm = TRUE)
    
    lower_bound <- Q1 - 1.5 * IQR_value
    upper_bound <- Q3 + 1.5 * IQR_value
    
    outliers <- df[[col]][df[[col]] < lower_bound | df[[col]] > upper_bound]
    
    cat("\n-----------------------------------\n")
    cat("Column:", col, "\n")
    cat("Lower Bound:", lower_bound, "\n")
    cat("Upper Bound:", upper_bound, "\n")
    
    if (length(outliers) == 0) {
      cat("No outliers found.\n")
    } else {
      cat("Outliers:\n")
      print(outliers)
    }
  }
}

# -------------------------------
# 4. Call Function
# -------------------------------
print_outliers(data)

