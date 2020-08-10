library(shiny)
library(tidyverse)
library(DT)
library(plotly)

ui <- fluidPage(
  
    # create side panel with dropdown menu
    fluidRow(
      column(3,div(selectInput(inputId="bar_yaxis", #references the input to server
                               label = h3("Select Variable"), # text that appears on UI
                               choices=c("Avg Duration" = "avg_duration", "Avg Age"="avg_age", "Total Rides"= "total_rides")),
                               actionButton("action", label = "Action"))
      ),
      
    
    # plot bar chart
    column(9,plotOutput("bar_plot"))),
    
    # exercise - rendering scatter plot and datatable output in one row
    fluidRow(
      column(6, plotly::plotlyOutput("scatter")),
      column(6,DTOutput("summary_dt") )
    )


)

server <- function(input, output, session) {
  
  # read in data various options
  df <- readr::read_csv("../data/citibike-tripdata.csv") 
  
  # create summary table 
  summary<- df %>%
    group_by(start_station_name) %>%
    summarise(
      total_rides = n(),
      avg_duration=as.integer(mean(tripduration)),
      avg_age = as.integer(mean(age)), 
    ) %>% 
    arrange(-total_rides) %>%
    head(10)
  
  # render summary tabble
  output$summary_dt <- renderDT({summary}, options=list( info = FALSE, paging = F, searching = F))
  
  # text
  output$text <- renderText({input$bar_yaxis})
  
  # render barchart
  output$bar_plot <- renderPlot({
    ggplot(summary,aes(y=.data[[input$bar_yaxis]], x=start_station_name , fill = start_station_name)) + geom_bar(stat="identity", show.legend=F) +
      ylab(input$bar_yaxis)
  })
  
  # create plotly scatter
  output$scatter <- renderPlotly({
    plot_ly(data = df, x= ~age, y = ~distance,
            type = "scatter")
  })
}

shinyApp(ui, server)