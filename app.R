library(shiny)

ui <- fluidPage(
  p("Good morning everyone!")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)