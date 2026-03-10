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

model <- xgb.load("xgboost_crop.model")
data <- fread("crop_cleaned.csv")
crop_labels <- sort(unique(data$label))

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

  dmat <- xgb.DMatrix(mat)
  preds <- predict(model, dmat)

  num_class <- length(crop_labels)

  prob_matrix <- matrix(preds, ncol = num_class, byrow = TRUE)
  prob_vector <- prob_matrix[1, ]

  result <- data.frame(
    crop = crop_labels,
    suitability = as.numeric(round(prob_vector * 100, 2)),
    stringsAsFactors = FALSE
  )

  top5 <- result[
    order(result$suitability, decreasing = TRUE),
  ][1:5, ]

  # IMPORTANT: return data.frame directly
  top5
}
