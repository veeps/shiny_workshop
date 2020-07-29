library(tidyverse)
library(janitor)
library(geosphere)

###### This file is used to prep data for workshop

# read in data
df <- read_csv("data/JC-202006-citibike-tripdata.csv")

# clean up column names
df <- clean_names(df)

# recode gender column
df$gender <- recode_factor(df$gender, `0` = "Unknown", `1` = "Male", `2` = "Female")

# create an age column
df$age <- 2020 - df$birth_year



# filter outliers of tripduration
df <- df %>%
  filter(tripduration <= (mean(df$tripduration) + sd(df$tripduration)))

# calculate distance
df <- mutate(df,
       distance = distHaversine(cbind(start_station_longitude, start_station_latitude),
                                cbind(end_station_longitude, end_station_latitude)))

# write to csv
write_csv(df, "data/citibike-tripdata.csv", append = FALSE)
