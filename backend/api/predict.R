# =====================================================
# Crop Recommendation API — Plumber
# =====================================================
library(plumber)
library(xgboost)
library(data.table)
library(jsonlite)

#* @filter cors
function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
  res$setHeader("Access-Control-Allow-Headers", "Content-Type")
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$status <- 200
    return(list())
  }
  plumber::forward()
}

# ✅ Fixed: load .json model instead of .model
model <- xgb.load("xgboost_crop.json")
data <- fread("crop_cleaned.csv")
crop_labels <- sort(unique(data$label))
num_class <- length(crop_labels)
rm(data)  # free memory

#* @get /
function() {
  list(status = "Crop Recommendation API is running")
}

#* @post /predict
function(req) {
  input <- jsonlite::fromJSON(req$postBody)

  mat <- matrix(c(
    input$N,
    input$P,
    input$K,
    input$temperature,
    input$humidity,
    input$ph,
    input$rainfall
  ), nrow = 1)

  colnames(mat) <- c("N", "P", "K", "temperature", "humidity", "ph", "rainfall")

  dmat  <- xgb.DMatrix(mat)
  preds <- predict(model, dmat)

  # ✅ Fixed: byrow=FALSE (was TRUE — caused scrambled suitability scores)
  prob_matrix <- matrix(preds, ncol = num_class, byrow = FALSE)
  prob_vector <- as.numeric(prob_matrix[1, ])

  result <- data.frame(
    crop = crop_labels,
    suitability = round(prob_vector * 100, 2),
    stringsAsFactors = FALSE
  )

  top5 <- result[order(result$suitability, decreasing = TRUE), ][1:5, ]

  top5
}

