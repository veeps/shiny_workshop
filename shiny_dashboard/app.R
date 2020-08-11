library(shiny)
library(shinydashboard)
library(tidyverse)
# library(RColorBrewer)
# library(circlize)
# library(patchwork)
# library(viridis)
library(networkD3)


ui <- dashboardPage(
  dashboardHeader(title="Yay Visuals!"),
  dashboardSidebar(sidebarMenu(
    menuItem("Sankey", tabName = "sankey"),
    menuItem("Distribution", tabName = "distribution"),
    menuItem("Scatter", tabName = "scatter")
  )),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "sankey", fluidRow(style="text-align: center", h1("This is a sankey graph")),
              fluidRow(h4(style="text-align: center","See user flow from start station to end station")),
              sankeyNetworkOutput("sankey")),
      # Second tab content
      tabItem(tabName = "distribution", fluidRow(style="text-align: center",h1("Which kind of distribution do you like?")),
              fluidRow(box(plotOutput("dist")),
              box( plotOutput("violin")))),
      # Third tab content
      tabItem(tabName = "scatter", fluidRow(style="text-align: center",h1("Select the Y variable!")),
              fluidRow(column(3, 
                              radioButtons("y_axis", label="Variable", choices=c("Distance"= "distance", "Trip Duration" = "tripduration"))),
                       column(9, plotOutput("scatter"))))
    ))
)

server <- function(input, output) {
  
  # read in data
  df <- readr::read_csv("../data/citibike-tripdata.csv")
  
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
  
  # sankey graph
  output$sankey <- renderSankeyNetwork({
    sankeyNetwork(Links = df_sankey, Nodes = nodes,
                  Source = "start_id", Target = "end_id",
                  Value = "rides", NodeID = "name", 
                  sinksRight=FALSE,  nodeWidth=40, fontSize=13, nodePadding=10, )
  })
  
  # distribution plot
  output$dist <- renderPlot({
    # plot age distribution
    ggplot(df, aes(x = age, fill = usertype, alpha = 0.5)) + geom_density(show.legend = FALSE) + ggtitle("Distribution")
  })
  
  # violin plot
  output$violin <- renderPlot({
    # plot age distribution vioilin plot
    ggplot(df, aes(y = age, x = usertype, fill = usertype)) + geom_violin(show.legend=FALSE) + ggtitle("Violin Plot")
  })
  
  # scatter plot
  output$scatter <- renderPlot({
    # create a scatter plot the ggplot way
    ggplot(df, aes(x= age, y = .data[[input$y_axis]], color = gender)) + geom_point()
  })
  
}

shinyApp(ui, server)