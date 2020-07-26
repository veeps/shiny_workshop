library(shiny)
library(tidyverse)
#library(scales)
library(DT)
#library(magrittr)
#library(wesanderson)
library(plotly)

head(df)


# Define UI ----
ui <- fluidPage(
        titlePanel("CitiBike Ridership Data in June 2020"),
        
        fluidRow (
          DTOutput("summary")
        ),
        
        # create a sidebbar with one input
        sidebarPanel(
          selectInput(inputId="yaxis", # references the input from server
                      label = "Select a Variable", # Label that appears on UI
                      choices=c("Avg Trip Duration", "Avg Age", "Total Rides", "Total Subscribers", "Total Non-Subscribers")# list of input options
                      )
        ),
        
        mainPanel(
          plotOutput("bar_plot")
        )
        
       # fluidRow (
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
  ggplot(summary, aes(y=bar_y(), x=start_station_name , fill = ifelse(bar_y()> mean(bar_y()), T, F))) + 
    geom_bar(stat="identity", show.legend = F) + scale_fill_manual(values = c('#828282', '#5eff8a')) +
    ggtitle("Average Trip Duration by Start Station", ) + theme(plot.title = element_text(hjust = 0.5)) + 
    ylab("Trip Duration (Seconds)") +
    xlab("Start Station")
  })
  
  # render scatter plot
  output$scatter <- renderPlotly({
    plot_ly(data = df, x = ~age, y = ~tripduration,
            text = ~paste("Age:", age, "Trip Duration:", tripduration/60, "min"))
  })
  
  

  
  
}

# Run the app ----
shinyApp(ui = ui, server = server)