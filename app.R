library(shiny)
library(tidyverse)
#library(scales)
library(DT)
#library(magrittr)
#library(wesanderson)
#library(plotly)

head(df)


# Define UI ----
ui <- fluidPage(
        titlePanel("CitiBike Ridership Data in June 2020"),
        
        fluidRow (
          DTOutput("summary")
        ),
        
        fluidRow (
          plotOutput("bar_plot")
        )
)


# Define server logic ----
server <- function(input, output) {
  
  # read in data file
  df <- read_csv("data/citibike-tripdata.csv")

  # create summary table 
  summary<- df %>%
    group_by(start_station_name) %>%
    summarise(
      num_rides = n(),
      avg_duration=as.integer(mean(tripduration)),
      avg_age = as.integer(mean(age)), 
      subscribers = sum(usertype == "Subscriber"),
      non_customers = sum(usertype == "Customer"),
    ) %>% 
    arrange(-num_rides)
  

  # render data table
  output$summary <- renderDT(summary, options=list( info = FALSE, paging = TRUE, searching = TRUE))
  
  # render a barplot for summary table
  output$bar_plot <- renderPlot({
    
    # plot histogram
    ggplot(head(summary, 10), aes(y=avg_duration, x=start_station_name , fill = ifelse(avg_duration > 3000, "Over an hour", "Less than an hour"))) + 
      geom_bar(stat="identity", show.legend = F) + scale_fill_manual(values = c('#828282', '#5eff8a')) +
      ggtitle("Average Trip Duration by Start Station", ) + theme(plot.title = element_text(hjust = 0.5)) + 
      ylab("Trip Duration (Seconds)") +
      xlab("Start Station")
  })
  
  

  
  
}

# Run the app ----
shinyApp(ui = ui, server = server)