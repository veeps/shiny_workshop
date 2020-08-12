library(shiny)
library(tidyverse)

ui <- fluidPage(
  fluidRow(style="background-color: #7cd8c9",
    column(6, h2("CitiBike June 2020")),
    column(2, actionButton("all", "All Users")),
    column(2, actionButton("sub", "Subscribers")),
    column(2, actionButton("non_sub", "Non-Subscribers"))
  ),

  fluidRow(style = "text-align: center",
    column(6,
           div(style="background-color: #dedede",
             h1(textOutput("total")),
             h3("Total Rides")
           )),
    column(6,
           div(style="background-color: #dedede",
             h1(textOutput("avg_age")),
             h3("Median Age")
           ))
  )
)

server <- function(input, output, session) {
  
  # read in data
  df <- readr::read_csv("../data/citibike-tripdata.csv")
  
  
  # create reactive values
  v <- reactiveValues(data = NULL)
  
  observeEvent(input$all, {
    # all data
    v$data <- df
  })
  
  observeEvent(input$sub, {
    # filter for subscriber
    v$data <- df %>% filter(usertype == "Subscriber")
    
  })
  
  observeEvent(input$non_sub, {
    # filter for customers
    v$data <- df %>% filter(usertype == "Customer")
  })
  
  output$total <- renderText({if (is.null(v$data)) return(nrow(df))
    nrow(v$data)})
  
  output$avg_age <- renderText({if (is.null(v$data)) return(median(df[["age"]]))
    median(v$data[["age"]])})
  
}

shinyApp(ui, server)