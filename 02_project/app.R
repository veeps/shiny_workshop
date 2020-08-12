library(shiny)
library(tidyverse)
library(DT)
library(plotly)
library(reactlog)

ui <- fluidPage(
  
  selectInput(
    inputId="bar_yaxis",
    label = ("Select Variable"), # what prints out on screen
    choices=c("Avg Duration" = "avg_duration",
              "Avg Age" = "avg_age",
              "Total Rides" = "total_rides")
  ),
  
  plotOutput(outputId = "bar_plot"),
  
  plotly::plotlyOutput(outputId = "scatter"),
  
  DTOutput(outputId = "summary_dt")


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
  output$summary_dt <- renderDT({summary})
  
  
  # render barchart
  output$bar_plot <- renderPlot({
    ggplot(summary, aes(x= start_station_name, y = .data[[input$bar_yaxis]], fill = start_station_name)) + 
      geom_bar(stat="identity", show.legend=F) + 
      ggtitle("Total Rides by Station") + 
      theme(plot.title = element_text(hjust = 0.5)) +
      ylab(input$bar_yaxis)
      #scale_x_discrete(labels=function(x){gsub(" ", "\n", summary$start_station_name)})
  })
  
  
  # exercise - create reactive input for chart title
  
  # create scatterplot
  output$scatter <- renderPlotly({
    # create scatter plot with plotly
    plot_ly(data = df,x=~age, y=~distance,
            type = "scatter",
            mode = "markers", 
            text= ~paste("Age:", age, "Distance:", round(distance, 2))
    )
  })
  
  
  
}

shinyApp(ui, server)