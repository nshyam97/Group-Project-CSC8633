## Merging files 

# Import Libraries
library(plyr)
library(tidyverse)
library(lubridate)   # work with dates

mydir = "Stack_2" # Change this to direct to your data directory

# List files 
A_K2 = list.files(path = mydir, pattern = "*A_K2.csv", full.names = TRUE)
B_K2 = list.files(path = mydir, pattern = "*B_K2.csv", full.names = TRUE)
Power = list.files(path = mydir, pattern = "*POWER.csv", full.names = TRUE)
P_demand = list.files(path = mydir, pattern = "*.CSV", full.names = TRUE)

# Read csv
A_df = A_K2 %>% ldply(read.csv) %>% unique() %>% mutate(Time = as.POSIXct(Time, format="%d/%m/%Y %H:%M:%S"))
B_df = B_K2 %>% ldply(read.csv) %>% unique() %>% mutate(Time = as.POSIXct(Time, format="%d/%m/%Y %H:%M:%S"))
Power_df = Power %>% ldply(read.csv) %>% unique() %>% mutate(Time = as.POSIXct(Time, format="%d/%m/%Y %H:%M:%S"))
# Combine the Date and Time columns into a timestamp column
P_demand = P_demand %>% ldply(read.csv) %>% mutate(timestamp= paste(Date,Time)) %>% mutate(timestamp= as.POSIXct(timestamp, format="%Y/%m/%d %H:%M:%S"))

# Removing columns that are not necessary or inaccurate according to "data_dictionary"
# A_df
A_df=A_df[,-1]

# B_df
B_df=B_df[,c(2:14,27:32)]

# Power_df
Power_df=Power_df[,c(2:5,12,14)]

# Remove columns with legacy data from P_demand
P_demand = P_demand[,c(3:12,21)]

# Reorder Columns so "timestamp" is now first
P_demand = P_demand[ , c(ncol(P_demand), 1:(ncol(P_demand)-1))]

# rename "timestamp" to "Time"
names(P_demand)[1] <- "Time"

# Ordering dataframes by time
A_df = arrange(A_df, Time)
B_df = arrange(B_df, Time)
Power_df = arrange(Power_df, Time)
P_demand = arrange(P_demand, Time)

# Save combine data as new csv
write.csv(A_df, "A.csv", row.names = FALSE)
write.csv(B_df, "B.csv", row.names = FALSE)
write.csv(Power_df, "Pow.csv", row.names = FALSE)
write.csv(P_demand, "P_demand.csv", row.names = FALSE)
