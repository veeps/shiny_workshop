# create summary table 
summary<- df  %>%
  group_by(start_station_name) %>%
  summarise(
    total_rides = n(),
    avg_duration=as.integer(mean(tripduration)),
    avg_age = as.integer(mean(age)), 
  ) %>% 
  arrange(desc(total_rides))%>%
  head(10)

# create a total value
output$total <- renderText({scales::comma(nrow(df))})

# create an average age value
output$avg_age <- renderText({round(median(df$age))})

# render data table
output$summary <- renderDT(summary, options=list( info = FALSE, paging = F, searching = F))

# create reactive input for bar plot
# bar_y <- reactive({
#   if ("Avg Duration" %in% input$bar_yaxis) return(summary$avg_duration)
#   if ("Avg Age" %in% input$bar_yaxis) return(summary$avg_age)
#   if ("Total Rides" %in% input$bar_yaxis) return (summary$total_rides)
# })


# render a barplot for summary table
output$bar_plot <- renderPlot({
  ggplot(summary, aes(y=.data[[input$bar_yaxis]], x=start_station_name , fill = ifelse(.data[[input$bar_yaxis]] > mean(.data[[input$bar_yaxis]]), T, F))) + 
    geom_bar(stat="identity", show.legend = F) + scale_fill_manual(values = c('#828282', '#2785bc')) +
    ylab(input$bar_yaxis) +
    xlab("Start Station") +
    scale_x_discrete(labels=function(x){gsub(" ", "\n", summary$start_station_name)})
})

# create custom gradient palette 
#gradient <-colorRampPalette(c("#30cbcf", "#7cd8c9", "#b4e3c5"))

# render scatter plot
output$scatter <- renderPlotly({
  plot_ly(data = df, x = ~age, y = ~distance,
          type="scatter",
          marker=list(size=5),
          mode = "markers", 
          text = ~paste("Age:", age, "Distance:", round(distance,2), "m"))
})
