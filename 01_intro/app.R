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
                 choices=c("coffee", "sparkling water", "regular water", "juice", "beer", "wine")),
    textOutput(outputId = "math"),
    # Copy the line below to make a checkbox
    checkboxInput("checkbox", label = "Choice A", value = TRUE),
    
    hr(),
    fluidRow(column(3, verbatimTextOutput("value"))),
    
    # Copy the line below to make an action button
    actionButton("action", label = "Action"),
    
    hr(),
    fluidRow(column(2, verbatimTextOutput("value")))
    
)

server <- function(input, output, session) {
    output$math <- renderText({5*3})
    
    output$value <- renderPrint({ input$checkbox })
    
    output$value <- renderPrint({ input$action })
}

shinyApp(ui, server)