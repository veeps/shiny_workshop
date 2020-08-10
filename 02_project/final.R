library(shiny)
library(tidyverse)
library(DT)
library(plotly)

ui <- fluidPage(
  
    # create side panel with dropdown menu
    fluidRow(
      column(3,selectInput(inputId="bar_yaxis", #references the input to server
                               label = h3("Select Variable"), # text that appears on UI
                               choices=c("Avg Duration" = "avg_duration", "Avg Age"="avg_age", "Total Rides"= "total_rides"))),
    
    # plot bar chart
    column(9,plotOutput("bar_plot"))),
    
    # exercise - add text to the side of scatter plot
    fluidRow(
      column(3,h3("Looking at correlation")),
      column(9, plotly::plotlyOutput("scatter"))
    ),
    
    
    fluidRow(
      DTOutput("summary_dt")
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
    ggplot(summary,aes(y=.data[[input$bar_yaxis]], x=start_station_name , fill = ifelse(.data[[input$bar_yaxis]]> mean(.data[[input$bar_yaxis]]), T, F))) + 
      geom_bar(stat="identity", show.legend=F) +
      ylab(input$bar_yaxis) + scale_fill_manual(values = c('#828282', '#2785bc')) +
      scale_x_discrete(labels=function(x){gsub(" ", "\n", summary$start_station_name)})
  })
  
  # create plotly scatter
  output$scatter <- renderPlotly({
    plot_ly(data = df, x= ~age, y = ~distance,
            type = "scatter")
  })
}

shinyApp(ui, server)