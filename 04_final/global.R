library(shiny)
library(tidyverse)
#library(scales)
library(DT)
library(plotly)
library(RColorBrewer)


# read in data various options
df <- readr::read_csv("./data/citibike-tripdata.csv") 

sub_df <- df %>%
          filter(usertype == "Subscriber") 

non_sub_df <- df %>%
          filter(usertype == "Customer")

# create a list of all the versions of datasets
datasets <- list(df, sub_df, non_sub_df)


# create summary tables

summary <- df %>%
  group_by(start_station_name) %>%
  summarise(
    total_rides = n(),
    avg_duration=as.integer(mean(tripduration)),
    avg_age = as.integer(mean(age)), 
  ) %>% 
  arrange(desc(total_rides))%>%
  head(10)

# create summary tables

summary_sub <- sub_df %>%
  group_by(start_station_name) %>%
  summarise(
    total_rides = n(),
    avg_duration=as.integer(mean(tripduration)),
    avg_age = as.integer(mean(age)), 
  ) %>% 
  arrange(desc(total_rides))%>%
  head(10)

# create summary tables

summary_non_sub <- non_sub_df %>%
  group_by(start_station_name) %>%
  summarise(
    total_rides = n(),
    avg_duration=as.integer(mean(tripduration)),
    avg_age = as.integer(mean(age)), 
  ) %>% 
  arrange(desc(total_rides))%>%
  head(10)

# list of summary tables
summary_list <- list(summary, summary_sub, summary_non_sub)
