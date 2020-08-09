library(shiny)
library(reactlog)

reactlog_enable()
ui <- fluidPage(
  actionButton("all", "All Users"),
  verbatimTextOutput("text"),
  actionButton("sub", "Subsribers"),
  verbatimTextOutput("text2"),
  
  DTOutput("table")
)

server <- function(input, output, session) {
 
  
  v <- reactiveValues(data = NULL)
  
  #output$text <- renderText({input$all})
  
  observeEvent(input$all,{
    #output$text <- renderText({"Non-Subscribers"})
    v$data <- readr::read_csv("./data/citibike-tripdata.csv")
  })
  
  observeEvent(input$sub,{
    #output$text2 <- renderText({"Subscribers"})
    v$data <- readr::read_csv("./data/citibike-tripdata.csv") %>% filter(usertype == "Subscriber")
  })

  
  
 # rdf <- reactive({
 #  df %>% filter(usertype ==input$all)
 # })
 #  
 # 
 output$table <- renderDT({ if (is.null(v$data)) return(head(df))
   head(v$data)})
  

}

shinyApp(ui, server)