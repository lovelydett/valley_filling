# Rinse the mainboard log data to readable CSV files
# Intended format: timestamp, thread1:routine:elapsed, thread2:routine:elapsed, ...
# Yuting@2022-11-29 

import csv
from os.path import join

# Read the mainboard log file
def convert_log_to_csv(log_path):
    log_dir = log_path[:log_path.rfind('/')]
    file_name = log_path.split('/')[-1]
    csv_file = open(join(log_dir, file_name + ".csv"), 'w')
    csv_writer = csv.writer(csv_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    with open(log_path, 'r') as f:
        lines = f.readlines()
        for line in lines:
            line = line.replace(",", "")
            if line.find("scheduler.cc") == -1:
                continue
        
            # Keep only scheduler loggings
            line = line.split()
            try:
                ts = int(line[-1])
            except:
                continue
            
            num_core = len(line) - 6
            csv_writer.writerow([ts] + line[-2-num_core:-2])

def convert_dir(log_dir):
    '''
    Convert all log files in a given directory
    '''
    import os
    for file in os.listdir(log_dir):
        if file.endswith(".csv"):
            continue
        print(f"Converting {join(log_dir, file)}")
        convert_log_to_csv(join(log_dir, file))
    

if __name__ == "__main__":
    # convert_log_to_csv("../../data/schedule_records/1/log/mainboard.log.INFO.20221126-142555.32603")
    convert_dir("../../data/schedule_records/1/log")