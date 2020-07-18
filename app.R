library(shiny)
library(tidyverse)
#library(scales)
#library(DT)
#library(magrittr)
#library(wesanderson)
#library(plotly)



# Define UI ----
ui <- fluidPage(div(style="padding-left: 200px; padding-right: 200px", 
  titlePanel("Housing Prices in Ames, Iowa"),
  titlePanel(h3("Housing sales by neighborhood")),
  p("For this project, I used the housing data from the Ames Assessor’s Office used to appraise the value for individual properties in 2006 to 2010. The data was split into training and 
              testing data for the Kaggle competition. The data includes 81 features of each housing sale, including some ordinal (quality ratings), some nominal (classification of neighborhood, zone, sale type), 
              and numeric (square feet, year built)."),
  includeCSS("style.css"),
  
  
  fluidRow (div(style="padding: 20px",
    dataTableOutput("table_joe"))
  ),
  
  # Define the sidebar with one input
  sidebarPanel(
    selectInput(inputId="var_joe",
                label = "Select a Variable",
                choices=c("Living Area", "Year Built", "Quality", "Price", "Total Sales")),
    fluidRow(h5(span("1,200")),
             h6(span("Total homes sold")))
  ),
  
  
  mainPanel(
          plotOutput("plot1_joe")),
  
  fluidRow(div(style = "padding-top:500px; padding-left: 20px;", 
            p("Looking at distinct features of the houses and sales by neighborhood. These are the top 5 neighbobrhoods
              that sold the most houses over the years. The original dataset includes more neighborhoods. The oldest house was built in 1872. Data newest house was built in 2010."))),
  
  titlePanel(h3("Housing Sale Prices by Year of House Built")),
  
  fluidRow(plotly::plotlyOutput("scatter_prices")),
  br(div(style="height: 50px")),
  fluidRow(
    column(12,
           fluidRow(column(6,
                           fluidRow(
                             column(6,div(class="container", h6("Highest sale price"), div(h6(class="small", "$611K"), class="semicircle2"))),
                             column(6,div(class="container", h6("Lowest sale price"), div(h6(class="small", "$127K"), class="semicircle")))
                             )
           ),
           fluidRow(column(6,
                           fluidRow(
                             column(6,div(class="container", h6("Avg sale price"), div(h6(class="small", "$181K"), class="semicircle2"))),
                             column(6,div(class="container", h6("Median sale price"), div(h6(class="small", "$162K"), class="semicircle")))
                           )
                ))
           ))
    ),
   br(div(style="height: 50px"))
                  
))


# Define server logic ----
server <- function(input, output) {
  
  #read in data file
  df <- read.csv("data/crime.csv") %>%
    as_data_frame()
  
  
  #get summary table by content type
  neighborhoods <- df %>%
    group_by(neighborhood) %>%
    summarise(
      avg_quality=as.integer(mean(overall_qual)),
      avg_year_built =as.integer(mean(year_built)),
      avg_living_area =as.integer(mean(gr_liv_area)),
      avg_price =as.integer(mean(saleprice)),
      total_sales = n()
    ) %>%   filter(total_sales > 122) %>%
    arrange(-total_sales)
  
  # Parameters for scatter plot
  f <- list(
      family = "Roboto-Bold",
      size = 18,
      color = "#000000"
    )
  x <- list(
    title = "Year Built",
    titlefont = f
  )
  y <- list(
    title = "Sale Price",
    titlefont = f
  )
  
  
  
  #fig %>% layout(showlegend = FALSE ,xaxis = x, yaxis = y) 
  
  
 
  #render data table
  output$table_joe <- renderDataTable(neighborhoods, options=list(info = FALSE, paging = FALSE, searching = FALSE))
  
  #reactive axis and labels
  yaxis1_joe <- reactive({
    if ( "Living Area" %in% input$var_joe) return(neighborhoods$avg_living_area)
    if ( "Quality" %in% input$var_joe) return(neighborhoods$avg_quality)
    if ( "Year Built" %in% input$var_joe) return(neighborhoods$avg_year_built)
    if ( "Price" %in% input$var_joe) return(neighborhoods$avg_price)
    if ( "Total Sales" %in% input$var_joe) return(neighborhoods$total_sales)
  })
  

  graph_title <- reactive({
    if ( "Living Area" %in% input$var_joe) return("Average Living Area per Neighborhood")
    if ( "Quality" %in% input$var_joe) return("Average Quality Area per Neighborhood")
    if ( "Year Built" %in% input$var_joe) return("Average Year Built per Neighborhood")
    if ( "Price" %in% input$var_joe) return("Average Selling Price per Neighborhood")
    if ( "Total Sales" %in% input$var_joe) return("Total Sales per Neighborhood")
  })

  y_label <- reactive({
    if ( "Living Area" %in% input$var_joe) return("Average Living Area")
    if ( "Quality" %in% input$var_joe) return("Average Quality Area")
    if ( "Year Built" %in% input$var_joe) return("Average Year Built")
    if ( "Price" %in% input$var_joe) return("Average Selling Price")
    if ( "Total Sales" %in% input$var_joe) return("Total Sales")
  })

  
  output$plot1_joe <- renderPlot({
    
    # Render a barplot for content summary
    ggplot(neighborhoods, aes(fill=neighborhood, y=yaxis1_joe(), x=neighborhood)) + 
      geom_bar(position="dodge", stat="identity") + ggtitle(graph_title()) + 
      scale_fill_manual(values = wes_palette("Darjeeling2")) + 
      labs(y=y_label()) + labs(x = "Neighborhood") + 
      theme(axis.text.x = element_text(angle = 45),
            legend.title = element_blank(), 
            plot.background = element_rect(colour = "black",size = 1),
            plot.title = element_text(size=22, hjust = 0.5)) 
  })
  
  output$scatter_prices <- renderPlotly({
    plot_ly(data = df, x = ~year_built, y = ~saleprice,
            marker = list(size = 5),
            text = ~paste("Price: ", saleprice, 'Year Built:', year_built),
            color= ~neighborhood,
            colors="Set1",
            alpha=0.7) %>% layout(showlegend=FALSE, xaxis=x, yaxis=y)
  })
  
  
  
}

# Run the app ----
shinyApp(ui = ui, server = server)