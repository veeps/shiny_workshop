library(shiny)

ui <- fluidPage(
  fluidRow(),

  fluidRow()
)

server <- function(input, output, session) {
  
  df <- readr::read_csv("../data/citibike-tripdata.csv")
  
  
}

shinyApp(ui, server)