# Analyse the ground-truth task-core mapping trace of Baidu Apollo
# Yuting@2022.11.29

# Set working directory
setwd("/home/tt/Codes/valley_filling/")


# Turn E-Epress off
options(scipen = 999)

# Set debugging
IS_DEBUG <- TRUE
DEBUG <- function(msg) {
  if (IS_DEBUG) {
    print(msg)
  }
}

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

draw_gant_graph <- function(df) {
    num_cores <- ncol(df) - 1
    # First sort the data frame by timestamp
    df <- df[order(df$ts), ]

    # Split dataframe by columns
    
    # Convert each core data to start-end time
    {
        for (i in 1:num_cores) {
            core_name <- paste0("core", i)
            df_core <- df[, c("ts", core_name)]
            DEBUG(df_core[1:10, ])
        }
    }


    # Then we need to convert the timestamped data to start-end data
    # Elliminate the row with four idle cores
    df <- df[!(df$core1 == "idle" & df$core2 == "idle" & df$core3 == "idle" & df$core4 == "idle"), ]

}


# Main
dir_path <- "./data/schedule_records/1/log/"
df <- combine_log(dir_path)
draw_gant_graph(df)