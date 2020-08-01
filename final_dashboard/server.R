
# Define server logic ----
server <- function(input, output) {
  
  observeEvent(input$all,{
    source("./plots.R", local = TRUE)
  })
  
  observeEvent(input$sub,{
    df <- sub_df
    source("./plots.R", local = TRUE)
  })
  
  observeEvent(input$non_sub,{
    df <- non_sub_df
    source("./plots.R", local = TRUE)
  })
  
  # read in data file
  source("./plots.R", local = TRUE)
  
  
  
  
  
  
}
