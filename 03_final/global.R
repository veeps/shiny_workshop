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


