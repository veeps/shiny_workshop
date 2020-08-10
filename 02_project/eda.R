library(tidyverse)
library(plotly)

# read in data
df <- readr::read_csv("./data/citibike-tripdata.csv")



# create a summary table


# create a bar plot
ggplot() +
  geom_bar(stat="identity", show.legend=F) +
  ggtitle("Total Rides by Station") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_discrete(labels=function(x){gsub(" ", "\n", summary$start_station_name)})

# create a scatter plot the ggplot way
ggplot() + geom_point()

# create scatter plot with plotly
plot_ly()
