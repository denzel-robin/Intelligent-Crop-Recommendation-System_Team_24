# =====================================================
# Crop Recommendation System (Inference Only)
# Uses Trained XGBoost Model
# =====================================================

library(xgboost)
library(data.table)

# -------------------------------
# 1. Load Trained Model
# -------------------------------
model_path <- "model/xgboost_crop.model"
xgb_model <- xgb.load(model_path)

# -------------------------------
# 2. Load Label Mapping
# (Must be SAME as training)
# -------------------------------
data <- fread("data/processed/crop_cleaned.csv")
crop_labels <- sort(unique(data$label))
num_classes <- length(crop_labels)

cat("Model loaded successfully.\n")
cat("Number of crops:", num_classes, "\n\n")

# -------------------------------
# 3. User Input Interface
# -------------------------------
cat("Enter soil & climate parameters:\n")

N <- as.numeric(readline("Nitrogen (N): "))
P <- as.numeric(readline("Phosphorus (P): "))
K <- as.numeric(readline("Potassium (K): "))
temperature <- as.numeric(readline("Temperature (°C): "))
humidity <- as.numeric(readline("Humidity (%): "))
ph <- as.numeric(readline("pH value: "))
rainfall <- as.numeric(readline("Rainfall (mm): "))

# -------------------------------
# 4. Create Input Matrix
# (Order MUST match training features)
# -------------------------------
input_matrix <- matrix(
  c(N, P, K, temperature, humidity, ph, rainfall),
  nrow = 1
)

colnames(input_matrix) <- c(
  "N", "P", "K",
  "temperature", "humidity", "ph", "rainfall"
)

# -------------------------------
# 5. Convert to DMatrix
# -------------------------------
dinput <- xgb.DMatrix(data = input_matrix)

# -------------------------------
# 6. Predict Suitability Scores
# -------------------------------
pred_prob <- predict(xgb_model, dinput)

pred_df <- data.frame(
  Crop = crop_labels,
  Suitability = round(pred_prob * 100, 2)
)

# Sort by suitability
pred_df <- pred_df[order(-pred_df$Suitability), ]

# -------------------------------
# 7. Show Recommendations
# -------------------------------
TOP_K <- 5

cat("\n🌱 Top", TOP_K, "Recommended Crops:\n")
print(head(pred_df, TOP_K), row.names = FALSE)

cat("\nℹ Suitability scores represent relative confidence.\n")
cat("Choose crops based on market, season, and resources.\n")

# =====================================================
# END
# =====================================================rint(head(df, 5), row.names = FALSE)
