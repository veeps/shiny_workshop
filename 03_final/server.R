
# Define server logic ----
server <- function(input, output) {
  
  v <- reactiveValues(data = NULL)
  s <- reactiveValues(data = NULL)

  observeEvent(input$all,{
    v$data <- datasets[[1]]
    s$data <- summary_list[[1]]
  })
  
  observeEvent(input$sub,{
    v$data <- datasets[[2]]
    s$data <- summary_list[[2]]
  })
  
  observeEvent(input$non_sub,{
    v$data <- datasets[[3]]
    s$data <- summary_list[[3]]
  })
  
  # read in data file
  #source("./plots.R", local = TRUE)
  
  
  # create a total value
  output$total <- renderText({if (is.null(v$data)) return(scales::comma(nrow(df)))
    scales::comma(nrow(v$data))
    })
  
  # create an average age value
  output$avg_age <- renderText({if (is.null(v$data)) return(round(median(summary$avg_age)))
    round(median(s$data[["avg_age"]]))})
  
  # render data table
  output$summary <- renderDT({if (is.null(s$data)) return(summary) 
    s$data}, options=list( info = FALSE, paging = F, searching = F))
  
  # create reactive input for bar plot
  # bar_y <- reactive({
  #   if ("Avg Duration" %in% input$bar_yaxis) return(summary$avg_duration)
  #   if ("Avg Age" %in% input$bar_yaxis) return(summary$avg_age)
  #   if ("Total Rides" %in% input$bar_yaxis) return (summary$total_rides)
  # })
  

  
  # render a barplot for summary table
  output$bar_plot <- renderPlot({
    if (is.null(s$data)) return(
      ggplot(summary, aes(y=.data[[input$bar_yaxis]], x=start_station_name , fill = ifelse(.data[[input$bar_yaxis]] > mean(.data[[input$bar_yaxis]]), T, F))) + 
        geom_bar(stat="identity", show.legend = F) + scale_fill_manual(values = c('#828282', '#2785bc')) +
        ylab(input$bar_yaxis) +
        xlab("Start Station") +
        scale_x_discrete(labels=function(x){gsub(" ", "\n", summary[["start_station_name"]])})
    )
    ggplot(s$data, aes(y=s$data[[input$bar_yaxis]], x=start_station_name , fill = ifelse(.data[[input$bar_yaxis]] > mean(.data[[input$bar_yaxis]]), T, F))) + 
      geom_bar(stat="identity", show.legend = F) + scale_fill_manual(values = c('#828282', '#2785bc')) +
      ylab(input$bar_yaxis) +
      xlab("Start Station") +
      scale_x_discrete(labels=function(x){gsub(" ", "\n", s$data[["start_station_name"]])})
  })
  
  # create custom gradient palette 
  #gradient <-colorRampPalette(c("#30cbcf", "#7cd8c9", "#b4e3c5"))
  
  # render scatter plot
  output$scatter <- renderPlotly({if (is.null(v$data)) return(
    plot_ly(data = df, x = ~age, y = ~distance,
            type="scatter",
            marker=list(size=5),
            mode = "markers", 
            text = ~paste("Age:", age, "Distance:", round(distance,2), "m"))
  ) 
    plot_ly(data = v$data, x = ~age, y = ~distance,
            type="scatter",
            marker=list(size=5),
            mode = "markers", 
            text = ~paste("Age:", age, "Distance:", round(distance,2), "m"))
  })
  
  
  
  
  
  
  
}
