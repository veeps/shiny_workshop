library(tidyverse)
library(janitor)
df <- read_csv("data/crime.csv")
df <- read_csv("data/JC-202006-citibike-tripdata.csv")

# clean up column names
df <- clean_names(df)

tail(df$birth_year)
colnames(df) 

# create an age column
df$age <- 2020 - df$birth_year

# summary stats
summary(df)

# sort date
df %>%
  arrange(desc(starttime)) %>%
  head(5)

#get summary table by content type
test<- df %>%
group_by(start_station_name) %>%
  summarise(
    total = n(),
    avg_duration=as.integer(mean(tripduration)),
    avg_age = as.integer(mean(age)), 
    total_subscribers = sum(usertype == "Subscriber"),
    total_customers = sum(usertype == "Customer"),
  ) %>% 
  arrange(-total) %>%
  head(5)

# check unique values for usertype
unique(df$usertype)

# plot
ggplot(test, aes(fill=start_station_name, y=avg_duration, x=start_station_name)) + 
  geom_bar(position="dodge", stat="identity") 