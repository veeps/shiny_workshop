library(shiny)
library(tidyverse)
#library(scales)
library(DT)
library(plotly)
library(RColorBrewer)

head(df)


# Define UI ----
ui <- fluidPage(
        #titlePanel("CitiBike Ridership Data in June 2020"),
        fluidRow(style="background-color: #7cd8c9",
                 column(5,h2(style="padding-left: 40px", "CitiBike June 2020")),
                 column(2,div(style="padding: 20px", actionButton("all", "All Users"))),
                 column(2,div(style="padding: 20px", actionButton("sub", "Subscribers"))),
                 column(2,div(style="padding: 20px", actionButton("non_sub", "Non-Subscribers")))
        ),

        
        # new row for summary bar chart
        fluidRow(style="padding-top:40px; padding-left: 40px",
                # create side panel with dropdown menu
                column(3, selectInput(inputId="bar_yaxis", #references the input to server
                                      label = h3("Select Variable"), # text that appears on UI
                                      choices=c("Avg Duration", "Avg Age", "Total Rides"))),
                # plot bar chart
                column(9,plotOutput("bar_plot"))
        ),
        
        
        # new row for scatter plot
        fluidRow(style="padding-left:40px",
          column(3,
                 # create radio buttons
                 div(radioButtons(inputId="xaxis", # references the input from server
                                  label = "X Variable", # Label that appears on UI
                                  choices=c("Age", "Gender")# list of input options
                 ))),
          # plot chart
          column(9,plotly::plotlyOutput("scatter"))
          )
)


# Define server logic ----
server <- function(input, output) {
  
  # read in data file
  df <- read_csv("data/citibike-tripdata.csv")

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
  output$summary <- renderDT(summary, options=list( info = FALSE, paging = TRUE, searching = TRUE))
  
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
  
  # create reactive input for scatter plot x axis
  scatter_x <- reactive({
    if ("Age" %in% input$xaxis) return(df$age)
    if ("Gender" %in% input$bar_yaxis) return(dg$age)
  })
  
  # render scatter plot
  output$scatter <- renderPlotly({
  plot_ly(data = df, x = ~scatter_x(), y = ~tripduration,
      maker=list(size=5),
      text = ~paste("Age:", age, "Trip Duration:", tripduration/60, "min"))
  })
  


  
  
}

# Run the app ----
shinyApp(ui = ui, server = server)