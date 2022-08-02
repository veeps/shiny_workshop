server <- function(input, output, session) {
  
  
  
  # create a reactive variable
  v <- reactiveValues(data = NULL)
  
  output$total <- renderText({ if (is.null(v$data)) return(nrow(df)) 
    nrow(v$data)})
  
  output$avg_age <- renderText({ if (is.null(v$data)) return (mean(df[["age"]]))
    mean(v$data[["age"]])})
  
  # Add observe events for the buttons all users
  observeEvent( eventExpr = input$all, { #do something here 
    v$data <- df
    output$text <- renderText({"All"})
  })
  
  # Add observe events for the buttons subscribers 
  observeEvent( eventExpr = input$sub, { #do something here 
    v$data <- df |>
      filter(usertype == "Subscriber")
  })
  
  # Add observe events for the buttons non-subscribers 
  observeEvent( eventExpr = input$non_sub, { #do something here 
    v$data <- df |>
      filter(usertype == "Customer")
  })
  
  
}