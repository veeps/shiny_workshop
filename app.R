library(shiny)
library(tidyverse)
#library(scales)
library(DT)
library(plotly)
library(RColorBrewer)

head(df)


# Define UI ----
ui <- fluidPage(
        titlePanel("CitiBike Ridership Data in June 2020"),

        
        # new row for summary chart
        fluidRow(
          # plot chart
          column(6,
          plotOutput("bar_plot")
        ),
          column(6,
                 plotOutput("distribution"))
        
        ),
        
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
    ) %>% 
    arrange(-total_rides) %>%
    head(10)
  

  # render data table
  output$summary <- renderDT(summary, options=list( info = FALSE, paging = TRUE, searching = TRUE))

  
  # render a barplot for summary table
  output$bar_plot <- renderPlot({
    
  # plot histogram
  ggplot(summary, aes(y=total_rides, x=start_station_name , fill = ifelse(total_rides > mean(total_rides), T, F))) + 
    geom_bar(stat="identity", show.legend = F) + scale_fill_manual(values = c('#828282', '#5eff8a')) +
    ggtitle("Average Trip Duration by Start Station", ) + theme(plot.title = element_text(hjust = 0.5)) + 
    ylab("Total Rides") +
    xlab("Start Station")
  })
  
  # render scatter plot
  output$scatter <- renderPlotly({
    plot_ly(data = df, x = ~age, y = ~tripduration,
            maker=list(size=5),
            text = ~paste("Age:", age, "Trip Duration:", tripduration/60, "min"))
  })
  
  # plot  distribution
  output$distribution <- renderPlot({
    ggplot(df, aes(y = age, x = gender, fill = gender, alpha = 0.5)) + geom_violin(show.legend = F)
  })

  
  
}

# Run the app ----
shinyApp(ui = ui, server = server)