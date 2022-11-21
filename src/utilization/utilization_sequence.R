## Generate (mock) utilization tracking during routine execution pipelines

mock <- function() {
    mock_lidar_detection <- function() {
        
    }


    raw_data <- data.frame(
        time = seq(0, 100, 1),
        utilization = rnorm(101, 0, 1)
    )
    print(raw_data)
}

print(rnorm(1, 0, 3))
mock()