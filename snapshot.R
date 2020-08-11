library(tidyverse)
library(RColorBrewer)
library(circlize)
library(patchwork)
library(viridis)
library(networkD3)

df <- read_csv("data/citibike-tripdata.csv")


head(df)


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
summary %>%
  head(10) %>%
  ggplot(aes(y=avg_duration, x=start_station_name , fill = ifelse(avg_duration > mean(avg_duration), "Over an hour", "Less than an hour"))) + 
  geom_bar(stat="identity", show.legend = F) + scale_fill_manual(values = c('#828282', '#5eff8a')) +
  ggtitle("Average Trip Duration by Start Station", ) + theme(plot.title = element_text(hjust = 0.5)) + 
  ylab("Trip Duration (Seconds)") +
  xlab("Start Station")
  #coord_flip()
  #scale_fill_brewer(palette="Blues")

# plot age distribution
ggplot(df, aes(x = age, fill = usertype, alpha = 0.5)) + geom_density(show.legend = FALSE) + ggtitle("Distribution")

# plot age distribution vioilin plot
ggplot(df, aes(y = age, x = usertype, fill = usertype)) + geom_violin(show.legend=FALSE) + ggtitle("Violin Plot")

# remove outliers for time
df2 <- df %>%
  filter(tripduration <= 3600)

# plot time distribution
ggplot(df2, aes(y = tripduration, x = usertype, fill = usertype)) + geom_violin()


## Create Sankey Graph
df_sankey <- df %>%
  group_by(start_station_name, end_station_name) %>%
  summarise(
    rides = n()
  ) %>%
  filter(start_station_name != end_station_name) %>%
  arrange(-rides) %>%
  head(10) %>%
  as.data.frame()

df_sankey$end_station_name<- paste(df_sankey$end_station_name, " ")


# From these flows we need to create a node data frame: it lists every entities involved in the flow
nodes <- data.frame(name=c(as.character(df_sankey$start_station_name), as.character(df_sankey$end_station_name)) %>% unique())


# With networkD3, connection must be provided using id, not using real name like in the links dataframe.. So we need to reformat it.
df_sankey$start_id=match(df_sankey$start_station_name, nodes$name)-1 
df_sankey$end_id=match(df_sankey$end_station_name, nodes$name)-1



# prepare colour scale
ColourScal ='d3.scaleOrdinal() .range(["#FDE725FF","#B4DE2CFF","#6DCD59FF","#35B779FF","#1F9E89FF","#26828EFF","#31688EFF","#3E4A89FF","#482878FF","#440154FF"])'


# Make the Network
sankeyNetwork(Links = df_sankey, Nodes = nodes,
              Source = "start_id", Target = "end_id",
              Value = "rides", NodeID = "name", 
              sinksRight=FALSE,  nodeWidth=40, fontSize=13, nodePadding=10, )



