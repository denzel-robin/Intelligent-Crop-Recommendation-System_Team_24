FROM rstudio/plumber

RUN R -e "install.packages(c('xgboost','data.table','jsonlite'), repos='https://cloud.r-project.org')"

WORKDIR /app

COPY api api
COPY model model
COPY data data

EXPOSE 8000

CMD ["Rscript", "api/predict.R"]
