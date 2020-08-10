library(shiny)


# read in data
df <- readr::read_csv("../data/citibike-tripdata.csv")

# subset data for subscribers
sub_df <- df %>% filter(usertype == "Subscriber")

# subset data for non-subscribers
non_sub_df <- df %>% filter(usertype == "Customer")

# create list of all datasets
datasets <- list(df, sub_df, non_sub_df)