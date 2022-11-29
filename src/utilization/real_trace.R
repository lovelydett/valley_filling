# Analyse the ground-truth core assignment trace of Baidu Apollo
# Yuting@2022.11.29

# Set working directory
setwd("/home/tt/Codes/valley_filling/")


# Turn E-Epress off
options(scipen = 999)

# Load the trace
load_mainboard_log <- function(file_path) {
    df <- read.csv(file_path, header = FALSE, sep = ",")
    print(head(df))
}


# Main
file_path <- "./data/schedule_records/1/log/mainboard.log.INFO.20221126-142555.32603.csv"
df <- load_mainboard_log(file_path)