library(shiny)
library(tidyverse)
library(DT)
library(plotly)
library(RColorBrewer)

ui <- fluidPage(
  
  # # new row for summary bar chart
  # fluidRow(style="padding-top:40px; padding-left: 40px",
  #          # create side panel with dropdown menu
  #          column(3, selectInput(inputId="bar_yaxis", #references the input to server
  #                                label = h3("Select Variable"), # text that appears on UI
  #                                choices=c("Avg Duration", "Avg Age", "Total Rides"))),
  #          # plot bar chart
  #          column(9,plotOutput("bar_plot"))
  # )
  
  fluidRow(plotOutput("bar_plot"))
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
  output$summary <- renderDT(summary, options=list( info = FALSE, paging = F, searching = F))
  
  
  # render barchart
  output$bar_plot <- renderPlot({
    ggplot(summary, aes(x=start_station_name, y = total_rides, fill = start_station_name)) + 
      geom_bar(stat="identity", show.legend=F) +
      ggtitle("Total Rides by Station") + 
      theme(plot.title = element_text(hjust = 0.5)) + 
      scale_x_discrete(labels=function(x){gsub(" ", "\n", summary$start_station_name)}) +
      ylab("Total Rides") +
      xlab("Start Station")
    })
  
}

shinyApp(ui, server)