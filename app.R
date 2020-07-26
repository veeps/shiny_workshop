library(shiny)
library(tidyverse)
#library(scales)
library(DT)
#library(wesanderson)
library(plotly)
library(networkD3)

head(df)


# Define UI ----
ui <- fluidPage(
        titlePanel("CitiBike Ridership Data in June 2020"),
        
        fluidRow (
          DTOutput("summary")
        ),
        
        # new row for summary chart
        fluidRow(
          column(3,
         # dropdown menu
         selectInput(inputId="yaxis", # references the input from server
                    label = "Select a Variable", # Label that appears on UI
                    choices=c("Avg Trip Duration", "Avg Age", "Total Rides", "Total Subscribers", "Total Non-Subscribers")# list of input options
                    )
        ),
         # plot chart
          column(9,
          plotOutput("bar_plot")
        )),
        
        fluidRow(
          column(3, p("Curious to see what are the most common routes in the dataset, where the start and end stations are different")),
          column(9,sankeyNetworkOutput("sankey"))
          )
        
        
       #fluidRow(
        # plotly::plotlyOutput("scatter")
        #)
)


# Define server logic ----
server <- function(input, output) {
  
  # read in data file
  df <- read_csv("data/citibike-tripdata.csv")

  # create summary table 
  summary<- df %>%
    group_by(start_station_name) %>%
    summarise(
      total_rides = n(),
      avg_duration=as.integer(mean(tripduration)),
      avg_age = as.integer(mean(age)), 
      subscribers = sum(usertype == "Subscriber"),
      non_subscribers = sum(usertype == "Customer"),
    ) %>% 
    arrange(-total_rides) %>%
    head(10)
  

  # render data table
  output$summary <- renderDT(summary, options=list( info = FALSE, paging = TRUE, searching = TRUE))
  
  # create reactive axes and labels
  bar_y <- reactive({
    if ("Avg Trip Duration" %in% input$yaxis) return(summary$avg_duration)
    if ("Avg Age" %in% input$yaxis) return(summary$avg_age)
    if ("Total Rides" %in% input$yaxis) return(summary$total_rides)
    if ("Total Subscribers" %in% input$yaxis) return(summary$subscribers)
    if ("Total Non-Subscribers" %in% input$yaxis) return(summary$non_subscribers)
  })
  
  # render a barplot for summary table
  output$bar_plot <- renderPlot({
    
  # plot histogram
  ggplot(summary, aes(y=bar_y(), x=start_station_name , fill = ifelse(bar_y() > mean(bar_y()), T, F))) + 
    geom_bar(stat="identity", show.legend = F) + scale_fill_manual(values = c('#828282', '#5eff8a')) +
    ggtitle("Average Trip Duration by Start Station", ) + theme(plot.title = element_text(hjust = 0.5)) + 
    ylab("Trip Duration (Seconds)") +
    xlab("Start Station")
  })
  
  # render scatter plot
  output$scatter <- renderPlotly({
    plot_ly(data = df, x = ~age, y = ~tripduration,
            maker=list(size=5),
            text = ~paste("Age:", age, "Trip Duration:", tripduration/60, "min"))
  })
  
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
  output$sankey <- renderSankeyNetwork({sankeyNetwork(Links = df_sankey, Nodes = nodes,
                Source = "start_id", Target = "end_id",
                Value = "rides", NodeID = "name", 
                sinksRight=FALSE,  nodeWidth=40, fontSize=13, nodePadding=10, )})
  
  
  

  
  
}

# Run the app ----
shinyApp(ui = ui, server = server)