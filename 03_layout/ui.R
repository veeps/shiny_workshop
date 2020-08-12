ui <- fluidPage(
  fluidRow(style="background-color: #7cd8c9",
           column(6, h2("CitiBike June 2020")),
           column(2, actionButton("all", "All Users")),
           column(2, actionButton("sub", "Subscribers")),
           column(2, actionButton("non_sub", "Non-Subscribers"))
  ),
  
  fluidRow(style = "text-align: center",
           column(6,
                  div(style="background-color: #dedede",
                      h1(textOutput("total")),
                      h3("Total Rides")
                  )),
           column(6,
                  div(style="background-color: #dedede",
                      h1(textOutput("avg_age")),
                      h3("Median Age")
                  ))
  ),
  
  fluidRow(textOutput("text"))
)