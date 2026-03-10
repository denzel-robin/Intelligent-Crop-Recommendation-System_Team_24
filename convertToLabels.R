library(ggplot2)

df <- read.csv("Crop_recommendation_scaled.csv")

cat("Structure before conversion:\n")
str(df)

#do this conversion whenever the dataset is used in any other script
df$label <- as.factor(df$label)

cat("\nStructure after conversion:\n")
str(df$label)

cat("\nClass Counts:\n")
print(table(df$label))

cat("\nClass Distribution (%):\n")
print(prop.table(table(df$label)) * 100)
