library(shiny)
library(ggplot2)

shinyUI(fluidPage(
  titlePanel("Keyword search - NSF Award Titles"),
  
  sidebarLayout(
    sidebarPanel(
      textInput('keyword1',
                label="Keyword #1",""),
      textInput('keyword2',
                label="Keyword #2",""),
      textInput('keyword3',
                label="Keyword #3",""),
      br(),
      actionButton('get',"Search")
    ),
    
    mainPanel(
      plotOutput("distPlot"),
      h4("This tool plots the total NSF grant value awarded with titles containing these keywords for each year.  It searches the keyword strings exactly."),
      h4("Ex: try 'superconduct' vs. 'superconductivity', or 'graphene' vs. 'genome'."),
      h6("This is for demonstration purposes only.  As in all scientific research, context is important.  The context of the these terms has not been taken into account.")
    )
  )
))