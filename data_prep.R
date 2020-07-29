library(tidyverse)
library(janitor)

###### This file is used to prep data for workshop

# read in data
df <- read_csv("data/JC-202006-citibike-tripdata.csv")

# clean up column names
df <- clean_names(df)

# recode gender column
df$gender <- recode_factor(df$gender, `0` = "Unknown", `1` = "Male", `2` = "Female")

# create an age column
df$age <- 2020 - df$birth_year


# create an age column
df$start_station_name <- gsub(" ", "\n", df$start_station_name)


# write to csv
write_csv(df, "data/citibike-tripdata.csv", append = FALSE)
