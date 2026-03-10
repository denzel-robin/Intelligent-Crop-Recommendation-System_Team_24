# =====================================================
# Requirements Script
# Intelligent Crop Recommendation System
# =====================================================

required_packages <- c(
  "data.table",
  "caret",
  "xgboost",
  "ggplot2",
  "lattice"
)

install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
}

# Install missing packages
invisible(lapply(required_packages, install_if_missing))

# Load packages
invisible(lapply(required_packages, library, character.only = TRUE))

cat("All required packages are installed and loaded.\n")

