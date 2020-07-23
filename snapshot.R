library(tidyverse)
library(janitor)
library(RColorBrewer)

df <- read_csv("data/JC-202006-citibike-tripdata.csv")

# clean up column names
df <- clean_names(df)

# create an age column
df$age <- 2020 - df$birth_year

# write to csv
write_csv(df, "data/citibike-tripdata.csv", append = FALSE)

# summary stats
summary(df)

# sort date
df %>%
  arrange(desc(starttime)) %>%
  head(5)

#get summary table 
summary<- df %>%
group_by(start_station_name) %>%
  summarise(
    num_rides = n(),
    avg_duration=as.integer(mean(tripduration)),
    avg_age = as.integer(mean(age)), 
    total_subscribers = sum(usertype == "Subscriber"),
    total_customers = sum(usertype == "Customer"),
  ) %>% 
  arrange(-num_rides)

# check unique values for usertype
unique(df$usertype)

# plot histogram
ggplot(head(summary, 10), aes(y=avg_duration, x=start_station_name , fill = ifelse(avg_duration > 3000, "Over an hour", "Less than an hour"))) + 
  geom_bar(stat="identity", show.legend = F) + scale_fill_manual(values = c('#828282', '#5eff8a')) +
  ggtitle("Average Trip Duration by Start Station", ) + theme(plot.title = element_text(hjust = 0.5)) + 
  ylab("Trip Duration (Seconds)") +
  xlab("Start Station")
  #coord_flip()
  #scale_fill_brewer(palette="Blues")

# plot age distribution
ggplot(df, aes(x = age)) + geom_density()

# plot time distribution
ggplot(df, aes(y = age, x = usertype, fill = usertype)) + geom_violin()

# remove outliers for time
df2 <- df %>%
  filter(tripduration <= 3600)

# plot time distribution
ggplot(df2, aes(y = tripduration, x = usertype, fill = usertype)) + geom_violin()
