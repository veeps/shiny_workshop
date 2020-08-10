library(shiny)
library(tidyverse)
library(DT)
library(plotly)
library(RColorBrewer)
library(reactlog)

ui <- fluidPage(
  



)

server <- function(input, output, session) {
  
  # read in data
  df <- readr::read_csv("../data/citibike-tripdata.csv")

  # create summary table
  summary <- df %>%
    group_by(start_station_name) %>%
    summarise(
      total_rides = n(),
      avg_duration= as.integer(mean(tripduration)),
      avg_age = as.integer(mean(age))
    ) %>%
    arrange(-total_rides) %>%
    head(10)
  
  
  # render data table output
  #output$summary_dt <- renderDT()
  
  
  # render barchart
  #output$bar_plot <- renderPlot({})
  
  
  # exercise - create reactive input for chart title
  
  # create scatterplot
  # output$scatter <- renderPlotly({})
  
  
  
}

shinyApp(ui, server)