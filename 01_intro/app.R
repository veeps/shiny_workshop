library(shiny)

ui <- fluidPage(
    h1("Sample of UI elements"),
    actionButton("meow", "Click Here"),
    p("Here are my widgets:"),
    sliderInput(inputId = "slider", # input ID to connect to server
                 label= "Value:", min=0, max=100, value=55),
    selectInput(inputId = "animals", # input ID to connect to server
                label = "Pick an animal", # Text to display on UI
                choices = c("cat", "bear", "dog")),
    radioButtons(inputId= "radio",
                 label = "Select your beverage",
                 choices=c("coffee", "sparkling water", "regular water", "juice", "beer", "wine"))
    
)

server <- function(input, output, session) {
    
}

shinyApp(ui, server)