server <- function(input, output, session) {
  
  
  
  # create reactive values
  v <- reactiveValues(data = NULL)
  
  observeEvent(input$all, {
    # get the first dataframe in the list
    v$data <- datasets[[1]]
  })
  
  observeEvent(input$sub, {
    # get the second dataframe in the list
    v$data <- datasets[[2]]
  })
  
  observeEvent(input$non_sub, {
    # get the third dataframe in the list
    v$data <- datasets[[3]]
  })
  
  output$total <- renderText({if (is.null(v$data)) return(nrow(df))
    nrow(v$data)})
  
  output$avg_age <- renderText({if (is.null(v$data)) return(median(df[["age"]]))
    median(v$data[["age"]])})
  
}