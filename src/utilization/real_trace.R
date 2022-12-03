# Analyse the ground-truth task-core mapping trace of Baidu Apollo
# Yuting@2022.11.29

# Import libraries
library(ggplot2)

# Set working directory
# setwd("/home/tt/Codes/valley_filling/")
setwd("/Users/yuting/Codes/valley_filling/")

# Turn E-Epress off
options(scipen = 999)

# Set debugging
IS_DEBUG <- TRUE
DEBUG <- function(msg) {
  if (IS_DEBUG) {
    print(msg)
  }
}

MS_TO_NS <- 1000000

# Load the trace
load_mainboard_log <- function(file_path) {
    DEBUG(file_path)
    df <- read.csv(file_path, header = FALSE, sep = ",")
    # Add column names
    if (ncol(df) - 1 == 4) {
        colnames(df) <- c("ts", "core1", "core2", "core3", "core4")
    } else if (ncol(df) - 1 == 2) {
        colnames(df) <- c("ts", "core1", "core2")
    } else {
        stop("Unsupported number of cores")
    }

    return(df)
}

combine_log <- function(log_dir) {
    log_files <- list.files(log_dir, pattern = "*.csv", full.names = TRUE)
    log_files <- log_files[order(log_files)]
    log_df <- lapply(log_files, load_mainboard_log)
    log_df <- do.call(rbind, log_df)
    return(log_df)
}

get_data <- function(df) {
    num_cores <- ncol(df) - 1
    # First sort the data frame by timestamp
    df <- df[order(df$ts), ]

    # Convert each core data to start-end time
    res = data.frame()
    for (i in 1:num_cores) {
        core_name <- paste0("core", i)
        df_core <- df[, c("ts", core_name)]
        
        for (j in 1:nrow(df_core)) {

            ts = df_core[j, "ts"]
            if (df_core[j, core_name] == "idle") {
                next
            }
            s <- strsplit(df_core[j, core_name], ":")[[1]]
            start <- ts - as.integer(s[2]) * MS_TO_NS
            task <- s[1]
            end <- ts
            res <- rbind(res, c(task, start, end, i))
        }
        
    } 
    colnames(res) <- c("task", "start", "end", "core")
    return(res)
}

# Main
dir_path <- "./data/schedule_records/1/log/"
df <- combine_log(dir_path)
res <- get_data(df)

res <- res[order(res$start), ]
part <- res[(3000 * nrow(res) / 10000):(3010 * nrow(res) / 10000), ]

plot_gantt <-  qplot(xmin = start,
                    xmax = end,
                    y = core,
                    colour = core,
                    geom = "linerange",
                    data = part)

png(paste0("./output/", "gantt.png"), units = "in", width = 20, height = 1, res = 300)
plot(plot_gantt)