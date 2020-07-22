library(tidyverse)
library(janitor)
library(RColorBrewer)

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
  arrange(-total)

# check unique values for usertype
unique(df$usertype)

# plot histogram
ggplot(head(test, 10), aes(y=avg_duration, x=start_station_name , fill = ifelse(avg_duration > 3000, "Over an hour", "Less than an hour"))) + 
  geom_bar(stat="identity", show.legend = F) + scale_fill_manual(values = c('#828282', '#5eff8a'))
  #coord_flip()
  #scale_colour_manual(name = 'y > 3000', values = setNames(c('red','green'),c(T, F)))
  #scale_fill_brewer(palette="Blues")

# plot distribution
ggplot(df, aes(x = age)) + geom_density()
