FROM rstudio/plumber

RUN R -e "install.packages(c('xgboost','data.table','jsonlite'), repos='https://cloud.r-project.org')"

WORKDIR /app

COPY api api

EXPOSE 8000

CMD ["Rscript", "api/predict.R"]
