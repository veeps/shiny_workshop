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

        
        # new row for summary bar chart
        fluidRow(style="padding-top:40px; padding-left: 40px",
                # create side panel with dropdown menu
                column(3, selectInput(inputId="bar_yaxis", #references the input to server
                                      label = h3("Select Variable"), # text that appears on UI
                                      choices=c("Avg Duration", "Avg Age", "Total Rides"))),
                # plot bar chart
                column(9,plotOutput("bar_plot"))
        ),
        
        
        # new row for scatter plot
        fluidRow(style="padding-left:40px",
          column(3,
                 # Space for text
                 div(
                   h3("Looking at correlation"),
                   p("This is an example of using plotly and show how tooltips work."))),
          # plot chart
          column(9,plotly::plotlyOutput("scatter"))
          ),
        
        # new header row
        fluidRow(style="padding-left:40px",
                 h3("Summary Table")),
        
        # new row for data table
        fluidRow(style="padding-left:40px",
                 DTOutput("summary"))
        
        
)


# Define server logic ----
server <- function(input, output) {
  
  observeEvent(input$all,{
    df <- readr::read_csv("data/citibike-tripdata.csv")
    source("./plots.R", local = TRUE)
  })
  
  observeEvent(input$sub,{
    df <- readr::read_csv("data/citibike-tripdata.csv") %>%
           filter(usertype == "Subscriber")
    source("./plots.R", local = TRUE)
  })
  
  observeEvent(input$non_sub,{
    df <- readr::read_csv("data/citibike-tripdata.csv") %>%
           filter(usertype == "Customer")
    source("./plots.R", local = TRUE)
  })
  
  # read in data file
  df <- read_csv("data/citibike-tripdata.csv")
  source("./plots.R", local = TRUE)




  
  
}

# Run the app ----
shinyApp(ui = ui, server = server)