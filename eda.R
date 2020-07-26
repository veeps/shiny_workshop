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
  plot_x <- reactive({
    if ("Subscriber Type" %in% input$xaxis) return(df$usertype)
    if ("Age" %in% input$xaxis) return(df$age)
    if ("Gender" %in% input$yaxis) return(summary$total_rides)
  })
  
  # create reactive axes and labels
  plot_y <- reactive({
    if ("Trip Duration" %in% input$yaxis) return(df$tripduration)
    if ("Age" %in% input$yaxis) return(df$age)
  })

  
  # render scatter plot
  output$scatter <- renderPlotly({
    plot_ly(data = df, x = ~age, y = ~tripduration,
            maker=list(size=5),
            text = ~paste("Age:", age, "Trip Duration:", tripduration/60, "min"))
  })
  
  # plot  distribution
  output$distribution <- renderPlot({
    ggplot(df, aes(y = plot_y(), x = plot_x(), fill = plot_x())) + geom_violin()
  })


  
  
}

# Run the app ----
shinyApp(ui = ui, server = server)