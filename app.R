library(shiny)
library(tidyverse)
#library(scales)
library(DT)
library(plotly)
library(RColorBrewer)

head(df)


# Define UI ----
ui <- fluidPage(
        #titlePanel("CitiBike Ridership Data in June 2020"),
        fluidRow(style="background-color: #7cd8c9",
                 column(5,h2(style="padding-left: 40px", "CitiBike June 2020")),
                 column(2,div(style="padding: 20px", actionButton("all", "All Users"))),
                 column(2,div(style="padding: 20px", actionButton("sub", "Subscribers"))),
                 column(2,div(style="padding: 20px", actionButton("non_sub", "Non-Subscribers")))
        ),

        
        # new row for summary chart
        fluidRow(style="padding-top:40px; padding-left: 40px",
          # plot chart
          column(3, selectInput(inputId="yaxis", #references the input to server
                                label = h3("Select Variable"), # text that appears on UI
                                choices=c("Avg Duration", "Avg Age", "Total Rides"))),
          column(9,plotOutput("bar_plot"))
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
    xlab("Start Station") +
    scale_x_discrete(labels=function(x){gsub(" ", "\n", summary$start_station_name)})
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