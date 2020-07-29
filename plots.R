# create summary table 
summary<- df %>%
  group_by(start_station_name) %>%
  summarise(
    total_rides = n(),
    avg_duration=as.integer(mean(tripduration)),
    avg_age = as.integer(mean(age)), 
  ) %>% 
  arrange(-total_rides) %>%
  head(10)


# render data table
output$summary <- renderDT(summary, options=list( info = FALSE, paging = F, searching = F))

# create reactive input for bar plot
bar_y <- reactive({
  if ("Avg Duration" %in% input$bar_yaxis) return(summary$avg_duration)
  if ("Avg Age" %in% input$bar_yaxis) return(summary$avg_age)
  if ("Total Rides" %in% input$bar_yaxis) return (summary$total_rides)
})


# render a barplot for summary table
output$bar_plot <- renderPlot({
  ggplot(summary, aes(y=bar_y(), x=start_station_name , fill = ifelse(bar_y() > mean(bar_y()), T, F))) + 
    geom_bar(stat="identity", show.legend = F) + scale_fill_manual(values = c('#828282', '#5eff8a')) +
    ggtitle("Average Trip Duration by Start Station", ) + theme(plot.title = element_text(hjust = 0.5)) + 
    ylab("Total Rides") +
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
