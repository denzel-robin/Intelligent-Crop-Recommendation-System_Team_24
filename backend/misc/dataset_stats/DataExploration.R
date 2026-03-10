rm(list = ls())

data <- read.csv("Crop_recommendation.csv")

head(data)
tail(data)

dim(data)
names(data)
str(data)

# Check missing values
colSums(is.na(data))

#duplicate values
sum(duplicated(data))

summary(data)

num_cols <- sapply(data, is.numeric)
numeric_data <- data[, num_cols]

stats <- data.frame(
  Mean = sapply(numeric_data, mean, na.rm = TRUE),
  SD = sapply(numeric_data, sd, na.rm = TRUE),
  Variance = sapply(numeric_data, var, na.rm = TRUE),
  Min = sapply(numeric_data, min, na.rm = TRUE),
  Max = sapply(numeric_data, max, na.rm = TRUE)
)

print(stats)


table(data$label)
prop.table(table(data$label))

# Boxplots
boxplot(data$rainfall)
boxplot(data$temperature)
boxplot(data$humidity)
boxplot(data$ph)

# Correlation matrix
cor_matrix <- cor(numeric_data, use = "complete.obs")
print(cor_matrix)


# Skewness
library(e1071)

sapply(numeric_data, skewness, na.rm = TRUE)

write.csv(stats, "summary_statistics.csv", row.names = TRUE)


