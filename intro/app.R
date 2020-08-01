library(shiny)

ui <- fluidPage(
    h1("A Bag of Widgets"),
    actionButton("meow", "Click Here"),
    p("Here are my widgets:"),
    sliderInput(inputId = "slider", # input ID to connect to server
                 label= "Value:", min=0, max=100, value=55),
    selectInput(inputId = "animals", # input ID to connect to server
                label = "Pick an animal", # Text to display on UI
                choices = c("cat", "bear", "dog")),
    #textOutput(outputId = "math")
)

server <- function(input, output, session) {

}

shinyApp(ui, server)