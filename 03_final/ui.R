


# Define UI ----
ui <- fluidPage(
        #titlePanel("CitiBike Ridership Data in June 2020"),
        fluidRow(style="background-color: #7cd8c9",
                 column(5,h2(style="padding-left: 40px", "CitiBike June 2020")),
                 column(2,div(style="padding: 20px", actionButton("all", "All Users"))),
                 column(2,div(style="padding: 20px", actionButton("sub", "Subscribers"))),
                 column(2,div(style="padding: 20px", actionButton("non_sub", "Non-Subscribers")))
        ),
        
        fluidRow(style="padding-top:20px; text-align:center",
                 column(6,
                        div(style="background-color: #dedede",
                            icon("bicycle"),
                            h1(textOutput("total")),
                            h3("Total Rides")
                        )),
                 column(6,
                        div(style="background-color: #dedede",
                            icon("birthday-cake"),
                            h1(textOutput("avg_age")),
                            h3("Median Age")
                        ))
                 ),
        

        
        # new row for summary bar chart
        fluidRow(style="padding-top:40px; padding-left: 40px",
                # create side panel with dropdown menu
                column(3, selectInput(inputId="bar_yaxis", #references the input to server
                                      label = h3("Select Variable"), # text that appears on UI
                                      choices=c("Avg Duration" = "avg_duration", "Avg Age"= "avg_age", "Total Rides"= "total_rides"))),
                # plot bar chart
                column(9,plotOutput("bar_plot"))
        ),
        
        
        # new row for scatter plot
        fluidRow(style="padding-left:40px",
          column(3,
                 # Space for text
                 div(
                   h3("Looking at correlation"),
                   p("This is an example of using plotly and show how tooltips work."))),
          # plot chart
          column(9,plotly::plotlyOutput("scatter"))
          ),
        
        # new header row
        fluidRow(style="padding-left:40px",
          DTOutput("summary")
        )
        
)

