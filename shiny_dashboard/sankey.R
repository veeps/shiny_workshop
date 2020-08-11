library(tidyverse)
library(networkD3)

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

# we need to differentiate the start and end station names, so I'm hiding it with an empty space here
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