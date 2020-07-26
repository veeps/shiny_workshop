library(shiny)
library(tidyverse)
#library(scales)
library(DT)
#library(wesanderson)
library(plotly)
library(shinydashboard)

head(df)


# Define UI ----
ui <- fluidPage(
        titlePanel("EDA Plots for CitiBike Ridership Data"),

        # new row for summary chart
        fluidRow(
          column(3,
        # create radio buttons
        div(radioButtons(inputId="xaxis", # references the input from server
                    label = "X Variable", # Label that appears on UI
                    choices=c("Age", "Subscriber Type", "Gender")# list of input options
                    ),
            radioButtons(inputId="yaxis", # references the input from server
                         label = "Y Variable", # Label that appears on UI
                         choices=c("Trip Duration", "Age")# list of input options
            ))
            
        ),
         # plot chart
          column(9,
          div(
            plotly::plotlyOutput("scatter"),
            plotOutput("distribution"))
        ))
        
       #fluidRow(
        # plotly::plotlyOutput("scatter")
        #)
)


# Define server logic ----
server <- function(input, output) {
  
  # read in data file
  df <- read_csv("data/citibike-tripdata.csv")

  # create reactive axes and labels
  bar_y <- reactive({
    if ("Avg Trip Duration" %in% input$yaxis) return(summary$avg_duration)
    if ("Avg Age" %in% input$yaxis) return(summary$avg_age)
    if ("Total Rides" %in% input$yaxis) return(summary$total_rides)
    if ("Total Subscribers" %in% input$yaxis) return(summary$subscribers)
    if ("Total Non-Subscribers" %in% input$yaxis) return(summary$non_subscribers)
  })

  
  # render scatter plot
  output$scatter <- renderPlotly({
    plot_ly(data = df, x = ~age, y = ~tripduration,
            maker=list(size=5),
            text = ~paste("Age:", age, "Trip Duration:", tripduration/60, "min"))
  })
  
  # plot  distribution
  output$distribution <- renderPlot({
    ggplot(df, aes(y = age, x = usertype, fill = usertype)) + geom_violin()
  })


  
  
}

# Run the app ----
shinyApp(ui = ui, server = server)