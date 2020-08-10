library(shiny)

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
  
  df <- readr::read_csv("../data/citibike-tripdata.csv")
  
  sub_df <- df %>% filter(usertype == "Subscriber")
  
  non_sub_df <- df %>% filter(usertype == "Customer")
  
  datasets <- list(df, sub_df, non_sub_df)
  
  v <- reactiveValues(data = NULL)
  
  observeEvent(input$all, {
    v$data <- datasets[[1]]
  })
  
  observeEvent(input$sub, {
    v$data <- datasets[[2]]
  })
  
  observeEvent(input$non_sub, {
    v$data <- datasets[[3]]
  })
  
  output$total <- renderText({if (is.null(v$data)) return(nrow(df))
    nrow(v$data)})
  
  output$avg_age <- renderText({if (is.null(v$data)) return(median(df[["age"]]))
    median(v$data[["age"]])})
  
}

shinyApp(ui, server)